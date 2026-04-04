import Foundation

class MockVendorRepository: VendorRepository {
    private let vendors: [Vendor] = [
        // Muthaiga
        Vendor(id: "v-1", name: "Mama Juma's African Kitchen", cuisine: "Swahili", imageUrls: [
            "https://images.unsplash.com/photo-1596040033229-a9821ebd058d?q=80&w=800"
        ], deliveryFee: 2.00, rating: 4.9, location: Location(latitude: -1.2524, longitude: 36.8223), inventory: [
            "Soups": [
                Ingredient(name: "Swahili Goat Soup", amount: "Bowl", price: 7.50, vendorId: "v-1"),
                Ingredient(name: "Creamy Pumpkin Soup", amount: "Bowl", price: 6.50, vendorId: "v-1"),
                Ingredient(name: "Lentil Shurba", amount: "Bowl", price: 5.50, vendorId: "v-1")
            ],
            "Meals": [
                Ingredient(name: "Traditional Beef Pilau", amount: "1 portion", price: 12.50, vendorId: "v-1"),
                Ingredient(name: "Coconut Fish Curry", amount: "1 portion", price: 15.00, vendorId: "v-1"),
                Ingredient(name: "Swahili Grilled Chicken", amount: "1 portion", price: 14.00, vendorId: "v-1"),
                Ingredient(name: "Vegetable Biryani", amount: "1 portion", price: 11.00, vendorId: "v-1"),
                Ingredient(name: "Nyama Choma Platter", amount: "500g", price: 18.50, vendorId: "v-1"),
                Ingredient(name: "Ugali & Sukuma Wiki", amount: "1 portion", price: 9.00, vendorId: "v-1")
            ],
            "Drinks": [
                Ingredient(name: "Dawa Signature", amount: "Cocktail", price: 8.50, vendorId: "v-1"),
                Ingredient(name: "Swahili Sunset", amount: "Cocktail", price: 9.00, vendorId: "v-1"),
                Ingredient(name: "Tamarind Refresher", amount: "Mocktail", price: 5.50, vendorId: "v-1"),
                Ingredient(name: "Hibiscus Chill", amount: "Lemonade", price: 5.00, vendorId: "v-1"),
                Ingredient(name: "Mango Lassi Shake", amount: "Milkshake", price: 6.50, vendorId: "v-1"),
                Ingredient(name: "Kenyan Coffee Brew", amount: "Caffeine", price: 4.50, vendorId: "v-1"),
                Ingredient(name: "Tusker Lager", amount: "Beer", price: 5.50, vendorId: "v-1")
            ]
        ]),
        
        // Westlands
        Vendor(id: "v-2", name: "La Trattoria Italiana", cuisine: "Italian", imageUrls: [
            "https://images.unsplash.com/photo-1551183053-bf91a1d81141?q=80&w=800"
        ], deliveryFee: 3.50, rating: 4.8, location: Location(latitude: -1.2619, longitude: 36.8049), inventory: [
            "Soups": [
                Ingredient(name: "Classic Minestrone", amount: "Bowl", price: 8.50, vendorId: "v-2"),
                Ingredient(name: "Roasted Tomato Basil", amount: "Bowl", price: 7.50, vendorId: "v-2"),
                Ingredient(name: "Italian Wedding Soup", amount: "Bowl", price: 9.00, vendorId: "v-2")
            ],
            "Meals": [
                Ingredient(name: "Classic Beef Lasagna", amount: "1 portion", price: 16.50, vendorId: "v-2"),
                Ingredient(name: "Spaghetti Carbonara", amount: "1 portion", price: 14.00, vendorId: "v-2"),
                Ingredient(name: "Margherita Pizza", amount: "12 inch", price: 13.00, vendorId: "v-2"),
                Ingredient(name: "Truffle Risotto", amount: "1 portion", price: 19.00, vendorId: "v-2"),
                Ingredient(name: "Chicken Parmigiana", amount: "1 portion", price: 17.50, vendorId: "v-2"),
                Ingredient(name: "Osso Buco", amount: "1 portion", price: 22.00, vendorId: "v-2")
            ],
            "Drinks": [
                Ingredient(name: "Negroni", amount: "Cocktail", price: 10.00, vendorId: "v-2"),
                Ingredient(name: "Aperol Spritz", amount: "Cocktail", price: 9.50, vendorId: "v-2"),
                Ingredient(name: "Virgin Sangria", amount: "Mocktail", price: 6.50, vendorId: "v-2"),
                Ingredient(name: "Lemon Basil Soda", amount: "Lemonade", price: 6.00, vendorId: "v-2"),
                Ingredient(name: "Stracciatella Shake", amount: "Milkshake", price: 7.50, vendorId: "v-2"),
                Ingredient(name: "Double Espresso", amount: "Caffeine", price: 4.00, vendorId: "v-2"),
                Ingredient(name: "Peroni Nastro Azzurro", amount: "Beer", price: 6.50, vendorId: "v-2")
            ]
        ]),
        
        // Karen
        Vendor(id: "v-3", name: "Great Wall Chinese", cuisine: "Chinese", imageUrls: [
            "https://images.unsplash.com/photo-1525755662778-989d0524087e?q=80&w=800"
        ], deliveryFee: 4.00, rating: 4.7, location: Location(latitude: -1.3196, longitude: 36.7065), inventory: [
            "Soups": [
                Ingredient(name: "Hot & Sour Soup", amount: "Bowl", price: 7.00, vendorId: "v-3"),
                Ingredient(name: "Wonton Soup", amount: "Bowl", price: 8.00, vendorId: "v-3"),
                Ingredient(name: "Sweet Corn & Chicken", amount: "Bowl", price: 7.50, vendorId: "v-3")
            ],
            "Meals": [
                Ingredient(name: "Spicy Kung Pao Chicken", amount: "1 portion", price: 14.50, vendorId: "v-3"),
                Ingredient(name: "Peking Duck Rolls", amount: "4 pcs", price: 16.00, vendorId: "v-3"),
                Ingredient(name: "Beef with Broccoli", amount: "1 portion", price: 15.00, vendorId: "v-3"),
                Ingredient(name: "Dim Sum Platter", amount: "8 pcs", price: 18.00, vendorId: "v-3"),
                Ingredient(name: "Mapo Tofu", amount: "1 portion", price: 12.00, vendorId: "v-3"),
                Ingredient(name: "Yangzhou Fried Rice", amount: "1 portion", price: 11.00, vendorId: "v-3")
            ],
            "Drinks": [
                Ingredient(name: "Lychee Martini", amount: "Cocktail", price: 11.00, vendorId: "v-3"),
                Ingredient(name: "Baijiu Punch", amount: "Cocktail", price: 12.00, vendorId: "v-3"),
                Ingredient(name: "Dragon Fruit Fizz", amount: "Mocktail", price: 6.00, vendorId: "v-3"),
                Ingredient(name: "Ginger Jasmine Tea", amount: "Caffeine", price: 5.50, vendorId: "v-3"),
                Ingredient(name: "Tsingtao Beer", amount: "Beer", price: 6.00, vendorId: "v-3"),
                Ingredient(name: "Oolong Milk Tea", amount: "Milkshake", price: 6.50, vendorId: "v-3"),
                Ingredient(name: "Plum Lemonade", amount: "Lemonade", price: 5.50, vendorId: "v-3")
            ]
        ]),
        
        // Runda
        Vendor(id: "v-4", name: "Istanbul Grill & Kebab", cuisine: "Turkish", imageUrls: [
            "https://images.unsplash.com/photo-1555939594-58d7cb561ad1?q=80&w=800"
        ], deliveryFee: 1.50, rating: 4.5, location: Location(latitude: -1.2224, longitude: 36.8123), inventory: [
            "Soups": [
                Ingredient(name: "Mercimek Corbasi (Lentil)", amount: "Bowl", price: 6.00, vendorId: "v-4"),
                Ingredient(name: "Yayla Corbasi (Yogurt)", amount: "Bowl", price: 6.50, vendorId: "v-4"),
                Ingredient(name: "Tavuk Suyu (Chicken)", amount: "Bowl", price: 7.00, vendorId: "v-4")
            ],
            "Meals": [
                Ingredient(name: "Turkish Adana Kebab", amount: "2 skewers", price: 15.00, vendorId: "v-4"),
                Ingredient(name: "Lamb Shish Kebab", amount: "2 skewers", price: 17.00, vendorId: "v-4"),
                Ingredient(name: "Lahmacun", amount: "2 pcs", price: 12.00, vendorId: "v-4"),
                Ingredient(name: "Iskender Kebab", amount: "1 portion", price: 18.50, vendorId: "v-4"),
                Ingredient(name: "Meze Platter", amount: "Large", price: 20.00, vendorId: "v-4"),
                Ingredient(name: "Turkish Pide", amount: "1 pc", price: 13.00, vendorId: "v-4")
            ],
            "Drinks": [
                Ingredient(name: "Raki Sour", amount: "Cocktail", price: 10.50, vendorId: "v-4"),
                Ingredient(name: "Istanbul Mule", amount: "Cocktail", price: 9.50, vendorId: "v-4"),
                Ingredient(name: "Pomegranate Spritz", amount: "Mocktail", price: 6.00, vendorId: "v-4"),
                Ingredient(name: "Ayran Delight", amount: "Mocktail", price: 4.50, vendorId: "v-4"),
                Ingredient(name: "Turkish Coffee", amount: "Caffeine", price: 5.00, vendorId: "v-4"),
                Ingredient(name: "Efes Pilsener", amount: "Beer", price: 6.50, vendorId: "v-4"),
                Ingredient(name: "Rose Lemonade", amount: "Lemonade", price: 5.50, vendorId: "v-4")
            ]
        ]),
        
        // Lavington
        Vendor(id: "v-5", name: "Aegean Greek Taverna", cuisine: "Greek", imageUrls: [
            "https://images.unsplash.com/photo-1512484776495-a09d92e87c3b?q=80&w=800"
        ], deliveryFee: 3.00, rating: 4.8, location: Location(latitude: -1.2724, longitude: 36.7723), inventory: [
            "Soups": [
                Ingredient(name: "Avgolemono (Lemon-Egg)", amount: "Bowl", price: 8.00, vendorId: "v-5"),
                Ingredient(name: "Fasolada (Bean)", amount: "Bowl", price: 7.00, vendorId: "v-5"),
                Ingredient(name: "Psarosoupa (Fish)", amount: "Bowl", price: 10.50, vendorId: "v-5")
            ],
            "Meals": [
                Ingredient(name: "Greek Spanakopita", amount: "2 pcs", price: 11.00, vendorId: "v-5"),
                Ingredient(name: "Moussaka", amount: "1 portion", price: 16.00, vendorId: "v-5"),
                Ingredient(name: "Lamb Souvlaki", amount: "3 skewers", price: 18.00, vendorId: "v-5"),
                Ingredient(name: "Greek Salad", amount: "Large", price: 10.00, vendorId: "v-5"),
                Ingredient(name: "Grilled Octopus", amount: "1 portion", price: 24.00, vendorId: "v-5"),
                Ingredient(name: "Pastitsio", amount: "1 portion", price: 15.50, vendorId: "v-5")
            ],
            "Drinks": [
                Ingredient(name: "Ouzo Breeze", amount: "Cocktail", price: 9.00, vendorId: "v-5"),
                Ingredient(name: "Aegean Mist", amount: "Cocktail", price: 10.00, vendorId: "v-5"),
                Ingredient(name: "Cucumber Cooler", amount: "Mocktail", price: 5.50, vendorId: "v-5"),
                Ingredient(name: "Greek Frappé Martini", amount: "Caffeine", price: 6.00, vendorId: "v-5"),
                Ingredient(name: "Mythos Beer", amount: "Beer", price: 6.50, vendorId: "v-5"),
                Ingredient(name: "Honey Baklava Shake", amount: "Milkshake", price: 8.00, vendorId: "v-5"),
                Ingredient(name: "Mint Lemonade", amount: "Lemonade", price: 5.00, vendorId: "v-5")
            ]
        ]),
        
        // Westlands
        Vendor(id: "v-6", name: "Tokyo Sushi Zen", cuisine: "Japanese", imageUrls: [
            "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?q=80&w=800"
        ], deliveryFee: 4.50, rating: 4.9, location: Location(latitude: -1.2654, longitude: 36.8012), inventory: [
            "Soups": [
                Ingredient(name: "Miso Soup Special", amount: "Bowl", price: 5.00, vendorId: "v-6"),
                Ingredient(name: "Spicy Seafood Udon", amount: "Bowl", price: 12.00, vendorId: "v-6"),
                Ingredient(name: "Clear Dashi Broth", amount: "Bowl", price: 4.50, vendorId: "v-6")
            ],
            "Meals": [
                Ingredient(name: "Salmon Sushi Rolls", amount: "8 pcs", price: 18.00, vendorId: "v-6"),
                Ingredient(name: "Dragon Roll Special", amount: "8 pcs", price: 22.00, vendorId: "v-6"),
                Ingredient(name: "Wagyu Beef Tataki", amount: "1 portion", price: 35.00, vendorId: "v-6"),
                Ingredient(name: "Miso Glazed Black Cod", amount: "1 portion", price: 28.00, vendorId: "v-6"),
                Ingredient(name: "Shrimp Tempura Platter", amount: "6 pcs", price: 16.00, vendorId: "v-6"),
                Ingredient(name: "Tonkotsu Ramen", amount: "1 bowl", price: 15.50, vendorId: "v-6")
            ],
            "Drinks": [
                Ingredient(name: "Sake Gimlet", amount: "Cocktail", price: 12.00, vendorId: "v-6"),
                Ingredient(name: "Matcha Highball", amount: "Cocktail", price: 13.00, vendorId: "v-6"),
                Ingredient(name: "Yuzu Lemonade", amount: "Lemonade", price: 6.50, vendorId: "v-6"),
                Ingredient(name: "Cherry Blossom Tonic", amount: "Mocktail", price: 7.00, vendorId: "v-6"),
                Ingredient(name: "Asahi Super Dry", amount: "Beer", price: 7.00, vendorId: "v-6"),
                Ingredient(name: "Black Sesame Shake", amount: "Milkshake", price: 8.50, vendorId: "v-6"),
                Ingredient(name: "Sencha Tea", amount: "Caffeine", price: 4.50, vendorId: "v-6")
            ]
        ]),
        
        // Muthaiga
        Vendor(id: "v-7", name: "Tbilisi Georgian House", cuisine: "Georgian", imageUrls: [
            "https://images.unsplash.com/photo-1603048588665-791ca8aea617?q=80&w=800"
        ], deliveryFee: 5.00, rating: 4.7, location: Location(latitude: -1.2484, longitude: 36.8252), inventory: [
            "Soups": [
                Ingredient(name: "Kharcho Beef Soup", amount: "Bowl", price: 9.50, vendorId: "v-7"),
                Ingredient(name: "Chikhirtma (Chicken)", amount: "Bowl", price: 8.50, vendorId: "v-7"),
                Ingredient(name: "Mushroom Soup Bowl", amount: "Bowl", price: 7.50, vendorId: "v-7")
            ],
            "Meals": [
                Ingredient(name: "Georgian Khachapuri", amount: "1 pc", price: 14.00, vendorId: "v-7"),
                Ingredient(name: "Khinkali Dumplings", amount: "5 pcs", price: 12.50, vendorId: "v-7"),
                Ingredient(name: "Chakhokhbili Stew", amount: "1 portion", price: 15.00, vendorId: "v-7"),
                Ingredient(name: "Badrijani Nigvzit", amount: "4 pcs", price: 10.00, vendorId: "v-7"),
                Ingredient(name: "Shashlik Grilled Meat", amount: "1 portion", price: 18.00, vendorId: "v-7"),
                Ingredient(name: "Lobio in Clay Pot", amount: "1 portion", price: 11.50, vendorId: "v-7")
            ],
            "Drinks": [
                Ingredient(name: "Chacha Sour", amount: "Cocktail", price: 11.00, vendorId: "v-7"),
                Ingredient(name: "Georgian Wine Spritz", amount: "Cocktail", price: 9.50, vendorId: "v-7"),
                Ingredient(name: "Tarragon Soda", amount: "Lemonade", price: 5.00, vendorId: "v-7"),
                Ingredient(name: "Pear & Spice Refresher", amount: "Mocktail", price: 5.50, vendorId: "v-7"),
                Ingredient(name: "Borjomi Water Platter", amount: "Drink", price: 4.00, vendorId: "v-7"),
                Ingredient(name: "Honey Walnut Shake", amount: "Milkshake", price: 7.50, vendorId: "v-7"),
                Ingredient(name: "Strong Black Tea", amount: "Caffeine", price: 3.50, vendorId: "v-7")
            ]
        ]),
        
        // Karen
        Vendor(id: "v-8", name: "Habesha Restaurant", cuisine: "Ethiopian", imageUrls: [
            "https://images.unsplash.com/photo-1548946522-4a313e8972a4?q=80&w=800"
        ], deliveryFee: 2.50, rating: 4.9, location: Location(latitude: -1.3324, longitude: 36.7123), inventory: [
            "Soups": [
                Ingredient(name: "Spiced Lentil Soup", amount: "Bowl", price: 6.50, vendorId: "v-8"),
                Ingredient(name: "Ethiopian Veggie Broth", amount: "Bowl", price: 6.00, vendorId: "v-8"),
                Ingredient(name: "Barley Soup (Besso)", amount: "Bowl", price: 7.00, vendorId: "v-8")
            ],
            "Meals": [
                Ingredient(name: "Habesha Injera Platter", amount: "1 portion", price: 18.00, vendorId: "v-8"),
                Ingredient(name: "Doro Wat Stew", amount: "1 portion", price: 16.50, vendorId: "v-8"),
                Ingredient(name: "Kitfo Special", amount: "1 portion", price: 19.00, vendorId: "v-8"),
                Ingredient(name: "Vegetarian Beyaynetu", amount: "1 portion", price: 14.00, vendorId: "v-8"),
                Ingredient(name: "Tibs Fried Beef", amount: "1 portion", price: 17.50, vendorId: "v-8"),
                Ingredient(name: "Shiro Wat", amount: "1 portion", price: 12.00, vendorId: "v-8")
            ],
            "Drinks": [
                Ingredient(name: "Tej Honey Wine", amount: "Cocktail", price: 8.50, vendorId: "v-8"),
                Ingredient(name: "Ethiopian Spiced Mule", amount: "Cocktail", price: 9.50, vendorId: "v-8"),
                Ingredient(name: "Buna Martini (Virgin)", amount: "Caffeine", price: 6.00, vendorId: "v-8"),
                Ingredient(name: "Mango Berbere Fizz", amount: "Mocktail", price: 5.50, vendorId: "v-8"),
                Ingredient(name: "St George Beer", amount: "Beer", price: 5.50, vendorId: "v-8"),
                Ingredient(name: "Avocado & Date Shake", amount: "Milkshake", price: 7.00, vendorId: "v-8"),
                Ingredient(name: "Spiced Tea Platter", amount: "Caffeine", price: 4.50, vendorId: "v-8")
            ]
        ]),
        
        // Runda
        Vendor(id: "v-9", name: "El Taco Loco", cuisine: "Mexican", imageUrls: [
            "https://images.unsplash.com/photo-1565299585323-38d6b0865b47?q=80&w=800"
        ], deliveryFee: 3.00, rating: 4.6, location: Location(latitude: -1.2154, longitude: 36.8182), inventory: [
            "Soups": [
                Ingredient(name: "Sopa de Tortilla", amount: "Bowl", price: 7.50, vendorId: "v-9"),
                Ingredient(name: "Pozole Rojo", amount: "Bowl", price: 9.00, vendorId: "v-9"),
                Ingredient(name: "Mexican Lime Soup", amount: "Bowl", price: 7.00, vendorId: "v-9")
            ],
            "Meals": [
                Ingredient(name: "Mexican Street Tacos", amount: "3 pcs", price: 12.50, vendorId: "v-9"),
                Ingredient(name: "Beef Birria Consomé", amount: "1 portion", price: 15.00, vendorId: "v-9"),
                Ingredient(name: "Enchiladas Verdes", amount: "3 pcs", price: 14.00, vendorId: "v-9"),
                Ingredient(name: "Carne Asada Plate", amount: "1 portion", price: 18.50, vendorId: "v-9"),
                Ingredient(name: "Chiles Rellenos", amount: "2 pcs", price: 16.00, vendorId: "v-9"),
                Ingredient(name: "Guacamole & Chips Special", amount: "Large", price: 9.00, vendorId: "v-9")
            ],
            "Drinks": [
                Ingredient(name: "Classic Margarita", amount: "Cocktail", price: 10.00, vendorId: "v-9"),
                Ingredient(name: "Paloma", amount: "Cocktail", price: 10.50, vendorId: "v-9"),
                Ingredient(name: "Horchata Chill", amount: "Milkshake", price: 5.50, vendorId: "v-9"),
                Ingredient(name: "Jamaica Hibiscus Water", amount: "Mocktail", price: 5.00, vendorId: "v-9"),
                Ingredient(name: "Corona Extra", amount: "Beer", price: 6.00, vendorId: "v-9"),
                Ingredient(name: "Spiced Mexican Mocha", amount: "Caffeine", price: 6.50, vendorId: "v-9"),
                Ingredient(name: "Pineapple Jalapeno Soda", amount: "Lemonade", price: 5.50, vendorId: "v-9")
            ]
        ]),
        
        // Lavington
        Vendor(id: "v-10", name: "Curry House", cuisine: "Indian", imageUrls: [
            "https://images.unsplash.com/photo-1585937421612-70a008356fbe?q=80&w=800"
        ], deliveryFee: 3.50, rating: 4.7, location: Location(latitude: -1.2854, longitude: 36.7623), inventory: [
            "Soups": [
                Ingredient(name: "Mulligatawny Soup", amount: "Bowl", price: 7.00, vendorId: "v-10"),
                Ingredient(name: "Tomato Rasam", amount: "Bowl", price: 5.50, vendorId: "v-10"),
                Ingredient(name: "Dal Shorba", amount: "Bowl", price: 6.00, vendorId: "v-10")
            ],
            "Meals": [
                Ingredient(name: "Indian Butter Chicken", amount: "1 portion", price: 15.50, vendorId: "v-10"),
                Ingredient(name: "Lamb Rogan Josh", amount: "1 portion", price: 17.50, vendorId: "v-10"),
                Ingredient(name: "Paneer Tikka Masala", amount: "1 portion", price: 14.00, vendorId: "v-10"),
                Ingredient(name: "Chicken Biryani (Dum)", amount: "1 portion", price: 16.00, vendorId: "v-10"),
                Ingredient(name: "Tandoori Platter", amount: "Large", price: 22.00, vendorId: "v-10"),
                Ingredient(name: "Dal Makhani & Naan", amount: "1 portion", price: 12.50, vendorId: "v-10")
            ],
            "Drinks": [
                Ingredient(name: "Mumbai Mule", amount: "Cocktail", price: 10.50, vendorId: "v-10"),
                Ingredient(name: "Goan Punch", amount: "Cocktail", price: 11.00, vendorId: "v-10"),
                Ingredient(name: "Mango Lassi Bliss", amount: "Milkshake", price: 6.00, vendorId: "v-10"),
                Ingredient(name: "Rose Sherbet", amount: "Lemonade", price: 5.50, vendorId: "v-10"),
                Ingredient(name: "Masala Chai Hot", amount: "Caffeine", price: 4.00, vendorId: "v-10"),
                Ingredient(name: "Kingfisher Lager", amount: "Beer", price: 6.00, vendorId: "v-10"),
                Ingredient(name: "Cardamom Iced Latte", amount: "Caffeine", price: 6.50, vendorId: "v-10")
            ]
        ]),
        
        // Westlands
        Vendor(id: "v-11", name: "Le Petit Bistro", cuisine: "French", imageUrls: [
            "https://images.unsplash.com/photo-1551183053-bf91a1d81141?q=80&w=800"
        ], deliveryFee: 4.50, rating: 4.8, location: Location(latitude: -1.2584, longitude: 36.8082), inventory: [
            "Soups": [
                Ingredient(name: "French Onion Soup", amount: "Bowl", price: 10.00, vendorId: "v-11"),
                Ingredient(name: "Crème de Champignons", amount: "Bowl", price: 9.00, vendorId: "v-11"),
                Ingredient(name: "Lobster Bisque", amount: "Bowl", price: 14.50, vendorId: "v-11")
            ],
            "Meals": [
                Ingredient(name: "French Steak Frites", amount: "1 portion", price: 24.00, vendorId: "v-11"),
                Ingredient(name: "Duck Confit", amount: "1 portion", price: 28.00, vendorId: "v-11"),
                Ingredient(name: "Bouillabaisse Special", amount: "1 bowl", price: 32.00, vendorId: "v-11"),
                Ingredient(name: "Coq au Vin", amount: "1 portion", price: 22.50, vendorId: "v-11"),
                Ingredient(name: "Ratatouille Provencal", amount: "1 portion", price: 18.00, vendorId: "v-11"),
                Ingredient(name: "Escargots de Bourgogne", amount: "6 pcs", price: 15.00, vendorId: "v-11")
            ],
            "Drinks": [
                Ingredient(name: "French 75", amount: "Cocktail", price: 13.00, vendorId: "v-11"),
                Ingredient(name: "Kir Royale", amount: "Cocktail", price: 14.00, vendorId: "v-11"),
                Ingredient(name: "Sparkling Lavender", amount: "Mocktail", price: 7.50, vendorId: "v-11"),
                Ingredient(name: "Citron Pressé", amount: "Lemonade", price: 6.00, vendorId: "v-11"),
                Ingredient(name: "Chocolat Chaud", amount: "Milkshake", price: 8.00, vendorId: "v-11"),
                Ingredient(name: "Café au Lait", amount: "Caffeine", price: 5.50, vendorId: "v-11"),
                Ingredient(name: "Kronenbourg 1664", amount: "Beer", price: 7.00, vendorId: "v-11")
            ]
        ]),
        
        // Muthaiga
        Vendor(id: "v-12", name: "Pho 77", cuisine: "Vietnamese", imageUrls: [
            "https://images.unsplash.com/photo-1583032353423-04fd96ef2211?q=80&w=800"
        ], deliveryFee: 2.00, rating: 4.7, location: Location(latitude: -1.2424, longitude: 36.8323), inventory: [
            "Soups": [
                Ingredient(name: "Beef Pho Broth", amount: "Bowl", price: 10.00, vendorId: "v-12"),
                Ingredient(name: "Chicken Glass Noodle", amount: "Bowl", price: 9.00, vendorId: "v-12"),
                Ingredient(name: "Hot & Sour Fish Soup", amount: "Bowl", price: 11.50, vendorId: "v-12")
            ],
            "Meals": [
                Ingredient(name: "Vietnamese Beef Pho", amount: "1 bowl", price: 14.50, vendorId: "v-12"),
                Ingredient(name: "Banh Mi Special", amount: "1 sandwich", price: 11.00, vendorId: "v-12"),
                Ingredient(name: "Spring Rolls (Nem)", amount: "4 pcs", price: 9.50, vendorId: "v-12"),
                Ingredient(name: "Bun Cha Hanoi", amount: "1 portion", price: 16.00, vendorId: "v-12"),
                Ingredient(name: "Lemongrass Chicken", amount: "1 portion", price: 15.00, vendorId: "v-12"),
                Ingredient(name: "Claypot Fish", amount: "1 portion", price: 18.00, vendorId: "v-12")
            ],
            "Drinks": [
                Ingredient(name: "Hanoi Highball", amount: "Cocktail", price: 10.50, vendorId: "v-12"),
                Ingredient(name: "Saigon Gin Fizz", amount: "Cocktail", price: 11.50, vendorId: "v-12"),
                Ingredient(name: "Lotus Flower Tea", amount: "Mocktail", price: 5.50, vendorId: "v-12"),
                Ingredient(name: "Vietnamese Iced Coffee", amount: "Caffeine", price: 6.00, vendorId: "v-12"),
                Ingredient(name: "333 Premium Beer", amount: "Beer", price: 6.50, vendorId: "v-12"),
                Ingredient(name: "Avocado Smoothie", amount: "Milkshake", price: 7.50, vendorId: "v-12"),
                Ingredient(name: "Kumquat Lemonade", amount: "Lemonade", price: 5.00, vendorId: "v-12")
            ]
        ]),
        
        // Karen
        Vendor(id: "v-13", name: "Marrakech Spices", cuisine: "Moroccan", imageUrls: [
            "https://images.unsplash.com/photo-1539755530861-84426be99ca0?q=80&w=800"
        ], deliveryFee: 3.00, rating: 4.5, location: Location(latitude: -1.3424, longitude: 36.7223), inventory: [
            "Soups": [
                Ingredient(name: "Harira Traditional", amount: "Bowl", price: 7.50, vendorId: "v-13"),
                Ingredient(name: "Moroccan Carrot Soup", amount: "Bowl", price: 6.50, vendorId: "v-13"),
                Ingredient(name: "Bissara (Fava Bean)", amount: "Bowl", price: 6.00, vendorId: "v-13")
            ],
            "Meals": [
                Ingredient(name: "Moroccan Lamb Tagine", amount: "1 portion", price: 22.00, vendorId: "v-13"),
                Ingredient(name: "Chicken Pastilla", amount: "1 pc", price: 18.00, vendorId: "v-13"),
                Ingredient(name: "Vegetable Couscous", amount: "1 portion", price: 15.00, vendorId: "v-13"),
                Ingredient(name: "Harira Soup Special", amount: "1 bowl", price: 10.50, vendorId: "v-13"),
                Ingredient(name: "Kofta Kebab Plate", amount: "1 portion", price: 19.50, vendorId: "v-13"),
                Ingredient(name: "Moroccan Salad Trio", amount: "Large", price: 12.00, vendorId: "v-13")
            ],
            "Drinks": [
                Ingredient(name: "Casablanca Sour", amount: "Cocktail", price: 11.00, vendorId: "v-13"),
                Ingredient(name: "Atlas Sunset", amount: "Cocktail", price: 12.00, vendorId: "v-13"),
                Ingredient(name: "Mint Tea Mojito (Virgin)", amount: "Mocktail", price: 6.50, vendorId: "v-13"),
                Ingredient(name: "Orange Blossom Spritz", amount: "Lemonade", price: 6.00, vendorId: "v-13"),
                Ingredient(name: "Moroccan Spiced Shake", amount: "Milkshake", price: 7.50, vendorId: "v-13"),
                Ingredient(name: "Mint Tea Hot", amount: "Caffeine", price: 4.50, vendorId: "v-13"),
                Ingredient(name: "Casablanca Beer", amount: "Beer", price: 7.00, vendorId: "v-13")
            ]
        ]),
        
        // Runda
        Vendor(id: "v-14", name: "Rio Steakhouse", cuisine: "Brazilian", imageUrls: [
            "https://images.unsplash.com/photo-1547496502-affa22d38842?q=80&w=800"
        ], deliveryFee: 5.00, rating: 4.8, location: Location(latitude: -1.2024, longitude: 36.8282), inventory: [
            "Soups": [
                Ingredient(name: "Caldo de Feijão", amount: "Bowl", price: 8.00, vendorId: "v-14"),
                Ingredient(name: "Brazilian Shrimp Soup", amount: "Bowl", price: 11.50, vendorId: "v-14"),
                Ingredient(name: "Canja de Galinha", amount: "Bowl", price: 7.50, vendorId: "v-14")
            ],
            "Meals": [
                Ingredient(name: "Brazilian Picanha Steak", amount: "1 portion", price: 28.00, vendorId: "v-14"),
                Ingredient(name: "Feijoada Stew", amount: "1 portion", price: 22.00, vendorId: "v-14"),
                Ingredient(name: "Coxinha Platter", amount: "6 pcs", price: 14.00, vendorId: "v-14"),
                Ingredient(name: "Moqueca Fish Stew", amount: "1 portion", price: 26.00, vendorId: "v-14"),
                Ingredient(name: "Grilled Pineapple Ham", amount: "1 portion", price: 12.00, vendorId: "v-14"),
                Ingredient(name: "Brazilian Cheese Bread", amount: "8 pcs", price: 10.50, vendorId: "v-14")
            ],
            "Drinks": [
                Ingredient(name: "Caipirinha Classic", amount: "Cocktail", price: 11.00, vendorId: "v-14"),
                Ingredient(name: "Batida de Coco", amount: "Cocktail", price: 12.00, vendorId: "v-14"),
                Ingredient(name: "Guarana Cooler", amount: "Mocktail", price: 5.50, vendorId: "v-14"),
                Ingredient(name: "Passion Fruit Refresco", amount: "Lemonade", price: 6.00, vendorId: "v-14"),
                Ingredient(name: "Brahma Beer", amount: "Beer", price: 6.50, vendorId: "v-14"),
                Ingredient(name: " Brigadeiro Shake", amount: "Milkshake", price: 8.50, vendorId: "v-14"),
                Ingredient(name: "Brazilian Strong Roast", amount: "Caffeine", price: 5.00, vendorId: "v-14")
            ]
        ]),
        
        // Lavington
        Vendor(id: "v-15", name: "Beirut Bites", cuisine: "Lebanese", imageUrls: [
            "https://images.unsplash.com/photo-1541544741938-0af808871cc0?q=80&w=800"
        ], deliveryFee: 2.50, rating: 4.6, location: Location(latitude: -1.2954, longitude: 36.7723), inventory: [
            "Soups": [
                Ingredient(name: "Lentil Soup (Shorbat Adas)", amount: "Bowl", price: 6.50, vendorId: "v-15"),
                Ingredient(name: "Lebanese Veggie Soup", amount: "Bowl", price: 6.00, vendorId: "v-15"),
                Ingredient(name: "Chicken & Vermicelli", amount: "Bowl", price: 7.50, vendorId: "v-15")
            ],
            "Meals": [
                Ingredient(name: "Lebanese Falafel Wrap", amount: "1 pc", price: 11.50, vendorId: "v-15"),
                Ingredient(name: "Chicken Shish Tawook", amount: "2 skewers", price: 16.50, vendorId: "v-15"),
                Ingredient(name: "Kibbeh Special", amount: "4 pcs", price: 14.00, vendorId: "v-15"),
                Ingredient(name: "Hummus & Lamb", amount: "Large", price: 15.00, vendorId: "v-15"),
                Ingredient(name: "Tabbouleh Salad", amount: "Large", price: 9.50, vendorId: "v-15"),
                Ingredient(name: "Mixed Grill Mezze", amount: "Platter", price: 25.00, vendorId: "v-15")
            ],
            "Drinks": [
                Ingredient(name: "Beirut Mule", amount: "Cocktail", price: 10.50, vendorId: "v-15"),
                Ingredient(name: "Arak Sour", amount: "Cocktail", price: 11.50, vendorId: "v-15"),
                Ingredient(name: "Jallab Dream", amount: "Mocktail", price: 6.00, vendorId: "v-15"),
                Ingredient(name: "Rose Water Fizz", amount: "Lemonade", price: 5.50, vendorId: "v-15"),
                Ingredient(name: "Almaza Pilsner", amount: "Beer", price: 6.50, vendorId: "v-15"),
                Ingredient(name: "Baklava Milkshake", amount: "Milkshake", price: 8.00, vendorId: "v-15"),
                Ingredient(name: "Lebanese Cardamom Coffee", amount: "Caffeine", price: 4.50, vendorId: "v-15")
            ]
        ]),
        
        // Westlands
        Vendor(id: "v-16", name: "Moscow Kitchen", cuisine: "Russian", imageUrls: [
            "https://images.unsplash.com/photo-1574630758414-996417532a39?q=80&w=800"
        ], deliveryFee: 3.50, rating: 4.4, location: Location(latitude: -1.2554, longitude: 36.8152), inventory: [
            "Soups": [
                Ingredient(name: "Traditional Borscht", amount: "Bowl", price: 8.50, vendorId: "v-16"),
                Ingredient(name: "Solyanka Meat Soup", amount: "Bowl", price: 10.50, vendorId: "v-16"),
                Ingredient(name: "Shchi (Cabbage Soup)", amount: "Bowl", price: 7.50, vendorId: "v-16")
            ],
            "Meals": [
                Ingredient(name: "Russian Beef Stroganoff", amount: "1 portion", price: 21.00, vendorId: "v-16"),
                Ingredient(name: "Borscht Soup Special", amount: "1 bowl", price: 12.50, vendorId: "v-16"),
                Ingredient(name: "Pelmeni Dumplings", amount: "12 pcs", price: 15.00, vendorId: "v-16"),
                Ingredient(name: "Chicken Kiev", amount: "1 portion", price: 19.50, vendorId: "v-16"),
                Ingredient(name: "Piroshki Selection", amount: "3 pcs", price: 11.00, vendorId: "v-16"),
                Ingredient(name: "Blini with Salmon", amount: "3 pcs", price: 18.00, vendorId: "v-16")
            ],
            "Drinks": [
                Ingredient(name: "White Russian", amount: "Cocktail", price: 12.00, vendorId: "v-16"),
                Ingredient(name: "Moscow Mule", amount: "Cocktail", price: 11.50, vendorId: "v-16"),
                Ingredient(name: "Berry Kvass", amount: "Mocktail", price: 5.50, vendorId: "v-16"),
                Ingredient(name: "Birch Water Tonic", amount: "Lemonade", price: 6.00, vendorId: "v-16"),
                Ingredient(name: "Baltika Beer", amount: "Beer", price: 7.00, vendorId: "v-16"),
                Ingredient(name: "Russian Honey Shake", amount: "Milkshake", price: 8.00, vendorId: "v-16"),
                Ingredient(name: "Ivan Chai", amount: "Caffeine", price: 4.50, vendorId: "v-16")
            ]
        ]),
        
        // Muthaiga
        Vendor(id: "v-17", name: "Bangkok Street", cuisine: "Thai", imageUrls: [
            "https://images.unsplash.com/photo-1559339352-11d035aa65de?q=80&w=800"
        ], deliveryFee: 2.00, rating: 4.9, location: Location(latitude: -1.2354, longitude: 36.8382), inventory: [
            "Soups": [
                Ingredient(name: "Tom Yum Goong", amount: "Bowl", price: 9.50, vendorId: "v-17"),
                Ingredient(name: "Tom Kha Gai", amount: "Bowl", price: 8.50, vendorId: "v-17"),
                Ingredient(name: "Thai Noodle Soup", amount: "Bowl", price: 8.00, vendorId: "v-17")
            ],
            "Meals": [
                Ingredient(name: "Thai Pad Thai", amount: "1 portion", price: 14.00, vendorId: "v-17"),
                Ingredient(name: "Green Curry Chicken", amount: "1 portion", price: 16.00, vendorId: "v-17"),
                Ingredient(name: "Tom Yum Goong", amount: "1 bowl", price: 15.50, vendorId: "v-17"),
                Ingredient(name: "Massaman Lamb Curry", amount: "1 portion", price: 19.00, vendorId: "v-17"),
                Ingredient(name: "Som Tum Papaya Salad", amount: "1 portion", price: 11.00, vendorId: "v-17"),
                Ingredient(name: "Mango Sticky Rice Special", amount: "1 portion", price: 10.00, vendorId: "v-17")
            ],
            "Drinks": [
                Ingredient(name: "Thai Basil Smash", amount: "Cocktail", price: 11.00, vendorId: "v-17"),
                Ingredient(name: "Phuket Punch", amount: "Cocktail", price: 12.00, vendorId: "v-17"),
                Ingredient(name: "Thai Milk Tea Ice", amount: "Milkshake", price: 6.00, vendorId: "v-17"),
                Ingredient(name: "Lemongrass Ginger Cooler", amount: "Mocktail", price: 5.50, vendorId: "v-17"),
                Ingredient(name: "Singha Lager", amount: "Beer", price: 6.50, vendorId: "v-17"),
                Ingredient(name: "Butterfly Pea Lemonade", amount: "Lemonade", price: 6.00, vendorId: "v-17"),
                Ingredient(name: "Thai Strong Coffee", amount: "Caffeine", price: 5.50, vendorId: "v-17")
            ]
        ]),
        
        // Karen
        Vendor(id: "v-18", name: "Barcelona Tapas", cuisine: "Spanish", imageUrls: [
            "https://images.unsplash.com/photo-1515443961218-a5136d888be7?q=80&w=800"
        ], deliveryFee: 4.00, rating: 4.7, location: Location(latitude: -1.3554, longitude: 36.7012), inventory: [
            "Soups": [
                Ingredient(name: "Gazpacho Andaluz", amount: "Bowl", price: 7.00, vendorId: "v-18"),
                Ingredient(name: "Salmorejo", amount: "Bowl", price: 7.50, vendorId: "v-18"),
                Ingredient(name: "Sopa de Ajo (Garlic)", amount: "Bowl", price: 6.50, vendorId: "v-18")
            ],
            "Meals": [
                Ingredient(name: "Spanish Patatas Bravas", amount: "1 bowl", price: 10.50, vendorId: "v-18"),
                Ingredient(name: "Seafood Paella", amount: "1 portion", price: 26.00, vendorId: "v-18"),
                Ingredient(name: "Gambas al Ajillo", amount: "1 portion", price: 18.00, vendorId: "v-18"),
                Ingredient(name: "Jamón Ibérico Platter", amount: "100g", price: 32.00, vendorId: "v-18"),
                Ingredient(name: "Churros with Chocolate", amount: "4 pcs", price: 9.00, vendorId: "v-18"),
                Ingredient(name: "Spanish Tortilla", amount: "1 slice", price: 8.50, vendorId: "v-18")
            ],
            "Drinks": [
                Ingredient(name: "Sangria Roja", amount: "Cocktail", price: 9.50, vendorId: "v-18"),
                Ingredient(name: "Tinto de Verano", amount: "Cocktail", price: 8.50, vendorId: "v-18"),
                Ingredient(name: "Virgin Agua de Valencia", amount: "Mocktail", price: 6.50, vendorId: "v-18"),
                Ingredient(name: "Catalan Cream Soda", amount: "Lemonade", price: 6.00, vendorId: "v-18"),
                Ingredient(name: "Estrella Damm", amount: "Beer", price: 7.00, vendorId: "v-18"),
                Ingredient(name: "Horchata de Chufa", amount: "Milkshake", price: 6.50, vendorId: "v-18"),
                Ingredient(name: "Cafe Bombón", amount: "Caffeine", price: 5.50, vendorId: "v-18")
            ]
        ]),
        
        // Runda
        Vendor(id: "v-19", name: "Seoul Soul", cuisine: "Korean", imageUrls: [
            "https://images.unsplash.com/photo-1498654896293-37aacf113fd9?q=80&w=800"
        ], deliveryFee: 3.00, rating: 4.8, location: Location(latitude: -1.2084, longitude: 36.8352), inventory: [
            "Soups": [
                Ingredient(name: "Kimchi Jjigae", amount: "Bowl", price: 10.00, vendorId: "v-19"),
                Ingredient(name: "Doenjang Jjigae", amount: "Bowl", price: 9.50, vendorId: "v-19"),
                Ingredient(name: "Sundubu Jjigae", amount: "Bowl", price: 11.00, vendorId: "v-19")
            ],
            "Meals": [
                Ingredient(name: "Korean Bibimbap", amount: "1 bowl", price: 16.50, vendorId: "v-19"),
                Ingredient(name: "Korean Fried Chicken", amount: "6 pcs", price: 18.00, vendorId: "v-19"),
                Ingredient(name: "Kimchi Jjigae", amount: "1 portion", price: 15.00, vendorId: "v-19"),
                Ingredient(name: "Japchae Noodles", amount: "1 portion", price: 14.50, vendorId: "v-19"),
                Ingredient(name: "Tteokbokki Spicy", amount: "1 portion", price: 12.00, vendorId: "v-19"),
                Ingredient(name: "Galbi Grilled Ribs", amount: "1 portion", price: 28.00, vendorId: "v-19")
            ],
            "Drinks": [
                Ingredient(name: "Soju Sunrise", amount: "Cocktail", price: 11.00, vendorId: "v-19"),
                Ingredient(name: "Makgeolli Sour", amount: "Cocktail", price: 12.00, vendorId: "v-19"),
                Ingredient(name: "Barley Tea Collins (Virgin)", amount: "Mocktail", price: 5.00, vendorId: "v-19"),
                Ingredient(name: "Pear & Ginger Fizz", amount: "Lemonade", price: 6.00, vendorId: "v-19"),
                Ingredient(name: "Cass Fresh Beer", amount: "Beer", price: 6.50, vendorId: "v-19"),
                Ingredient(name: "Korean Strawberry Shake", amount: "Milkshake", price: 7.50, vendorId: "v-19"),
                Ingredient(name: "Roasted Corn Tea", amount: "Caffeine", price: 4.00, vendorId: "v-19")
            ]
        ]),
        
        // Lavington
        Vendor(id: "v-20", name: "K-Town BBQ", cuisine: "Korean", imageUrls: [
            "https://images.unsplash.com/photo-1529193591184-b1d58069ecdd?q=80&w=800"
        ], deliveryFee: 5.00, rating: 4.9, location: Location(latitude: -1.2784, longitude: 36.7782), inventory: [
            "Soups": [
                Ingredient(name: "Samgyetang (Ginseng)", amount: "Bowl", price: 18.00, vendorId: "v-20"),
                Ingredient(name: "Galbitang (Short Rib)", amount: "Bowl", price: 16.00, vendorId: "v-20"),
                Ingredient(name: "Yukgaejang (Spicy Beef)", amount: "Bowl", price: 14.00, vendorId: "v-20")
            ],
            "Meals": [
                Ingredient(name: "Korean Bulgogi BBQ", amount: "1 portion", price: 24.00, vendorId: "v-20"),
                Ingredient(name: "Pork Belly (Samgyeopsal)", amount: "1 portion", price: 22.50, vendorId: "v-20"),
                Ingredient(name: "Korean Seafood Pancake", amount: "1 pc", price: 16.00, vendorId: "v-20"),
                Ingredient(name: "Jajangmyeon", amount: "1 bowl", price: 15.00, vendorId: "v-20"),
                Ingredient(name: "Bossam Boiled Pork", amount: "1 portion", price: 26.00, vendorId: "v-20"),
                Ingredient(name: "Mandu Dumplings", amount: "8 pcs", price: 13.00, vendorId: "v-20")
            ],
            "Drinks": [
                Ingredient(name: "Korean Mule", amount: "Cocktail", price: 11.50, vendorId: "v-20"),
                Ingredient(name: "Melona Soju Cocktail", amount: "Cocktail", price: 13.00, vendorId: "v-20"),
                Ingredient(name: "Rice Water Punch", amount: "Mocktail", price: 5.50, vendorId: "v-20"),
                Ingredient(name: "Citron Honey Soda", amount: "Lemonade", price: 6.00, vendorId: "v-20"),
                Ingredient(name: "Kloud Premium Beer", amount: "Beer", price: 7.00, vendorId: "v-20"),
                Ingredient(name: "Banana Milk Shake", amount: "Milkshake", price: 7.00, vendorId: "v-20"),
                Ingredient(name: "Korean Ginseng Tea", amount: "Caffeine", price: 6.50, vendorId: "v-20")
            ]
        ]),
        
        // Westlands
        Vendor(id: "v-21", name: "Andes Grill", cuisine: "Peruvian", imageUrls: [
            "https://images.unsplash.com/photo-1504674900247-0877df9cc836?q=80&w=800"
        ], deliveryFee: 3.00, rating: 4.5, location: Location(latitude: -1.2634, longitude: 36.8022), inventory: [
            "Soups": [
                Ingredient(name: "Sopa a la Minuta", amount: "Bowl", price: 8.50, vendorId: "v-21"),
                Ingredient(name: "Chupe de Camarones", amount: "Bowl", price: 13.00, vendorId: "v-21"),
                Ingredient(name: "Aguadito de Pollo", amount: "Bowl", price: 7.50, vendorId: "v-21")
            ],
            "Meals": [
                Ingredient(name: "Peruvian Lomo Saltado", amount: "1 portion", price: 21.00, vendorId: "v-21"),
                Ingredient(name: "Ceviche Clasico", amount: "1 portion", price: 19.50, vendorId: "v-21"),
                Ingredient(name: "Aji de Gallina", amount: "1 portion", price: 17.00, vendorId: "v-21"),
                Ingredient(name: "Anticuchos de Corazon", amount: "2 skewers", price: 15.00, vendorId: "v-21"),
                Ingredient(name: "Arroz con Mariscos", amount: "1 portion", price: 24.00, vendorId: "v-21"),
                Ingredient(name: "Causa Limena", amount: "1 portion", price: 13.00, vendorId: "v-21")
            ],
            "Drinks": [
                Ingredient(name: "Pisco Sour Classic", amount: "Cocktail", price: 12.50, vendorId: "v-21"),
                Ingredient(name: "Chilcano Peru", amount: "Cocktail", price: 11.50, vendorId: "v-21"),
                Ingredient(name: "Chicha Morada", amount: "Mocktail", price: 5.50, vendorId: "v-21"),
                Ingredient(name: "Inca Kola Refresher", amount: "Drink", price: 5.00, vendorId: "v-21"),
                Ingredient(name: "Cusqueña Beer", amount: "Beer", price: 7.00, vendorId: "v-21"),
                Ingredient(name: "Lucuma Milkshake", amount: "Milkshake", price: 8.50, vendorId: "v-21"),
                Ingredient(name: "Andean Herbal Infusion", amount: "Caffeine", price: 4.50, vendorId: "v-21")
            ]
        ]),
        
        // Muthaiga
        Vendor(id: "v-22", name: "Alpine Fondue", cuisine: "Swiss", imageUrls: [
            "https://images.unsplash.com/photo-1485962391945-448a60359f6b?q=80&w=800"
        ], deliveryFee: 6.00, rating: 4.7, location: Location(latitude: -1.2454, longitude: 36.8282), inventory: [
            "Soups": [
                Ingredient(name: "Swiss Barley Soup", amount: "Bowl", price: 9.00, vendorId: "v-22"),
                Ingredient(name: "Cheese & Onion Broth", amount: "Bowl", price: 8.50, vendorId: "v-22"),
                Ingredient(name: "Alpine Potato Soup", amount: "Bowl", price: 8.00, vendorId: "v-22")
            ],
            "Meals": [
                Ingredient(name: "Swiss Cheese Fondue", amount: "2 persons", price: 45.00, vendorId: "v-22"),
                Ingredient(name: "Rosti with Bacon & Egg", amount: "1 portion", price: 18.50, vendorId: "v-22"),
                Ingredient(name: "Zurcher Geschnetzeltes", amount: "1 portion", price: 26.00, vendorId: "v-22"),
                Ingredient(name: "Raclette Special", amount: "1 portion", price: 22.00, vendorId: "v-22"),
                Ingredient(name: "Swiss Alpine Macaroni", amount: "1 portion", price: 16.50, vendorId: "v-22"),
                Ingredient(name: "Chocolate Fondue Dessert", amount: "Small", price: 15.00, vendorId: "v-22")
            ],
            "Drinks": [
                Ingredient(name: "Alpine Negroni", amount: "Cocktail", price: 13.00, vendorId: "v-22"),
                Ingredient(name: "Swiss Sunset", amount: "Cocktail", price: 12.50, vendorId: "v-22"),
                Ingredient(name: "Elderflower Fizz (Virgin)", amount: "Mocktail", price: 7.50, vendorId: "v-22"),
                Ingredient(name: "Mountain Berry Soda", amount: "Lemonade", price: 6.50, vendorId: "v-22"),
                Ingredient(name: "Appenzeller Beer", amount: "Beer", price: 8.00, vendorId: "v-22"),
                Ingredient(name: "Swiss Chocolate Shake", amount: "Milkshake", price: 9.00, vendorId: "v-22"),
                Ingredient(name: "Alpine Herb Tea", amount: "Caffeine", price: 5.50, vendorId: "v-22")
            ]
        ]),
        
        // Karen
        Vendor(id: "v-23", name: "Sydney Seafront", cuisine: "Australian", imageUrls: [
            "https://images.unsplash.com/photo-1551731359-2b3cf8dfd1ce?q=80&w=800"
        ], deliveryFee: 4.50, rating: 4.6, location: Location(latitude: -1.3254, longitude: 36.7082), inventory: [
            "Soups": [
                Ingredient(name: "Seafood Chowder Oz", amount: "Bowl", price: 12.50, vendorId: "v-23"),
                Ingredient(name: "Macadamia Nut Soup", amount: "Bowl", price: 9.50, vendorId: "v-23"),
                Ingredient(name: "Australian Pea & Ham", amount: "Bowl", price: 8.00, vendorId: "v-23")
            ],
            "Meals": [
                Ingredient(name: "Australian Grilled Barramundi", amount: "1 fillet", price: 28.00, vendorId: "v-23"),
                Ingredient(name: "Kangaroo Steaks", amount: "1 portion", price: 32.00, vendorId: "v-23"),
                Ingredient(name: "Classic Meat Pie", amount: "1 pc", price: 12.00, vendorId: "v-23"),
                Ingredient(name: "Grilled Moreton Bay Bugs", amount: "2 pcs", price: 35.00, vendorId: "v-23"),
                Ingredient(name: "Chicken Parmigiana (Oz Style)", amount: "1 portion", price: 19.50, vendorId: "v-23"),
                Ingredient(name: "Pavlova with Fruits", amount: "1 portion", price: 11.00, vendorId: "v-23")
            ],
            "Drinks": [
                Ingredient(name: "Gold Coast Mule", amount: "Cocktail", price: 11.50, vendorId: "v-23"),
                Ingredient(name: "Sydney Sour", amount: "Cocktail", price: 12.50, vendorId: "v-23"),
                Ingredient(name: "Ginger Beer Refresher", amount: "Mocktail", price: 6.00, vendorId: "v-23"),
                Ingredient(name: "Wattle-seed Iced Latte", amount: "Caffeine", price: 7.50, vendorId: "v-23"),
                Ingredient(name: "Victoria Bitter", amount: "Beer", price: 7.00, vendorId: "v-23"),
                Ingredient(name: "Tim Tam Slam Shake", amount: "Milkshake", price: 9.50, vendorId: "v-23"),
                Ingredient(name: "Lemon Myrtle Soda", amount: "Lemonade", price: 6.50, vendorId: "v-23")
            ]
        ]),
        
        // Runda
        Vendor(id: "v-24", name: "Quebec Poutine", cuisine: "Canadian", imageUrls: [
            "https://images.unsplash.com/photo-1586511925558-a4c6376fe65f?q=80&w=800"
        ], deliveryFee: 2.50, rating: 4.5, location: Location(latitude: -1.2184, longitude: 36.8212), inventory: [
            "Soups": [
                Ingredient(name: "Habitant Pea Soup", amount: "Bowl", price: 7.50, vendorId: "v-24"),
                Ingredient(name: "Cheddar Broccoli Ale", amount: "Bowl", price: 8.50, vendorId: "v-24"),
                Ingredient(name: "Wild Mushroom Cream", amount: "Bowl", price: 9.00, vendorId: "v-24")
            ],
            "Meals": [
                Ingredient(name: "Canadian Classic Poutine", amount: "1 bowl", price: 14.50, vendorId: "v-24"),
                Ingredient(name: "Smoked Meat Sandwich", amount: "1 portion", price: 16.00, vendorId: "v-24"),
                Ingredient(name: "Tourtière Meat Pie", amount: "1 slice", price: 13.50, vendorId: "v-24"),
                Ingredient(name: "Maple Glazed Salmon", amount: "1 portion", price: 24.00, vendorId: "v-24"),
                Ingredient(name: "Split Pea Soup", amount: "1 bowl", price: 10.00, vendorId: "v-24"),
                Ingredient(name: "Nanaimo Bar Trio", amount: "3 pcs", price: 9.00, vendorId: "v-24")
            ],
            "Drinks": [
                Ingredient(name: "Canadian Caesar", amount: "Cocktail", price: 12.00, vendorId: "v-24"),
                Ingredient(name: "Maple Old Fashioned", amount: "Cocktail", price: 14.00, vendorId: "v-24"),
                Ingredient(name: "Virgin Caesar", amount: "Mocktail", price: 7.50, vendorId: "v-24"),
                Ingredient(name: "Blueberry Maple Soda", amount: "Lemonade", price: 6.50, vendorId: "v-24"),
                Ingredient(name: "Molson Canadian", amount: "Beer", price: 6.50, vendorId: "v-24"),
                Ingredient(name: "Maple Cream Shake", amount: "Milkshake", price: 8.50, vendorId: "v-24"),
                Ingredient(name: "Ice Wine Tea", amount: "Caffeine", price: 7.00, vendorId: "v-24")
            ]
        ]),
        
        // Lavington
        Vendor(id: "v-25", name: "Lisbon Seafood", cuisine: "Portuguese", imageUrls: [
            "https://images.unsplash.com/photo-1534080564607-198f9dd5d61a?q=80&w=800"
        ], deliveryFee: 4.00, rating: 4.8, location: Location(latitude: -1.2884, longitude: 36.7682), inventory: [
            "Soups": [
                Ingredient(name: "Caldo Verde Original", amount: "Bowl", price: 7.50, vendorId: "v-25"),
                Ingredient(name: "Sopa de Marisco", amount: "Bowl", price: 11.00, vendorId: "v-25"),
                Ingredient(name: "Tomato & Bread Soup", amount: "Bowl", price: 6.50, vendorId: "v-25")
            ],
            "Meals": [
                Ingredient(name: "Portuguese Bacalhau", amount: "1 portion", price: 22.00, vendorId: "v-25"),
                Ingredient(name: "Grilled Sardines", amount: "4 pcs", price: 16.50, vendorId: "v-25"),
                Ingredient(name: "Frango Piri-Piri", amount: "Half Chicken", price: 18.00, vendorId: "v-25"),
                Ingredient(name: "Arroz de Marisco", amount: "1 portion", price: 26.00, vendorId: "v-25"),
                Ingredient(name: "Caldo Verde Soup", amount: "1 bowl", price: 11.00, vendorId: "v-25"),
                Ingredient(name: "Pastéis de Nata", amount: "3 pcs", price: 10.50, vendorId: "v-25")
            ],
            "Drinks": [
                Ingredient(name: "Port Wine Spritz", amount: "Cocktail", price: 10.50, vendorId: "v-25"),
                Ingredient(name: "Lisbon Ginjinha", amount: "Cocktail", price: 9.50, vendorId: "v-25"),
                Ingredient(name: "Portuguese Lemonade", amount: "Lemonade", price: 5.50, vendorId: "v-25"),
                Ingredient(name: "Iced Galao (Virgin)", amount: "Caffeine", price: 6.00, vendorId: "v-25"),
                Ingredient(name: "Super Bock Beer", amount: "Beer", price: 6.00, vendorId: "v-25"),
                Ingredient(name: "Custard Cream Shake", amount: "Milkshake", price: 8.00, vendorId: "v-25"),
                Ingredient(name: "Madeira Mocktail", amount: "Mocktail", price: 7.00, vendorId: "v-25")
            ]
        ]),
        
        // Westlands
        Vendor(id: "v-26", name: "Copenhagen Nordic", cuisine: "Danish", imageUrls: [
            "https://images.unsplash.com/photo-1559339352-11d035aa65de?q=80&w=800"
        ], deliveryFee: 5.50, rating: 4.7, location: Location(latitude: -1.2604, longitude: 36.8052), inventory: [
            "Soups": [
                Ingredient(name: "Yellow Pea Soup", amount: "Bowl", price: 8.00, vendorId: "v-26"),
                Ingredient(name: "Nordic Fish Soup", amount: "Bowl", price: 12.00, vendorId: "v-26"),
                Ingredient(name: "Cold Buttermilk Soup", amount: "Bowl", price: 7.00, vendorId: "v-26")
            ],
            "Meals": [
                Ingredient(name: "Danish Smørrebrød Trio", amount: "3 pcs", price: 19.50, vendorId: "v-26"),
                Ingredient(name: "Frikadeller Meatballs", amount: "1 portion", price: 16.00, vendorId: "v-26"),
                Ingredient(name: "Roast Pork (Flæskesteg)", amount: "1 portion", price: 24.00, vendorId: "v-26"),
                Ingredient(name: "Stegt Flæsk", amount: "1 portion", price: 18.50, vendorId: "v-26"),
                Ingredient(name: "Gravlax Special", amount: "1 portion", price: 21.00, vendorId: "v-26"),
                Ingredient(name: "Æbleskiver Dessert", amount: "6 pcs", price: 12.00, vendorId: "v-26")
            ],
            "Drinks": [
                Ingredient(name: "Nordic Akvavit Sour", amount: "Cocktail", price: 13.00, vendorId: "v-26"),
                Ingredient(name: "Copenhagen Collins", amount: "Cocktail", price: 12.00, vendorId: "v-26"),
                Ingredient(name: "Lingonberry Fizz", amount: "Mocktail", price: 6.50, vendorId: "v-26"),
                Ingredient(name: "Elderflower Tonic", amount: "Lemonade", price: 6.00, vendorId: "v-26"),
                Ingredient(name: "Carlsberg Elephant", amount: "Beer", price: 7.50, vendorId: "v-26"),
                Ingredient(name: "Danish Pastry Shake", amount: "Milkshake", price: 9.00, vendorId: "v-26"),
                Ingredient(name: "Nordic Filter Roast", amount: "Caffeine", price: 5.00, vendorId: "v-26")
            ]
        ]),
        
        // Muthaiga
        Vendor(id: "v-27", name: "Vienna Pastry", cuisine: "Austrian", imageUrls: [
            "https://images.unsplash.com/photo-1488477181946-6428a0291777?q=80&w=800"
        ], deliveryFee: 2.00, rating: 4.9, location: Location(latitude: -1.2464, longitude: 36.8312), inventory: [
            "Soups": [
                Ingredient(name: "Goulash Soup (Gulaschsuppe)", amount: "Bowl", price: 9.00, vendorId: "v-27"),
                Ingredient(name: "Frittatensuppe (Pancake)", amount: "Bowl", price: 7.00, vendorId: "v-27"),
                Ingredient(name: "Leberknödelsuppe", amount: "Bowl", price: 8.50, vendorId: "v-27")
            ],
            "Meals": [
                Ingredient(name: "Austrian Sachertorte", amount: "1 slice", price: 11.50, vendorId: "v-27"),
                Ingredient(name: "Wiener Schnitzel", amount: "1 portion", price: 26.00, vendorId: "v-27"),
                Ingredient(name: "Apple Strudel", amount: "1 slice", price: 10.00, vendorId: "v-27"),
                Ingredient(name: "Tafelspitz Stew", amount: "1 portion", price: 28.50, vendorId: "v-27"),
                Ingredient(name: "Kaiserschmarrn", amount: "1 portion", price: 15.00, vendorId: "v-27"),
                Ingredient(name: "Goulash Soup", amount: "1 bowl", price: 12.50, vendorId: "v-27")
            ],
            "Drinks": [
                Ingredient(name: "Austrian Hugo Spritz", amount: "Cocktail", price: 11.00, vendorId: "v-27"),
                Ingredient(name: "Viennese Coffee Martini", amount: "Cocktail", price: 12.50, vendorId: "v-27"),
                Ingredient(name: "Almdudler Herb Soda", amount: "Mocktail", price: 5.50, vendorId: "v-27"),
                Ingredient(name: "Eiskaffee (Virgin)", amount: "Caffeine", price: 7.00, vendorId: "v-27"),
                Ingredient(name: "Stiegl Beer", amount: "Beer", price: 7.00, vendorId: "v-27"),
                Ingredient(name: "Sachertorte Shake", amount: "Milkshake", price: 9.00, vendorId: "v-27"),
                Ingredient(name: "Vienna Melange", amount: "Caffeine", price: 5.50, vendorId: "v-27")
            ]
        ]),
        
        // Karen
        Vendor(id: "v-28", name: "Caribbean Heat", cuisine: "Jamaican", imageUrls: [
            "https://images.unsplash.com/photo-1533777857419-d2d305d7b578?q=80&w=800"
        ], deliveryFee: 3.50, rating: 4.6, location: Location(latitude: -1.3354, longitude: 36.7152), inventory: [
            "Soups": [
                Ingredient(name: "Mannish Water", amount: "Bowl", price: 10.00, vendorId: "v-28"),
                Ingredient(name: "Red Peas Soup", amount: "Bowl", price: 8.50, vendorId: "v-28"),
                Ingredient(name: "Jamaican Pumpkin Soup", amount: "Bowl", price: 7.00, vendorId: "v-28")
            ],
            "Meals": [
                Ingredient(name: "Jamaican Jerk Chicken", amount: "1 portion", price: 16.50, vendorId: "v-28"),
                Ingredient(name: "Curry Goat Special", amount: "1 portion", price: 19.50, vendorId: "v-28"),
                Ingredient(name: "Ackee & Saltfish", amount: "1 portion", price: 18.00, vendorId: "v-28"),
                Ingredient(name: "Oxtail Stew", amount: "1 portion", price: 22.00, vendorId: "v-28"),
                Ingredient(name: "Jamaican Beef Patty", amount: "2 pcs", price: 10.00, vendorId: "v-28"),
                Ingredient(name: "Rice & Peas Special", amount: "1 portion", price: 8.50, vendorId: "v-28")
            ],
            "Drinks": [
                Ingredient(name: "Rum Punch Classic", amount: "Cocktail", price: 10.50, vendorId: "v-28"),
                Ingredient(name: "Jamaican Mule", amount: "Cocktail", price: 11.00, vendorId: "v-28"),
                Ingredient(name: "Virgin Piña Colada", amount: "Mocktail", price: 7.50, vendorId: "v-28"),
                Ingredient(name: "Sorrel Drink", amount: "Lemonade", price: 5.00, vendorId: "v-28"),
                Ingredient(name: "Red Stripe Beer", amount: "Beer", price: 6.00, vendorId: "v-28"),
                Ingredient(name: "Tropical Coconut Shake", amount: "Milkshake", price: 7.50, vendorId: "v-28"),
                Ingredient(name: "Blue Mountain Coffee", amount: "Caffeine", price: 6.50, vendorId: "v-28")
            ]
        ]),
        
        // Runda
        Vendor(id: "v-29", name: "Bali Bowls", cuisine: "Indonesian", imageUrls: [
            "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=800"
        ], deliveryFee: 3.00, rating: 4.8, location: Location(latitude: -1.2124, longitude: 36.8312), inventory: [
            "Soups": [
                Ingredient(name: "Soto Ayam (Chicken)", amount: "Bowl", price: 8.00, vendorId: "v-29"),
                Ingredient(name: "Bakso Meatball Soup", amount: "Bowl", price: 9.00, vendorId: "v-29"),
                Ingredient(name: "Sayur Asem (Tamarind)", amount: "Bowl", price: 7.00, vendorId: "v-29")
            ],
            "Meals": [
                Ingredient(name: "Indonesian Nasi Goreng", amount: "1 bowl", price: 14.00, vendorId: "v-29"),
                Ingredient(name: "Chicken Satay", amount: "6 skewers", price: 15.50, vendorId: "v-29"),
                Ingredient(name: "Beef Rendang", amount: "1 portion", price: 19.00, vendorId: "v-29"),
                Ingredient(name: "Gado-Gado Salad", amount: "1 portion", price: 12.50, vendorId: "v-29"),
                Ingredient(name: "Mie Goreng Special", amount: "1 bowl", price: 13.50, vendorId: "v-29"),
                Ingredient(name: "Bakso Soup", amount: "1 bowl", price: 11.00, vendorId: "v-29")
            ],
            "Drinks": [
                Ingredient(name: "Bali Sunset", amount: "Cocktail", price: 11.00, vendorId: "v-29"),
                Ingredient(name: "Indo Gin Fizz", amount: "Cocktail", price: 12.00, vendorId: "v-29"),
                Ingredient(name: "Fresh Coconut Water", amount: "Drink", price: 5.00, vendorId: "v-29"),
                Ingredient(name: "Tropical Lemongrass Tea", amount: "Mocktail", price: 5.50, vendorId: "v-29"),
                Ingredient(name: "Bintang Beer", amount: "Beer", price: 6.50, vendorId: "v-29"),
                Ingredient(name: "Durian Special Shake", amount: "Milkshake", price: 9.00, vendorId: "v-29"),
                Ingredient(name: "Java Coffee Roast", amount: "Caffeine", price: 5.00, vendorId: "v-29")
            ]
        ]),
        
        // Lavington
        Vendor(id: "v-30", name: "Cairo Kitchen", cuisine: "Egyptian", imageUrls: [
            "https://images.unsplash.com/photo-1567156942642-4f96446e502c?q=80&w=800"
        ], deliveryFee: 2.50, rating: 4.5, location: Location(latitude: -1.2924, longitude: 36.7712), inventory: [
            "Soups": [
                Ingredient(name: "Molokhia Traditional", amount: "Bowl", price: 8.50, vendorId: "v-30"),
                Ingredient(name: "Egyptian Lentil Soup", amount: "Bowl", price: 6.50, vendorId: "v-30"),
                Ingredient(name: "Orzo Soup (Lisan Asfour)", amount: "Bowl", price: 6.00, vendorId: "v-30")
            ],
            "Meals": [
                Ingredient(name: "Egyptian Koshary", amount: "1 bowl", price: 12.50, vendorId: "v-30"),
                Ingredient(name: "Molokhia with Chicken", amount: "1 portion", price: 16.00, vendorId: "v-30"),
                Ingredient(name: "Egyptian Falafel (Ta'ameya)", amount: "4 pcs", price: 9.00, vendorId: "v-30"),
                Ingredient(name: "Kofta Kebab Plate", amount: "1 portion", price: 18.50, vendorId: "v-30"),
                Ingredient(name: "Stuffed Pigeon (Hamam)", amount: "1 pc", price: 22.00, vendorId: "v-30"),
                Ingredient(name: "Om Ali Dessert", amount: "1 portion", price: 10.00, vendorId: "v-30")
            ],
            "Drinks": [
                Ingredient(name: "Cairo Mule", amount: "Cocktail", price: 11.00, vendorId: "v-30"),
                Ingredient(name: "Nile Gin Sour", amount: "Cocktail", price: 12.00, vendorId: "v-30"),
                Ingredient(name: "Karkade (Hibiscus)", amount: "Lemonade", price: 5.00, vendorId: "v-30"),
                Ingredient(name: "Mango Mint Breeze", amount: "Mocktail", price: 6.00, vendorId: "v-30"),
                Ingredient(name: "Egyptian Stella Beer", amount: "Beer", price: 6.00, vendorId: "v-30"),
                Ingredient(name: "Dates & Honey Shake", amount: "Milkshake", price: 7.50, vendorId: "v-30"),
                Ingredient(name: "Strong Arabic Coffee", amount: "Caffeine", price: 4.50, vendorId: "v-30")
            ]
        ])
    ]
    
    func fetchVendors() async throws -> [Vendor] {
        return vendors
    }
    
    func fetchVendor(id: String) async throws -> Vendor? {
        return vendors.first { $0.id == id }
    }
}
