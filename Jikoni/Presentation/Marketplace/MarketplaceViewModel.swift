import Foundation
import Observation

@Observable
class MarketplaceViewModel {
    private let vendorRepository: VendorRepository
    private let orderRepository: OrderRepository
    
    var vendors: [Vendor] = []
    var cart: [Ingredient: Int] = [:] // Ingredient and count
    var isLoading: Bool = false
    var isMapView: Bool = false
    var searchQuery: String = ""
    var selectedCuisine: String?
    var showOpenNowOnly: Bool = false
    var selectedDietaryTags: Set<String> = []
    var maxDeliveryMinutes: Int = 60
    var minimumRating: Double = 0
    var selectedPriceRange: String?
    var recentRestaurantIds: [String] = []
    var favoriteRestaurantIds: Set<String> = []
    var favoriteDishIds: Set<String> = []
    var flashDealEndsAt: Date = .now.addingTimeInterval(60 * 30)
    var promoCode: String = ""
    var promoDiscount: Double = 0
    var selectedTip: Double = 0
    var scheduledDelivery: Date? = nil
    var selectedPaymentMethod: String = "M-Pesa STK Push"
    var selectedAddressLabel: String = "Home"
    var mpesaPhone: String = "+254700123456"
    var referralCode: String = "JIKONI-REF-254"
    private let userLocation = Location(latitude: -1.2724, longitude: 36.7723)
    
    var aggregatedCartItems: [Ingredient] {
        cart.keys.sorted { $0.name < $1.name }
    }
    
    var cartItemsByVendor: [String: [Ingredient]] {
        Dictionary(grouping: cart.keys) { $0.vendorId ?? "Unknown" }
    }

    var cuisineChips: [String] {
        ["Nyama Choma", "Swahili", "Pizza", "Burgers", "Breakfast", "Vegan", "Halal", "Gluten-Free"]
    }

    var featuredVendors: [Vendor] {
        vendors.filter { $0.isFeatured }.prefix(6).map { $0 }
    }

    var filteredVendors: [Vendor] {
        vendors.filter { vendor in
            let matchesSearch: Bool
            if searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                matchesSearch = true
            } else {
                let q = searchQuery.lowercased()
                let menuNames = (vendor.inventory ?? [:]).values.flatMap { $0 }.map(\.name).joined(separator: " ").lowercased()
                matchesSearch = vendor.name.lowercased().contains(q) || vendor.cuisine.lowercased().contains(q) || menuNames.contains(q)
            }

            let matchesCuisine = selectedCuisine == nil || vendor.cuisine.lowercased().contains(selectedCuisine!.lowercased())
            let matchesOpenNow = !showOpenNowOnly || vendor.isOpenNow
            let matchesEta = vendor.estimatedDeliveryMinutes <= maxDeliveryMinutes
            let matchesRating = vendor.rating >= minimumRating
            let matchesPrice = selectedPriceRange == nil || vendor.priceRange == selectedPriceRange
            let matchesDietary = selectedDietaryTags.isEmpty || !selectedDietaryTags.isDisjoint(with: Set(vendor.dietaryTags))

            return matchesSearch && matchesCuisine && matchesOpenNow && matchesEta && matchesRating && matchesPrice && matchesDietary
        }
        .sorted { lhs, rhs in
            let lhsDistance = distance(from: userLocation, to: lhs.location)
            let rhsDistance = distance(from: userLocation, to: rhs.location)
            if lhsDistance == rhsDistance {
                return lhs.rating > rhs.rating
            }
            return lhsDistance < rhsDistance
        }
    }
    
    func vendorForId(_ id: String) -> Vendor? {
        vendors.first { $0.id == id }
    }
    
    func totalForVendor(_ vendorId: String) -> Double {
        let items = cart.filter { $0.key.vendorId == vendorId }
        return items.reduce(0) { $0 + ($1.key.price * Double($1.value)) }
    }
    
    var totalCartPrice: Double {
        let itemsTotal = cart.reduce(0) { $0 + ($1.key.price * Double($1.value)) }
        let uniqueVendors = Set(cart.keys.compactMap { $0.vendorId })
        let deliveryFees = uniqueVendors.compactMap { id in vendorForId(id)?.deliveryFee }.reduce(0, +)
        let serviceFee = max(itemsTotal * 0.05, 30)
        return itemsTotal + deliveryFees + serviceFee + selectedTip - promoDiscount
    }
    
    init(vendorRepository: VendorRepository, orderRepository: OrderRepository) {
        self.vendorRepository = vendorRepository
        self.orderRepository = orderRepository
        restoreState()
    }
    
    func fetchVendors() async {
        isLoading = true
        do {
            vendors = try await vendorRepository.fetchVendors()
            restoreCartItemsFromPersistence()
        } catch {
            print("Error fetching vendors: \(error)")
        }
        isLoading = false
    }
    
    func addToCart(ingredient: Ingredient) {
        enforceSingleRestaurantCart(for: ingredient)
        if let count = cart[ingredient] {
            cart[ingredient] = count + 1
        } else {
            cart[ingredient] = 1
        }
        persistCart()
    }
    
    func removeFromCart(ingredient: Ingredient) {
        if let count = cart[ingredient], count > 1 {
            cart[ingredient] = count - 1
        } else {
            cart.removeValue(forKey: ingredient)
        }
        persistCart()
    }
    
    func checkout() async {
        guard !cart.isEmpty else { return }
        
        var orderItems: [Ingredient] = []
        for (ingredient, quantity) in cart {
            for _ in 0..<quantity {
                orderItems.append(ingredient)
            }
        }
        
        let vendorId = cart.keys.compactMap(\.vendorId).first
        let vendor = vendorId.flatMap(vendorForId)
        let subtotal = cart.reduce(0) { $0 + ($1.key.price * Double($1.value)) }
        let serviceFee = max(subtotal * 0.05, 30)

        let order = Order(
            id: UUID().uuidString,
            items: orderItems,
            status: .received,
            total: totalCartPrice,
            restaurantName: vendor?.name ?? "Jikoni Partner",
            createdAt: .now,
            paymentMethod: selectedPaymentMethod,
            subtotal: subtotal,
            serviceFee: serviceFee,
            discount: promoDiscount,
            tip: selectedTip,
            receiptNotes: promoCode.isEmpty ? "" : "Promo Applied: \(promoCode)"
        )
        
        do {
            try await orderRepository.placeOrder(order)
            if let vendorId {
                recentRestaurantIds.removeAll { $0 == vendorId }
                recentRestaurantIds.insert(vendorId, at: 0)
                recentRestaurantIds = Array(recentRestaurantIds.prefix(3))
            }
            cart.removeAll()
            persistCart()
            promoCode = ""
            promoDiscount = 0
            selectedTip = 0
            persistRecent()
        } catch {
            print("Error placing order: \(error)")
        }
    }

    func suggestedSearches() -> [String] {
        let tokens = ["Nyama Choma", "Burgers", "Pizza", "Swahili", "Vegan", "Breakfast", "Coffee"]
        guard !searchQuery.isEmpty else { return tokens }
        return tokens.filter { $0.lowercased().contains(searchQuery.lowercased()) }
    }

    func applyPromoCode() {
        let trimmed = promoCode.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        switch trimmed {
        case "KARIBU10":
            promoDiscount = 100
        case "FLASH50":
            promoDiscount = 50
        case "JIKONI25":
            promoDiscount = 25
        default:
            promoDiscount = 0
        }
    }

    func toggleFavoriteRestaurant(_ vendorId: String) {
        if favoriteRestaurantIds.contains(vendorId) {
            favoriteRestaurantIds.remove(vendorId)
        } else {
            favoriteRestaurantIds.insert(vendorId)
        }
    }

    func isFavoriteRestaurant(_ vendorId: String) -> Bool {
        favoriteRestaurantIds.contains(vendorId)
    }

    func toggleFavoriteDish(_ dishId: String) {
        if favoriteDishIds.contains(dishId) {
            favoriteDishIds.remove(dishId)
        } else {
            favoriteDishIds.insert(dishId)
        }
    }

    func reorder(from order: Order) {
        cart.removeAll()
        for item in order.items {
            cart[item, default: 0] += 1
        }
        persistCart()
    }

    private func enforceSingleRestaurantCart(for ingredient: Ingredient) {
        guard let newVendorId = ingredient.vendorId else { return }
        let existingVendors = Set(cart.keys.compactMap(\.vendorId))
        if !existingVendors.isEmpty && !existingVendors.contains(newVendorId) {
            cart.removeAll()
        }
    }

    private func persistRecent() {
        UserDefaults.standard.set(recentRestaurantIds, forKey: "recentRestaurantIds")
    }

    private func persistCart() {
        let persisted = cart.map { PersistedCartRow(name: $0.key.name, quantity: $0.value) }
        if let data = try? JSONEncoder().encode(persisted) {
            UserDefaults.standard.set(data, forKey: "persistentCartRows")
        }
    }

    private func restoreState() {
        recentRestaurantIds = UserDefaults.standard.stringArray(forKey: "recentRestaurantIds") ?? []
    }

    private func restoreCartItemsFromPersistence() {
        guard cart.isEmpty else { return }
        guard let data = UserDefaults.standard.data(forKey: "persistentCartRows"),
              let rows = try? JSONDecoder().decode([PersistedCartRow].self, from: data) else { return }
        let allIngredients = vendors.flatMap { ($0.inventory ?? [:]).values.flatMap { $0 } }
        for row in rows {
            if let ingredient = allIngredients.first(where: { $0.name == row.name }) {
                cart[ingredient] = row.quantity
            }
        }
    }

    private func distance(from: Location, to: Location) -> Double {
        let dLat = from.latitude - to.latitude
        let dLon = from.longitude - to.longitude
        return (dLat * dLat + dLon * dLon).squareRoot()
    }
}

private struct PersistedCartRow: Codable {
    let name: String
    let quantity: Int
}
