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
    
    var aggregatedCartItems: [Ingredient] {
        cart.keys.sorted { $0.name < $1.name }
    }
    
    var cartItemsByVendor: [String: [Ingredient]] {
        Dictionary(grouping: cart.keys) { $0.vendorId ?? "Unknown" }
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
        return itemsTotal + deliveryFees
    }
    
    init(vendorRepository: VendorRepository, orderRepository: OrderRepository) {
        self.vendorRepository = vendorRepository
        self.orderRepository = orderRepository
    }
    
    func fetchVendors() async {
        isLoading = true
        do {
            vendors = try await vendorRepository.fetchVendors()
        } catch {
            print("Error fetching vendors: \(error)")
        }
        isLoading = false
    }
    
    func addToCart(ingredient: Ingredient) {
        if let count = cart[ingredient] {
            cart[ingredient] = count + 1
        } else {
            cart[ingredient] = 1
        }
    }
    
    func removeFromCart(ingredient: Ingredient) {
        if let count = cart[ingredient], count > 1 {
            cart[ingredient] = count - 1
        } else {
            cart.removeValue(forKey: ingredient)
        }
    }
    
    func checkout() async {
        guard !cart.isEmpty else { return }
        
        var orderItems: [Ingredient] = []
        for (ingredient, quantity) in cart {
            for _ in 0..<quantity {
                orderItems.append(ingredient)
            }
        }
        
        let order = Order(
            id: UUID().uuidString,
            items: orderItems,
            status: .placed,
            total: totalCartPrice
        )
        
        do {
            try await orderRepository.placeOrder(order)
            cart.removeAll()
        } catch {
            print("Error placing order: \(error)")
        }
    }
}
