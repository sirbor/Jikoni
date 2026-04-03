import Foundation

class MockVendorRepository: VendorRepository {
    private let vendors: [Vendor] = [
        Vendor(id: "v-1", name: "Mama Juma's African Kitchen", imageUrl: "https://images.unsplash.com/photo-1596040033229-a9821ebd058d?q=80&w=800", deliveryFee: 2.00, rating: 4.9, location: Location(latitude: -1.2863, longitude: 36.8172), inventory: ["Main Dishes": [Ingredient(name: "Beef Pilau", amount: "1 portion", price: 8.50, vendorId: "v-1")], "Sides": [Ingredient(name: "Kachumbari", amount: "1 bowl", price: 2.00, vendorId: "v-1")]]),
        Vendor(id: "v-2", name: "La Trattoria Italiana", imageUrl: "https://images.unsplash.com/photo-1551183053-bf91a1d81141?q=80&w=800", deliveryFee: 3.50, rating: 4.8, location: Location(latitude: -1.3628, longitude: 36.7138), inventory: ["Pasta": [Ingredient(name: "Carbonara", amount: "1 plate", price: 12.00, vendorId: "v-2"), Ingredient(name: "Lasagna", amount: "1 portion", price: 14.50, vendorId: "v-2")]]),
        Vendor(id: "v-3", name: "Szechuan Star Chinese", imageUrl: "https://images.unsplash.com/photo-1525755662778-989d0524087e?q=80&w=800", deliveryFee: 4.00, rating: 4.7, location: Location(latitude: -1.2619, longitude: 36.8049), inventory: ["Stir Fry": [Ingredient(name: "Kung Pao Chicken", amount: "1 portion", price: 11.50, vendorId: "v-3")]]),
        Vendor(id: "v-4", name: "Istanbul Grill & Kebab", imageUrl: "https://images.unsplash.com/photo-1555939594-58d7cb561ad1?q=80&w=800", deliveryFee: 1.50, rating: 4.5, location: Location(latitude: -1.30, longitude: 36.82), inventory: ["Grill": [Ingredient(name: "Adana Kebab", amount: "2 skewers", price: 13.00, vendorId: "v-4")], "Appetizers": [Ingredient(name: "Hummus", amount: "1 bowl", price: 5.50, vendorId: "v-4")]]),
        Vendor(id: "v-5", name: "Aegean Greek Taverna", imageUrl: "https://images.unsplash.com/photo-1512484776495-a09d92e87c3b?q=80&w=800", deliveryFee: 3.00, rating: 4.8, location: Location(latitude: -1.27, longitude: 36.81), inventory: ["Salads": [Ingredient(name: "Greek Salad", amount: "1 bowl", price: 9.50, vendorId: "v-5")], "Pastries": [Ingredient(name: "Spanakopita", amount: "2 pcs", price: 7.00, vendorId: "v-5")]]),
        Vendor(id: "v-6", name: "Tokyo Sushi Zen", imageUrl: "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?q=80&w=800", deliveryFee: 4.50, rating: 4.9, location: Location(latitude: -1.29, longitude: 36.80), inventory: ["Sushi": [Ingredient(name: "Salmon Roll", amount: "8 pcs", price: 15.50, vendorId: "v-6"), Ingredient(name: "Tuna Nigiri", amount: "2 pcs", price: 6.00, vendorId: "v-6")]]),
        Vendor(id: "v-7", name: "Tbilisi Georgian House", imageUrl: "https://images.unsplash.com/photo-1603048588665-791ca8aea617?q=80&w=800", deliveryFee: 5.00, rating: 4.7, location: Location(latitude: -1.31, longitude: 36.78), inventory: ["Baking": [Ingredient(name: "Khachapuri", amount: "1 pc", price: 10.00, vendorId: "v-7")]])
    ] + (8...30).map { i in
        let cuisines = ["Mexican", "Indian", "French", "Vietnamese", "Moroccan", "Brazilian", "Lebanese", "Ethiopian", "Russian"]
        let cuisine = cuisines[i % cuisines.count]
        return Vendor(
            id: "v-\(i)",
            name: "\(cuisine) Restaurant \(i)",
            imageUrl: "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=800",
            deliveryFee: Double.random(in: 1...5),
            rating: Double.random(in: 4...5),
            location: Location(latitude: -1.3 + Double(i)*0.01, longitude: 36.8 + Double(i)*0.01),
            inventory: ["Specialties": [Ingredient(name: "Chef's Selection", amount: "1 portion", price: Double.random(in: 10...25), vendorId: "v-\(i)")]]
        )
    }
    
    func fetchVendors() async throws -> [Vendor] {
        return vendors
    }
    
    func fetchVendor(id: String) async throws -> Vendor? {
        return vendors.first { $0.id == id }
    }
}
