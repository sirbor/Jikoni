import Foundation

class MockVendorRepository: VendorRepository {
    private let vendors: [Vendor] = [
        Vendor(id: "v-1", name: "Mama Juma's African Kitchen", imageUrls: [
            "https://images.unsplash.com/photo-1596040033229-a9821ebd058d?q=80&w=800",
            "https://images.unsplash.com/photo-1514362545851-46043bc9289b?q=80&w=800",
            "https://images.unsplash.com/photo-1551183053-bf91a1d81141?q=80&w=800"
        ], deliveryFee: 2.00, rating: 4.9, location: Location(latitude: -1.2863, longitude: 36.8172), inventory: ["Specialties": [Ingredient(name: "Beef Pilau", amount: "1 portion", price: 8.50, vendorId: "v-1")]]),
        
        Vendor(id: "v-2", name: "La Trattoria Italiana", imageUrls: [
            "https://images.unsplash.com/photo-1551183053-bf91a1d81141?q=80&w=800",
            "https://images.unsplash.com/photo-1550966841-3ee20412e23e?q=80&w=800",
            "https://images.unsplash.com/photo-1559339352-11d035aa65de?q=80&w=800"
        ], deliveryFee: 3.50, rating: 4.8, location: Location(latitude: -1.3628, longitude: 36.7138), inventory: ["Specialties": [Ingredient(name: "Beef Lasagna", amount: "1 portion", price: 14.50, vendorId: "v-2")]]),
        
        Vendor(id: "v-3", name: "Great Wall Chinese", imageUrls: [
            "https://images.unsplash.com/photo-1525755662778-989d0524087e?q=80&w=800",
            "https://images.unsplash.com/photo-1552566626-52f8b828add9?q=80&w=800",
            "https://images.unsplash.com/photo-1563245372-f21724e3856d?q=80&w=800"
        ], deliveryFee: 4.00, rating: 4.7, location: Location(latitude: -1.2619, longitude: 36.8049), inventory: ["Specialties": [Ingredient(name: "Kung Pao Chicken", amount: "1 portion", price: 11.50, vendorId: "v-3")]]),
        
        Vendor(id: "v-4", name: "Istanbul Grill & Kebab", imageUrls: [
            "https://images.unsplash.com/photo-1555939594-58d7cb561ad1?q=80&w=800",
            "https://images.unsplash.com/photo-1565895405138-6c3a1555da6a?q=80&w=800",
            "https://images.unsplash.com/photo-1473093226795-af9932fe5856?q=80&w=800"
        ], deliveryFee: 1.50, rating: 4.5, location: Location(latitude: -1.30, longitude: 36.82), inventory: ["Specialties": [Ingredient(name: "Adana Kebab", amount: "2 skewers", price: 13.00, vendorId: "v-4")]]),
        
        Vendor(id: "v-5", name: "Aegean Greek Taverna", imageUrls: [
            "https://images.unsplash.com/photo-1512484776495-a09d92e87c3b?q=80&w=800",
            "https://images.unsplash.com/photo-1544148103-6375bc3d9310?q=80&w=800",
            "https://images.unsplash.com/photo-1533777857419-d2d305d7b578?q=80&w=800"
        ], deliveryFee: 3.00, rating: 4.8, location: Location(latitude: -1.27, longitude: 36.81), inventory: ["Specialties": [Ingredient(name: "Spanakopita", amount: "2 pcs", price: 7.00, vendorId: "v-5")]]),
        
        Vendor(id: "v-6", name: "Tokyo Sushi Zen", imageUrls: [
            "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?q=80&w=800",
            "https://images.unsplash.com/photo-1517248135467-d64a6d4c4b5d?q=80&w=800",
            "https://images.unsplash.com/photo-1555396273-fc6723b82a3a?q=80&w=800"
        ], deliveryFee: 4.50, rating: 4.9, location: Location(latitude: -1.29, longitude: 36.80), inventory: ["Specialties": [Ingredient(name: "Salmon Roll", amount: "8 pcs", price: 15.50, vendorId: "v-6")]]),
        
        Vendor(id: "v-7", name: "Tbilisi Georgian House", imageUrls: [
            "https://images.unsplash.com/photo-1603048588665-791ca8aea617?q=80&w=800",
            "https://images.unsplash.com/photo-1560624052-449f5ddf0c31?q=80&w=800",
            "https://images.unsplash.com/photo-1514362545851-46043bc9289b?q=80&w=800"
        ], deliveryFee: 5.00, rating: 4.7, location: Location(latitude: -1.31, longitude: 36.78), inventory: ["Specialties": [Ingredient(name: "Khachapuri", amount: "1 pc", price: 10.00, vendorId: "v-7")]]),
        
        Vendor(id: "v-8", name: "Habesha Restaurant", imageUrls: [
            "https://images.unsplash.com/photo-1548946522-4a313e8972a4?q=80&w=800",
            "https://images.unsplash.com/photo-1514933651103-005eec06c04b?q=80&w=800",
            "https://images.unsplash.com/photo-1414235077428-338989a2e8c0?q=80&w=800"
        ], deliveryFee: 2.50, rating: 4.9, location: Location(latitude: -1.25, longitude: 36.75), inventory: ["Specialties": [Ingredient(name: "Injera Platter", amount: "1 portion", price: 12.00, vendorId: "v-8")]]),
        
        Vendor(id: "v-9", name: "El Taco Loco", imageUrls: [
            "https://images.unsplash.com/photo-1565299585323-38d6b0865b47?q=80&w=800",
            "https://images.unsplash.com/photo-1565299624-94451961502b?q=80&w=800",
            "https://images.unsplash.com/photo-1552332386-f8dd00dc2f85?q=80&w=800"
        ], deliveryFee: 3.00, rating: 4.6, location: Location(latitude: -1.24, longitude: 36.76), inventory: ["Specialties": [Ingredient(name: "Street Tacos", amount: "3 pcs", price: 9.00, vendorId: "v-9")]]),
        
        Vendor(id: "v-10", name: "Curry House", imageUrls: [
            "https://images.unsplash.com/photo-1585937421612-70a008356fbe?q=80&w=800",
            "https://images.unsplash.com/photo-1517248135467-d64a6d4c4b5d?q=80&w=800",
            "https://images.unsplash.com/photo-1502301103665-0b95cc738def?q=80&w=800"
        ], deliveryFee: 3.50, rating: 4.7, location: Location(latitude: -1.23, longitude: 36.77), inventory: ["Specialties": [Ingredient(name: "Butter Chicken", amount: "1 portion", price: 13.50, vendorId: "v-10")]]),
        
        Vendor(id: "v-11", name: "Le Petit Bistro", imageUrls: [
            "https://images.unsplash.com/photo-1551183053-bf91a1d81141?q=80&w=800",
            "https://images.unsplash.com/photo-1550966841-3ee20412e23e?q=80&w=800",
            "https://images.unsplash.com/photo-1551183053-bf91a1d81141?q=80&w=800"
        ], deliveryFee: 4.50, rating: 4.8, location: Location(latitude: -1.22, longitude: 36.78), inventory: ["Specialties": [Ingredient(name: "Steak Frites", amount: "1 portion", price: 18.00, vendorId: "v-11")]]),
        
        Vendor(id: "v-12", name: "Pho 77", imageUrls: [
            "https://images.unsplash.com/photo-1583032353423-04fd96ef2211?q=80&w=800",
            "https://images.unsplash.com/photo-1503767849114-976b67568b02?q=80&w=800",
            "https://images.unsplash.com/photo-1552566626-52f8b828add9?q=80&w=800"
        ], deliveryFee: 2.00, rating: 4.7, location: Location(latitude: -1.21, longitude: 36.79), inventory: ["Specialties": [Ingredient(name: "Beef Pho", amount: "1 bowl", price: 11.00, vendorId: "v-12")]]),
        
        Vendor(id: "v-13", name: "Marrakech Spices", imageUrls: [
            "https://images.unsplash.com/photo-1539755530861-84426be99ca0?q=80&w=800",
            "https://images.unsplash.com/photo-1541544741938-0af808871cc0?q=80&w=800",
            "https://images.unsplash.com/photo-1514362545851-46043bc9289b?q=80&w=800"
        ], deliveryFee: 3.00, rating: 4.5, location: Location(latitude: -1.20, longitude: 36.80), inventory: ["Specialties": [Ingredient(name: "Lamb Tagine", amount: "1 portion", price: 16.50, vendorId: "v-13")]]),
        
        Vendor(id: "v-14", name: "Rio Steakhouse", imageUrls: [
            "https://images.unsplash.com/photo-1547496502-affa22d38842?q=80&w=800",
            "https://images.unsplash.com/photo-1559339352-11d035aa65de?q=80&w=800",
            "https://images.unsplash.com/photo-1517248135467-d64a6d4c4b5d?q=80&w=800"
        ], deliveryFee: 5.00, rating: 4.8, location: Location(latitude: -1.19, longitude: 36.81), inventory: ["Specialties": [Ingredient(name: "Picanha", amount: "1 portion", price: 22.00, vendorId: "v-14")]]),
        
        Vendor(id: "v-15", name: "Beirut Bites", imageUrls: [
            "https://images.unsplash.com/photo-1541544741938-0af808871cc0?q=80&w=800",
            "https://images.unsplash.com/photo-1514933651103-005eec06c04b?q=80&w=800",
            "https://images.unsplash.com/photo-1555396273-fc6723b82a3a?q=80&w=800"
        ], deliveryFee: 2.50, rating: 4.6, location: Location(latitude: -1.18, longitude: 36.82), inventory: ["Specialties": [Ingredient(name: "Falafel Wrap", amount: "1 pc", price: 8.50, vendorId: "v-15")]]),
        
        Vendor(id: "v-16", name: "Moscow Kitchen", imageUrls: [
            "https://images.unsplash.com/photo-1574630758414-996417532a39?q=80&w=800",
            "https://images.unsplash.com/photo-1552566626-52f8b828add9?q=80&w=800",
            "https://images.unsplash.com/photo-1563245372-f21724e3856d?q=80&w=800"
        ], deliveryFee: 3.50, rating: 4.4, location: Location(latitude: -1.17, longitude: 36.83), inventory: ["Specialties": [Ingredient(name: "Beef Stroganoff", amount: "1 portion", price: 15.00, vendorId: "v-16")]]),
        
        Vendor(id: "v-17", name: "Bangkok Street", imageUrls: [
            "https://images.unsplash.com/photo-1559339352-11d035aa65de?q=80&w=800",
            "https://images.unsplash.com/photo-1502301103665-0b95cc738def?q=80&w=800",
            "https://images.unsplash.com/photo-1517248135467-d64a6d4c4b5d?q=80&w=800"
        ], deliveryFee: 2.00, rating: 4.9, location: Location(latitude: -1.16, longitude: 36.84), inventory: ["Specialties": [Ingredient(name: "Pad Thai", amount: "1 portion", price: 10.50, vendorId: "v-17")]]),
        
        Vendor(id: "v-18", name: "Barcelona Tapas", imageUrls: [
            "https://images.unsplash.com/photo-1515443961218-a5136d888be7?q=80&w=800",
            "https://images.unsplash.com/photo-1565895405138-6c3a1555da6a?q=80&w=800",
            "https://images.unsplash.com/photo-1473093226795-af9932fe5856?q=80&w=800"
        ], deliveryFee: 4.00, rating: 4.7, location: Location(latitude: -1.15, longitude: 36.85), inventory: ["Specialties": [Ingredient(name: "Patatas Bravas", amount: "1 bowl", price: 7.50, vendorId: "v-18")]]),
        
        Vendor(id: "v-19", name: "Seoul Soul", imageUrls: [
            "https://images.unsplash.com/photo-1498654896293-37aacf113fd9?q=80&w=800",
            "https://images.unsplash.com/photo-1555396273-fc6723b82a3a?q=80&w=800",
            "https://images.unsplash.com/photo-1517248135467-d64a6d4c4b5d?q=80&w=800"
        ], deliveryFee: 3.00, rating: 4.8, location: Location(latitude: -1.14, longitude: 36.86), inventory: ["Specialties": [Ingredient(name: "Bibimbap", amount: "1 bowl", price: 14.00, vendorId: "v-19")]]),
        
        Vendor(id: "v-20", name: "K-Town BBQ", imageUrls: [
            "https://images.unsplash.com/photo-1529193591184-b1d58069ecdd?q=80&w=800",
            "https://images.unsplash.com/photo-1544148103-6375bc3d9310?q=80&w=800",
            "https://images.unsplash.com/photo-1514933651103-005eec06c04b?q=80&w=800"
        ], deliveryFee: 5.00, rating: 4.9, location: Location(latitude: -1.13, longitude: 36.87), inventory: ["Specialties": [Ingredient(name: "Bulgogi", amount: "1 portion", price: 19.50, vendorId: "v-20")]]),
        
        Vendor(id: "v-21", name: "Andes Grill", imageUrls: [
            "https://images.unsplash.com/photo-1504674900247-0877df9cc836?q=80&w=800",
            "https://images.unsplash.com/photo-1550966841-3ee20412e23e?q=80&w=800",
            "https://images.unsplash.com/photo-1551183053-bf91a1d81141?q=80&w=800"
        ], deliveryFee: 3.00, rating: 4.5, location: Location(latitude: -1.12, longitude: 36.88), inventory: ["Specialties": [Ingredient(name: "Lomo Saltado", amount: "1 portion", price: 17.00, vendorId: "v-21")]]),
        
        Vendor(id: "v-22", name: "Alpine Fondue", imageUrls: [
            "https://images.unsplash.com/photo-1485962391945-448a60359f6b?q=80&w=800",
            "https://images.unsplash.com/photo-1514362545851-46043bc9289b?q=80&w=800",
            "https://images.unsplash.com/photo-1552566626-52f8b828add9?q=80&w=800"
        ], deliveryFee: 6.00, rating: 4.7, location: Location(latitude: -1.11, longitude: 36.89), inventory: ["Specialties": [Ingredient(name: "Cheese Fondue", amount: "2 persons", price: 35.00, vendorId: "v-22")]]),
        
        Vendor(id: "v-23", name: "Sydney Seafront", imageUrls: [
            "https://images.unsplash.com/photo-1551731359-2b3cf8dfd1ce?q=80&w=800",
            "https://images.unsplash.com/photo-1517248135467-d64a6d4c4b5d?q=80&w=800",
            "https://images.unsplash.com/photo-1555396273-fc6723b82a3a?q=80&w=800"
        ], deliveryFee: 4.50, rating: 4.6, location: Location(latitude: -1.10, longitude: 36.90), inventory: ["Specialties": [Ingredient(name: "Barramundi", amount: "1 fillet", price: 21.00, vendorId: "v-23")]]),
        
        Vendor(id: "v-24", name: "Quebec Poutine", imageUrls: [
            "https://images.unsplash.com/photo-1586511925558-a4c6376fe65f?q=80&w=800",
            "https://images.unsplash.com/photo-1563245372-f21724e3856d?q=80&w=800",
            "https://images.unsplash.com/photo-1552332386-f8dd00dc2f85?q=80&w=800"
        ], deliveryFee: 2.50, rating: 4.5, location: Location(latitude: -1.09, longitude: 36.91), inventory: ["Specialties": [Ingredient(name: "Classic Poutine", amount: "1 bowl", price: 9.50, vendorId: "v-24")]]),
        
        Vendor(id: "v-25", name: "Lisbon Seafood", imageUrls: [
            "https://images.unsplash.com/photo-1534080564607-198f9dd5d61a?q=80&w=800",
            "https://images.unsplash.com/photo-1502301103665-0b95cc738def?q=80&w=800",
            "https://images.unsplash.com/photo-1544148103-6375bc3d9310?q=80&w=800"
        ], deliveryFee: 4.00, rating: 4.8, location: Location(latitude: -1.08, longitude: 36.92), inventory: ["Specialties": [Ingredient(name: "Bacalhau", amount: "1 portion", price: 19.00, vendorId: "v-25")]]),
        
        Vendor(id: "v-26", name: "Copenhagen Nordic", imageUrls: [
            "https://images.unsplash.com/photo-1559339352-11d035aa65de?q=80&w=800",
            "https://images.unsplash.com/photo-1514933651103-005eec06c04b?q=80&w=800",
            "https://images.unsplash.com/photo-1555396273-fc6723b82a3a?q=80&w=800"
        ], deliveryFee: 5.50, rating: 4.7, location: Location(latitude: -1.07, longitude: 36.93), inventory: ["Specialties": [Ingredient(name: "Smørrebrød", amount: "3 pcs", price: 15.00, vendorId: "v-26")]]),
        
        Vendor(id: "v-27", name: "Vienna Pastry", imageUrls: [
            "https://images.unsplash.com/photo-1488477181946-6428a0291777?q=80&w=800",
            "https://images.unsplash.com/photo-1552566626-52f8b828add9?q=80&w=800",
            "https://images.unsplash.com/photo-1517248135467-d64a6d4c4b5d?q=80&w=800"
        ], deliveryFee: 2.00, rating: 4.9, location: Location(latitude: -1.06, longitude: 36.94), inventory: ["Specialties": [Ingredient(name: "Sachertorte", amount: "1 slice", price: 7.50, vendorId: "v-27")]]),
        
        Vendor(id: "v-28", name: "Caribbean Heat", imageUrls: [
            "https://images.unsplash.com/photo-1533777857419-d2d305d7b578?q=80&w=800",
            "https://images.unsplash.com/photo-1514362545851-46043bc9289b?q=80&w=800",
            "https://images.unsplash.com/photo-1551183053-bf91a1d81141?q=80&w=800"
        ], deliveryFee: 3.50, rating: 4.6, location: Location(latitude: -1.05, longitude: 36.95), inventory: ["Specialties": [Ingredient(name: "Jerk Chicken", amount: "1 portion", price: 12.50, vendorId: "v-28")]]),
        
        Vendor(id: "v-29", name: "Bali Bowls", imageUrls: [
            "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=800",
            "https://images.unsplash.com/photo-1544148103-6375bc3d9310?q=80&w=800",
            "https://images.unsplash.com/photo-1514933651103-005eec06c04b?q=80&w=800"
        ], deliveryFee: 3.00, rating: 4.8, location: Location(latitude: -1.04, longitude: 36.96), inventory: ["Specialties": [Ingredient(name: "Nasi Goreng", amount: "1 bowl", price: 11.50, vendorId: "v-29")]]),
        
        Vendor(id: "v-30", name: "Cairo Kitchen", imageUrls: [
            "https://images.unsplash.com/photo-1567156942642-4f96446e502c?q=80&w=800",
            "https://images.unsplash.com/photo-1552332386-f8dd00dc2f85?q=80&w=800",
            "https://images.unsplash.com/photo-1555396273-fc6723b82a3a?q=80&w=800"
        ], deliveryFee: 2.50, rating: 4.5, location: Location(latitude: -1.03, longitude: 36.97), inventory: ["Specialties": [Ingredient(name: "Koshary", amount: "1 bowl", price: 9.00, vendorId: "v-30")]])
    ]
    
    func fetchVendors() async throws -> [Vendor] {
        return vendors
    }
    
    func fetchVendor(id: String) async throws -> Vendor? {
        return vendors.first { $0.id == id }
    }
}
