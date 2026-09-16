import Foundation

class MockRecipeRepository: RecipeRepository {
    private var recipes: [Recipe] = [
        // Muthaiga - Swahili
        Recipe(id: "r-1", title: "Traditional Beef Pilau", author: "Chef Mama Juma", vendorId: "v-1", imageUrls: [
            "https://images.unsplash.com/photo-1596040033229-a9821ebd058d?q=80&w=800"
        ], description: "Fragrant Swahili rice cooked with tender beef and warm spices.", ingredients: [
            Ingredient(name: "Aromatic Basmati Rice", amount: "500g", price: 180.00, vendorId: "v-1"),
            Ingredient(name: "Prime Beef Chuck Cubes", amount: "500g", price: 420.00, vendorId: "v-1"),
            Ingredient(name: "Whole Pilau Masala", amount: "50g", price: 90.00, vendorId: "v-1"),
            Ingredient(name: "Red Bombay Onions", amount: "500g", price: 110.00, vendorId: "v-1"),
            Ingredient(name: "Fresh Garlic & Ginger Paste", amount: "100g", price: 85.00, vendorId: "v-1"),
            Ingredient(name: "Fresh Cilantro / Dhania", amount: "1 bunch", price: 40.00, vendorId: "v-1")
        ], instructions: ["Boil beef", "Fry onions until dark", "Add masala", "Cook rice"], likes: 120, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),
        
        Recipe(id: "r-31", title: "Swahili Goat Soup", author: "Chef Mama Juma", vendorId: "v-1", imageUrls: [
            "https://images.unsplash.com/photo-1547592166-23ac45744acd?q=80&w=800"
        ], description: "Rich, slow-simmered bone broth with tender goat meat and indigenous herbs.", ingredients: [
            Ingredient(name: "Simmer Bone Cuts / Broth Base", amount: "600g", price: 420.00, vendorId: "v-1"),
            Ingredient(name: "Soup Aromatics & Fresh Herbs", amount: "1 bundle", price: 85.00, vendorId: "v-1"),
            Ingredient(name: "Root Vegetables & Onions", amount: "400g", price: 130.00, vendorId: "v-1"),
            Ingredient(name: "Crushed Peppercorns & Lemon", amount: "1 set", price: 60.00, vendorId: "v-1")
        ], instructions: ["Simmer goat bones", "Add local herbs", "Slow cook 4 hours"], likes: 85, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),

        // Westlands - Italian
        Recipe(id: "r-2", title: "Classic Beef Lasagna", author: "Chef Giovanni", vendorId: "v-2", imageUrls: [
            "https://images.unsplash.com/photo-1551183053-bf91a1d81141?q=80&w=800"
        ], description: "Rich meat sauce and creamy béchamel layered with pasta.", ingredients: [
            Ingredient(name: "Durum Wheat Lasagna Sheets", amount: "500g", price: 320.00, vendorId: "v-2"),
            Ingredient(name: "Coarse Ground Beef Mince", amount: "500g", price: 450.00, vendorId: "v-2"),
            Ingredient(name: "San Marzano Tomato Purée", amount: "400g", price: 280.00, vendorId: "v-2"),
            Ingredient(name: "Fior di Latte Mozzarella", amount: "250g", price: 390.00, vendorId: "v-2"),
            Ingredient(name: "Béchamel & Grana Padano", amount: "300ml", price: 210.00, vendorId: "v-2")
        ], instructions: ["Make ragu", "Make béchamel", "Layer", "Bake"], likes: 340, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),
        
        Recipe(id: "r-32", title: "Classic Minestrone", author: "Chef Giovanni", vendorId: "v-2", imageUrls: [
            "https://images.unsplash.com/photo-1603105037880-880cd4edfb0d?q=80&w=800"
        ], description: "Hearty vegetable soup with pasta and beans, topped with parmesan.", ingredients: [
            Ingredient(name: "Fresh Classic Minestrone Key Cuts", amount: "500g", price: 420.00, vendorId: "v-2"),
            Ingredient(name: "Kitchen Aromatics & Seasonings", amount: "1 set", price: 110.00, vendorId: "v-2"),
            Ingredient(name: "Fresh Local Greens & Herbs", amount: "1 bunch", price: 60.00, vendorId: "v-2"),
            Ingredient(name: "Artisan Side / Accompaniment", amount: "1 portion", price: 150.00, vendorId: "v-2")
        ], instructions: ["Sauté aromatics", "Add seasonal veggies", "Simmer with ditalini"], likes: 150, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),

        // Karen - Chinese
        Recipe(id: "r-3", title: "Spicy Kung Pao Chicken", author: "Chef Wei", vendorId: "v-3", imageUrls: [
            "https://images.unsplash.com/photo-1525755662778-989d0524087e?q=80&w=800"
        ], description: "Szechuan classic with peanuts and chili peppers.", ingredients: [
            Ingredient(name: "Farm-Fresh Chicken Cuts", amount: "600g", price: 460.00, vendorId: "v-3"),
            Ingredient(name: "Garlic, Ginger & Chili Marinade", amount: "1 jar", price: 110.00, vendorId: "v-3"),
            Ingredient(name: "Bell Peppers & Red Onions", amount: "400g", price: 120.00, vendorId: "v-3"),
            Ingredient(name: "Cold-Pressed Sesame Oil & Spices", amount: "150ml", price: 150.00, vendorId: "v-3")
        ], instructions: ["Marinate", "Stir fry chicken", "Add peanuts", "Sauce"], likes: 210, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),
        
        Recipe(id: "r-33", title: "Hot & Sour Soup", author: "Chef Wei", vendorId: "v-3", imageUrls: [
            "https://images.unsplash.com/photo-1541944743827-e04bb64aa79b?q=80&w=800"
        ], description: "Classic Szechuan soup with tofu, mushrooms, and a spicy kick.", ingredients: [
            Ingredient(name: "Simmer Bone Cuts / Broth Base", amount: "600g", price: 420.00, vendorId: "v-3"),
            Ingredient(name: "Soup Aromatics & Fresh Herbs", amount: "1 bundle", price: 85.00, vendorId: "v-3"),
            Ingredient(name: "Root Vegetables & Onions", amount: "400g", price: 130.00, vendorId: "v-3"),
            Ingredient(name: "Crushed Peppercorns & Lemon", amount: "1 set", price: 60.00, vendorId: "v-3")
        ], instructions: ["Prep broth", "Add wood ear mushrooms", "Balance vinegar and pepper"], likes: 110, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),

        // Runda - Turkish
        Recipe(id: "r-4", title: "Turkish Adana Kebab", author: "Chef Selim", vendorId: "v-4", imageUrls: [
            "https://images.unsplash.com/photo-1555939594-58d7cb561ad1?q=80&w=800"
        ], description: "Hand-minced meat mixed with chili and grilled.", ingredients: [
            Ingredient(name: "Hand-Minced Lamb & Beef", amount: "500g", price: 540.00, vendorId: "v-4"),
            Ingredient(name: "Urfa & Maras Pepper Flakes", amount: "50g", price: 120.00, vendorId: "v-4"),
            Ingredient(name: "Lavash Flatbread & Sumac Onions", amount: "1 pack", price: 180.00, vendorId: "v-4"),
            Ingredient(name: "Charred Long Green Peppers", amount: "200g", price: 90.00, vendorId: "v-4")
        ], instructions: ["Mince meat", "Season", "Skewer", "Grill"], likes: 450, isLikedByMe: true, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),
        
        Recipe(id: "r-34", title: "Mercimek Corbasi", author: "Chef Selim", vendorId: "v-4", imageUrls: [
            "https://images.unsplash.com/photo-1547592115-f99998b94df2?q=80&w=800"
        ], description: "Traditional Turkish red lentil soup served with lemon and pul biber.", ingredients: [
            Ingredient(name: "Simmer Bone Cuts / Broth Base", amount: "600g", price: 420.00, vendorId: "v-4"),
            Ingredient(name: "Soup Aromatics & Fresh Herbs", amount: "1 bundle", price: 85.00, vendorId: "v-4"),
            Ingredient(name: "Root Vegetables & Onions", amount: "400g", price: 130.00, vendorId: "v-4"),
            Ingredient(name: "Crushed Peppercorns & Lemon", amount: "1 set", price: 60.00, vendorId: "v-4")
        ], instructions: ["Sauté onions", "Cook red lentils", "Blend and season"], likes: 195, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),

        // Lavington - Greek
        Recipe(id: "r-5", title: "Greek Spanakopita", author: "Chef Yiannis", vendorId: "v-5", imageUrls: [
            "https://images.unsplash.com/photo-1512484776495-a09d92e87c3b?q=80&w=800"
        ], description: "Flaky phyllo pastry filled with spinach and feta.", ingredients: [
            Ingredient(name: "Crisp Phyllo Pastry Sheets", amount: "375g", price: 310.00, vendorId: "v-5"),
            Ingredient(name: "Organic Baby Spinach", amount: "500g", price: 180.00, vendorId: "v-5"),
            Ingredient(name: "Crumbled Greek Feta Cheese", amount: "250g", price: 360.00, vendorId: "v-5"),
            Ingredient(name: "Fresh Dill & Nutmeg", amount: "1 bunch", price: 70.00, vendorId: "v-5")
        ], instructions: ["Prep spinach", "Layer phyllo", "Fill", "Bake"], likes: 180, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),
        
        Recipe(id: "r-35", title: "Avgolemono", author: "Chef Yiannis", vendorId: "v-5", imageUrls: [
            "https://images.unsplash.com/photo-1604329760661-e71dc83f8f26?q=80&w=800"
        ], description: "Creamy lemon-egg chicken soup with rice, a Greek comfort classic.", ingredients: [
            Ingredient(name: "Fresh Avgolemono Key Cuts", amount: "500g", price: 420.00, vendorId: "v-5"),
            Ingredient(name: "Kitchen Aromatics & Seasonings", amount: "1 set", price: 110.00, vendorId: "v-5"),
            Ingredient(name: "Fresh Local Greens & Herbs", amount: "1 bunch", price: 60.00, vendorId: "v-5"),
            Ingredient(name: "Artisan Side / Accompaniment", amount: "1 portion", price: 150.00, vendorId: "v-5")
        ], instructions: ["Boil chicken", "Whip eggs and lemon", "Temper into broth"], likes: 230, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),

        // Westlands - Japanese
        Recipe(id: "r-6", title: "Salmon Sushi Rolls", author: "Chef Hiro", vendorId: "v-6", imageUrls: [
            "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?q=80&w=800"
        ], description: "Fresh salmon and cucumber in premium sushi rice.", ingredients: [
            Ingredient(name: "Sashimi-Grade Atlantic Salmon", amount: "350g", price: 780.00, vendorId: "v-6"),
            Ingredient(name: "Koshihikari Sushi Rice", amount: "500g", price: 290.00, vendorId: "v-6"),
            Ingredient(name: "Roasted Nori Seaweed Sheets", amount: "10 sheets", price: 180.00, vendorId: "v-6"),
            Ingredient(name: "Japanese Rice Vinegar & Mirin", amount: "150ml", price: 160.00, vendorId: "v-6"),
            Ingredient(name: "Pickled Ginger & Wasabi Paste", amount: "1 set", price: 120.00, vendorId: "v-6")
        ], instructions: ["Prep rice", "Slice salmon", "Roll", "Slice"], likes: 520, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),
        
        Recipe(id: "r-36", title: "Miso Soup Special", author: "Chef Hiro", vendorId: "v-6", imageUrls: [
            "https://images.unsplash.com/photo-1547592166-23ac45744acd?q=80&w=800"
        ], description: "Authentic dashi broth with white miso, silken tofu, and wakame.", ingredients: [
            Ingredient(name: "Simmer Bone Cuts / Broth Base", amount: "600g", price: 420.00, vendorId: "v-6"),
            Ingredient(name: "Soup Aromatics & Fresh Herbs", amount: "1 bundle", price: 85.00, vendorId: "v-6"),
            Ingredient(name: "Root Vegetables & Onions", amount: "400g", price: 130.00, vendorId: "v-6"),
            Ingredient(name: "Crushed Peppercorns & Lemon", amount: "1 set", price: 60.00, vendorId: "v-6")
        ], instructions: ["Prepare dashi", "Dissolve miso", "Add tofu and seaweed"], likes: 310, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),

        // Muthaiga - Georgian
        Recipe(id: "r-7", title: "Georgian Khachapuri", author: "Chef Nino", vendorId: "v-7", imageUrls: [
            "https://images.unsplash.com/photo-1603048588665-791ca8aea617?q=80&w=800"
        ], description: "Cheese-filled bread topped with an egg and butter.", ingredients: [
            Ingredient(name: "Fresh Georgian Khachapuri Key Cuts", amount: "500g", price: 420.00, vendorId: "v-7"),
            Ingredient(name: "Kitchen Aromatics & Seasonings", amount: "1 set", price: 110.00, vendorId: "v-7"),
            Ingredient(name: "Fresh Local Greens & Herbs", amount: "1 bunch", price: 60.00, vendorId: "v-7"),
            Ingredient(name: "Artisan Side / Accompaniment", amount: "1 portion", price: 150.00, vendorId: "v-7")
        ], instructions: ["Make dough", "Shape boat", "Add cheese", "Bake"], likes: 890, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),
        
        Recipe(id: "r-37", title: "Kharcho Beef Soup", author: "Chef Nino", vendorId: "v-7", imageUrls: [
            "https://images.unsplash.com/photo-1547592166-23ac45744acd?q=80&w=800"
        ], description: "Spicy Georgian beef soup with rice and walnuts.", ingredients: [
            Ingredient(name: "Simmer Bone Cuts / Broth Base", amount: "600g", price: 420.00, vendorId: "v-7"),
            Ingredient(name: "Soup Aromatics & Fresh Herbs", amount: "1 bundle", price: 85.00, vendorId: "v-7"),
            Ingredient(name: "Root Vegetables & Onions", amount: "400g", price: 130.00, vendorId: "v-7"),
            Ingredient(name: "Crushed Peppercorns & Lemon", amount: "1 set", price: 60.00, vendorId: "v-7")
        ], instructions: ["Sear beef", "Add walnut paste", "Simmer with tklapi"], likes: 145, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),

        // Karen - Ethiopian
        Recipe(id: "r-8", title: "Habesha Injera Platter", author: "Chef Abeba", vendorId: "v-8", imageUrls: [
            "https://images.unsplash.com/photo-1548946522-4a313e8972a4?q=80&w=800"
        ], description: "Traditional fermented flatbread with various stews.", ingredients: [
            Ingredient(name: "Fresh Habesha Injera Platter Key Cuts", amount: "500g", price: 420.00, vendorId: "v-8"),
            Ingredient(name: "Kitchen Aromatics & Seasonings", amount: "1 set", price: 110.00, vendorId: "v-8"),
            Ingredient(name: "Fresh Local Greens & Herbs", amount: "1 bunch", price: 60.00, vendorId: "v-8"),
            Ingredient(name: "Artisan Side / Accompaniment", amount: "1 portion", price: 150.00, vendorId: "v-8")
        ], instructions: ["Ferment teff", "Cook injera", "Prepare wats", "Assemble"], likes: 310, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),
        
        Recipe(id: "r-38", title: "Spiced Lentil Soup", author: "Chef Abeba", vendorId: "v-8", imageUrls: [
            "https://images.unsplash.com/photo-1547592115-f99998b94df2?q=80&w=800"
        ], description: "Ethiopian red lentil soup flavored with berbere spices.", ingredients: [
            Ingredient(name: "Simmer Bone Cuts / Broth Base", amount: "600g", price: 420.00, vendorId: "v-8"),
            Ingredient(name: "Soup Aromatics & Fresh Herbs", amount: "1 bundle", price: 85.00, vendorId: "v-8"),
            Ingredient(name: "Root Vegetables & Onions", amount: "400g", price: 130.00, vendorId: "v-8"),
            Ingredient(name: "Crushed Peppercorns & Lemon", amount: "1 set", price: 60.00, vendorId: "v-8")
        ], instructions: ["Sauté with berbere", "Add red lentils", "Simmer until creamy"], likes: 165, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),

        // Runda - Mexican
        Recipe(id: "r-9", title: "Mexican Street Tacos", author: "Chef Sofia", vendorId: "v-9", imageUrls: [
            "https://images.unsplash.com/photo-1565299585323-38d6b0865b47?q=80&w=800"
        ], description: "Authentic corn tortillas with seasoned meats and salsa.", ingredients: [
            Ingredient(name: "White Corn Masa Tortillas", amount: "12 pack", price: 190.00, vendorId: "v-9"),
            Ingredient(name: "Seasoned Filling & Guajillo Rub", amount: "450g", price: 480.00, vendorId: "v-9"),
            Ingredient(name: "Ripe Hass Avocado & Cilantro", amount: "2 pieces", price: 120.00, vendorId: "v-9"),
            Ingredient(name: "Charred Tomatillo Salsa", amount: "200g", price: 140.00, vendorId: "v-9")
        ], instructions: ["Grill meat", "Warm tortillas", "Add toppings", "Squeeze lime"], likes: 640, isLikedByMe: true, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),
        
        Recipe(id: "r-39", title: "Sopa de Tortilla", author: "Chef Sofia", vendorId: "v-9", imageUrls: [
            "https://images.unsplash.com/photo-1512058564366-18510be2db19?q=80&w=800"
        ], description: "Crispy tortilla strips in a rich tomato-guajillo broth.", ingredients: [
            Ingredient(name: "White Corn Masa Tortillas", amount: "12 pack", price: 190.00, vendorId: "v-9"),
            Ingredient(name: "Seasoned Filling & Guajillo Rub", amount: "450g", price: 480.00, vendorId: "v-9"),
            Ingredient(name: "Ripe Hass Avocado & Cilantro", amount: "2 pieces", price: 120.00, vendorId: "v-9"),
            Ingredient(name: "Charred Tomatillo Salsa", amount: "200g", price: 140.00, vendorId: "v-9")
        ], instructions: ["Char tomatoes", "Fry tortilla strips", "Add avocado and lime"], likes: 280, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),

        // Lavington - Indian
        Recipe(id: "r-10", title: "Indian Butter Chicken", author: "Chef Rahul", vendorId: "v-10", imageUrls: [
            "https://images.unsplash.com/photo-1585937421612-70a008356fbe?q=80&w=800"
        ], description: "Tender chicken in rich tomato-butter gravy.", ingredients: [
            Ingredient(name: "Farm-Fresh Chicken Cuts", amount: "600g", price: 460.00, vendorId: "v-10"),
            Ingredient(name: "Garlic, Ginger & Chili Marinade", amount: "1 jar", price: 110.00, vendorId: "v-10"),
            Ingredient(name: "Bell Peppers & Red Onions", amount: "400g", price: 120.00, vendorId: "v-10"),
            Ingredient(name: "Cold-Pressed Sesame Oil & Spices", amount: "150ml", price: 150.00, vendorId: "v-10")
        ], instructions: ["Marinate", "Tandoor chicken", "Simmer sauce", "Add cream"], likes: 720, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),
        
        Recipe(id: "r-40", title: "Mulligatawny Soup", author: "Chef Rahul", vendorId: "v-10", imageUrls: [
            "https://images.unsplash.com/photo-1547592166-23ac45744acd?q=80&w=800"
        ], description: "Curry-flavored lentil soup with apple and coconut milk.", ingredients: [
            Ingredient(name: "Simmer Bone Cuts / Broth Base", amount: "600g", price: 420.00, vendorId: "v-10"),
            Ingredient(name: "Soup Aromatics & Fresh Herbs", amount: "1 bundle", price: 85.00, vendorId: "v-10"),
            Ingredient(name: "Root Vegetables & Onions", amount: "400g", price: 130.00, vendorId: "v-10"),
            Ingredient(name: "Crushed Peppercorns & Lemon", amount: "1 set", price: 60.00, vendorId: "v-10")
        ], instructions: ["Toast curry spices", "Simmer lentils", "Add coconut milk"], likes: 190, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),

        // Westlands - French
        Recipe(id: "r-11", title: "French Steak Frites", author: "Chef Jean", vendorId: "v-11", imageUrls: [
            "https://images.unsplash.com/photo-1550966841-3ee20412e23e?q=80&w=800"
        ], description: "Classic bistro steak served with golden fries.", ingredients: [
            Ingredient(name: "Prime Aged Beef Cuts", amount: "500g", price: 650.00, vendorId: "v-11"),
            Ingredient(name: "Coarse Flaky Sea Salt & Rosemary", amount: "1 jar", price: 90.00, vendorId: "v-11"),
            Ingredient(name: "Hand-Cut Russet Potatoes", amount: "600g", price: 140.00, vendorId: "v-11"),
            Ingredient(name: "Compound Garlic Herb Butter", amount: "100g", price: 120.00, vendorId: "v-11")
        ], instructions: ["Sear steak", "Fry potatoes", "Make herb butter", "Rest steak"], likes: 410, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),
        
        Recipe(id: "r-41", title: "French Onion Soup", author: "Chef Jean", vendorId: "v-11", imageUrls: [
            "https://images.unsplash.com/photo-1512058564366-18510be2db19?q=80&w=800"
        ], description: "Caramelized onions in rich beef broth, topped with gruyère.", ingredients: [
            Ingredient(name: "Simmer Bone Cuts / Broth Base", amount: "600g", price: 420.00, vendorId: "v-11"),
            Ingredient(name: "Soup Aromatics & Fresh Herbs", amount: "1 bundle", price: 85.00, vendorId: "v-11"),
            Ingredient(name: "Root Vegetables & Onions", amount: "400g", price: 130.00, vendorId: "v-11"),
            Ingredient(name: "Crushed Peppercorns & Lemon", amount: "1 set", price: 60.00, vendorId: "v-11")
        ], instructions: ["Caramelize onions", "Deglaze with wine", "Broil with cheese"], likes: 560, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),

        // Muthaiga - Vietnamese
        Recipe(id: "r-12", title: "Vietnamese Beef Pho", author: "Chef Anh", vendorId: "v-12", imageUrls: [
            "https://images.unsplash.com/photo-1583032353423-04fd96ef2211?q=80&w=800"
        ], description: "Fragrant noodle soup with 24-hour beef broth.", ingredients: [
            Ingredient(name: "Prime Aged Beef Cuts", amount: "500g", price: 650.00, vendorId: "v-12"),
            Ingredient(name: "Coarse Flaky Sea Salt & Rosemary", amount: "1 jar", price: 90.00, vendorId: "v-12"),
            Ingredient(name: "Hand-Cut Russet Potatoes", amount: "600g", price: 140.00, vendorId: "v-12"),
            Ingredient(name: "Compound Garlic Herb Butter", amount: "100g", price: 120.00, vendorId: "v-12")
        ], instructions: ["Simmer broth", "Boil noodles", "Thinly slice beef", "Garnish"], likes: 580, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),
        
        Recipe(id: "r-42", title: "Beef Pho Broth", author: "Chef Anh", vendorId: "v-12", imageUrls: [
            "https://images.unsplash.com/photo-1583032353423-04fd96ef2211?q=80&w=800"
        ], description: "The soul of Vietnamese cuisine - a pure, aromatic beef broth.", ingredients: [
            Ingredient(name: "Simmer Bone Cuts / Broth Base", amount: "600g", price: 420.00, vendorId: "v-12"),
            Ingredient(name: "Soup Aromatics & Fresh Herbs", amount: "1 bundle", price: 85.00, vendorId: "v-12"),
            Ingredient(name: "Root Vegetables & Onions", amount: "400g", price: 130.00, vendorId: "v-12"),
            Ingredient(name: "Crushed Peppercorns & Lemon", amount: "1 set", price: 60.00, vendorId: "v-12")
        ], instructions: ["Char ginger and onion", "Simmer bones", "Strain and season"], likes: 215, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),

        // Karen - Moroccan
        Recipe(id: "r-13", title: "Moroccan Lamb Tagine", author: "Chef Fatima", vendorId: "v-13", imageUrls: [
            "https://images.unsplash.com/photo-1539755530861-84426be99ca0?q=80&w=800"
        ], description: "Slow-cooked lamb with apricots and exotic spices.", ingredients: [
            Ingredient(name: "Fresh Moroccan Lamb Tagine Key Cuts", amount: "500g", price: 420.00, vendorId: "v-13"),
            Ingredient(name: "Kitchen Aromatics & Seasonings", amount: "1 set", price: 110.00, vendorId: "v-13"),
            Ingredient(name: "Fresh Local Greens & Herbs", amount: "1 bunch", price: 60.00, vendorId: "v-13"),
            Ingredient(name: "Artisan Side / Accompaniment", amount: "1 portion", price: 150.00, vendorId: "v-13")
        ], instructions: ["Sear lamb", "Add spices", "Slow cook", "Add dried fruit"], likes: 250, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),
        
        Recipe(id: "r-43", title: "Harira Traditional", author: "Chef Fatima", vendorId: "v-13", imageUrls: [
            "https://images.unsplash.com/photo-1547592115-f99998b94df2?q=80&w=800"
        ], description: "Tomato-based soup with lentils, chickpeas, and fresh herbs.", ingredients: [
            Ingredient(name: "Fresh Harira Traditional Key Cuts", amount: "500g", price: 420.00, vendorId: "v-13"),
            Ingredient(name: "Kitchen Aromatics & Seasonings", amount: "1 set", price: 110.00, vendorId: "v-13"),
            Ingredient(name: "Fresh Local Greens & Herbs", amount: "1 bunch", price: 60.00, vendorId: "v-13"),
            Ingredient(name: "Artisan Side / Accompaniment", amount: "1 portion", price: 150.00, vendorId: "v-13")
        ], instructions: ["Sauté onions", "Add lentils and chickpeas", "Simmer with coriander"], likes: 175, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),

        // Runda - Brazilian
        Recipe(id: "r-14", title: "Brazilian Picanha Steak", author: "Chef Ricardo", vendorId: "v-14", imageUrls: [
            "https://images.unsplash.com/photo-1547496502-affa22d38842?q=80&w=800"
        ], description: "Traditional churrasco-style grilled cap of sirloin.", ingredients: [
            Ingredient(name: "Prime Aged Beef Cuts", amount: "500g", price: 650.00, vendorId: "v-14"),
            Ingredient(name: "Coarse Flaky Sea Salt & Rosemary", amount: "1 jar", price: 90.00, vendorId: "v-14"),
            Ingredient(name: "Hand-Cut Russet Potatoes", amount: "600g", price: 140.00, vendorId: "v-14"),
            Ingredient(name: "Compound Garlic Herb Butter", amount: "100g", price: 120.00, vendorId: "v-14")
        ], instructions: ["Score fat", "Salt heavily", "Grill high heat", "Slice thin"], likes: 430, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),
        
        Recipe(id: "r-44", title: "Caldo de Feijão", author: "Chef Ricardo", vendorId: "v-14", imageUrls: [
            "https://images.unsplash.com/photo-1547592115-f99998b94df2?q=80&w=800"
        ], description: "Rich, creamy black bean soup with bacon and garlic.", ingredients: [
            Ingredient(name: "Fresh Caldo de Feijão Key Cuts", amount: "500g", price: 420.00, vendorId: "v-14"),
            Ingredient(name: "Kitchen Aromatics & Seasonings", amount: "1 set", price: 110.00, vendorId: "v-14"),
            Ingredient(name: "Fresh Local Greens & Herbs", amount: "1 bunch", price: 60.00, vendorId: "v-14"),
            Ingredient(name: "Artisan Side / Accompaniment", amount: "1 portion", price: 150.00, vendorId: "v-14")
        ], instructions: ["Boil beans", "Blend into cream", "Add crispy bacon"], likes: 130, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),

        // Lavington - Lebanese
        Recipe(id: "r-15", title: "Lebanese Falafel Wrap", author: "Chef Omar", vendorId: "v-15", imageUrls: [
            "https://images.unsplash.com/photo-1541544741938-0af808871cc0?q=80&w=800"
        ], description: "Crispy chickpea fritters with tahini and fresh veggies.", ingredients: [
            Ingredient(name: "Fresh Lebanese Falafel Wrap Key Cuts", amount: "500g", price: 420.00, vendorId: "v-15"),
            Ingredient(name: "Kitchen Aromatics & Seasonings", amount: "1 set", price: 110.00, vendorId: "v-15"),
            Ingredient(name: "Fresh Local Greens & Herbs", amount: "1 bunch", price: 60.00, vendorId: "v-15"),
            Ingredient(name: "Artisan Side / Accompaniment", amount: "1 portion", price: 150.00, vendorId: "v-15")
        ], instructions: ["Grind chickpeas", "Fry falafel", "Spread hummus", "Wrap tightly"], likes: 190, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),
        
        Recipe(id: "r-45", title: "Lentil Soup (Shorbat Adas)", author: "Chef Omar", vendorId: "v-15", imageUrls: [
            "https://images.unsplash.com/photo-1547592115-f99998b94df2?q=80&w=800"
        ], description: "Yellow lentil soup with cumin and crispy pita chips.", ingredients: [
            Ingredient(name: "Simmer Bone Cuts / Broth Base", amount: "600g", price: 420.00, vendorId: "v-15"),
            Ingredient(name: "Soup Aromatics & Fresh Herbs", amount: "1 bundle", price: 85.00, vendorId: "v-15"),
            Ingredient(name: "Root Vegetables & Onions", amount: "400g", price: 130.00, vendorId: "v-15"),
            Ingredient(name: "Crushed Peppercorns & Lemon", amount: "1 set", price: 60.00, vendorId: "v-15")
        ], instructions: ["Simmer yellow lentils", "Add cumin and turmeric", "Serve with lemon"], likes: 210, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),

        // Westlands - Russian
        Recipe(id: "r-16", title: "Russian Beef Stroganoff", author: "Chef Dimitri", vendorId: "v-16", imageUrls: [
            "https://images.unsplash.com/photo-1574630758414-996417532a39?q=80&w=800"
        ], description: "Tender beef in sour cream and mushroom sauce.", ingredients: [
            Ingredient(name: "Prime Aged Beef Cuts", amount: "500g", price: 650.00, vendorId: "v-16"),
            Ingredient(name: "Coarse Flaky Sea Salt & Rosemary", amount: "1 jar", price: 90.00, vendorId: "v-16"),
            Ingredient(name: "Hand-Cut Russet Potatoes", amount: "600g", price: 140.00, vendorId: "v-16"),
            Ingredient(name: "Compound Garlic Herb Butter", amount: "100g", price: 120.00, vendorId: "v-16")
        ], instructions: ["Sauté beef", "Add mushrooms", "Stir in cream", "Serve over pasta"], likes: 280, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),
        
        Recipe(id: "r-46", title: "Traditional Borscht", author: "Chef Dimitri", vendorId: "v-16", imageUrls: [
            "https://images.unsplash.com/photo-1512058564366-18510be2db19?q=80&w=800"
        ], description: "Classic beet soup with cabbage and beef, served with smetana.", ingredients: [
            Ingredient(name: "Fresh Traditional Borscht Key Cuts", amount: "500g", price: 420.00, vendorId: "v-16"),
            Ingredient(name: "Kitchen Aromatics & Seasonings", amount: "1 set", price: 110.00, vendorId: "v-16"),
            Ingredient(name: "Fresh Local Greens & Herbs", amount: "1 bunch", price: 60.00, vendorId: "v-16"),
            Ingredient(name: "Artisan Side / Accompaniment", amount: "1 portion", price: 150.00, vendorId: "v-16")
        ], instructions: ["Grate beets", "Sauté with vinegar", "Simmer with beef"], likes: 320, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),

        // Muthaiga - Thai
        Recipe(id: "r-17", title: "Thai Pad Thai", author: "Chef Malee", vendorId: "v-17", imageUrls: [
            "https://images.unsplash.com/photo-1559339352-11d035aa65de?q=80&w=800"
        ], description: "Stir-fried rice noodles with shrimp, tofu, and peanuts.", ingredients: [
            Ingredient(name: "Fresh Thai Pad Thai Key Cuts", amount: "500g", price: 420.00, vendorId: "v-17"),
            Ingredient(name: "Kitchen Aromatics & Seasonings", amount: "1 set", price: 110.00, vendorId: "v-17"),
            Ingredient(name: "Fresh Local Greens & Herbs", amount: "1 bunch", price: 60.00, vendorId: "v-17"),
            Ingredient(name: "Artisan Side / Accompaniment", amount: "1 portion", price: 150.00, vendorId: "v-17")
        ], instructions: ["Soak noodles", "Stir fry", "Add tamarind", "Toss peanuts"], likes: 810, isLikedByMe: true, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),
        
        Recipe(id: "r-47", title: "Tom Yum Goong", author: "Chef Malee", vendorId: "v-17", imageUrls: [
            "https://images.unsplash.com/photo-1559339352-11d035aa65de?q=80&w=800"
        ], description: "Hot and sour shrimp soup with lemongrass and galangal.", ingredients: [
            Ingredient(name: "Fresh Tom Yum Goong Key Cuts", amount: "500g", price: 420.00, vendorId: "v-17"),
            Ingredient(name: "Kitchen Aromatics & Seasonings", amount: "1 set", price: 110.00, vendorId: "v-17"),
            Ingredient(name: "Fresh Local Greens & Herbs", amount: "1 bunch", price: 60.00, vendorId: "v-17"),
            Ingredient(name: "Artisan Side / Accompaniment", amount: "1 portion", price: 150.00, vendorId: "v-17")
        ], instructions: ["Boil aromatics", "Add shrimp and mushrooms", "Balance with lime and chili"], likes: 450, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),

        // Karen - Spanish
        Recipe(id: "r-18", title: "Spanish Patatas Bravas", author: "Chef Carlos", vendorId: "v-18", imageUrls: [
            "https://images.unsplash.com/photo-1515443961218-a5136d888be7?q=80&w=800"
        ], description: "Crispy fried potatoes with spicy tomato sauce.", ingredients: [
            Ingredient(name: "Fresh Spanish Patatas Bravas Key Cuts", amount: "500g", price: 420.00, vendorId: "v-18"),
            Ingredient(name: "Kitchen Aromatics & Seasonings", amount: "1 set", price: 110.00, vendorId: "v-18"),
            Ingredient(name: "Fresh Local Greens & Herbs", amount: "1 bunch", price: 60.00, vendorId: "v-18"),
            Ingredient(name: "Artisan Side / Accompaniment", amount: "1 portion", price: 150.00, vendorId: "v-18")
        ], instructions: ["Cube potatoes", "Double fry", "Make salsa brava", "Drizzle aioli"], likes: 370, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),
        
        Recipe(id: "r-48", title: "Gazpacho Andaluz", author: "Chef Carlos", vendorId: "v-18", imageUrls: [
            "https://images.unsplash.com/photo-1547592115-f99998b94df2?q=80&w=800"
        ], description: "Refreshing cold tomato and vegetable soup from Andalusia.", ingredients: [
            Ingredient(name: "Fresh Gazpacho Andaluz Key Cuts", amount: "500g", price: 420.00, vendorId: "v-18"),
            Ingredient(name: "Kitchen Aromatics & Seasonings", amount: "1 set", price: 110.00, vendorId: "v-18"),
            Ingredient(name: "Fresh Local Greens & Herbs", amount: "1 bunch", price: 60.00, vendorId: "v-18"),
            Ingredient(name: "Artisan Side / Accompaniment", amount: "1 portion", price: 150.00, vendorId: "v-18")
        ], instructions: ["Blend raw veggies", "Emulsify with olive oil", "Chill and strain"], likes: 215, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),

        // Runda - Korean
        Recipe(id: "r-19", title: "Korean Bibimbap", author: "Chef Sun-Hi", vendorId: "v-19", imageUrls: [
            "https://images.unsplash.com/photo-1498654896293-37aacf113fd9?q=80&w=800"
        ], description: "Mixed rice bowl with vegetables, beef, and egg.", ingredients: [
            Ingredient(name: "Fresh Korean Bibimbap Key Cuts", amount: "500g", price: 420.00, vendorId: "v-19"),
            Ingredient(name: "Kitchen Aromatics & Seasonings", amount: "1 set", price: 110.00, vendorId: "v-19"),
            Ingredient(name: "Fresh Local Greens & Herbs", amount: "1 bunch", price: 60.00, vendorId: "v-19"),
            Ingredient(name: "Artisan Side / Accompaniment", amount: "1 portion", price: 150.00, vendorId: "v-19")
        ], instructions: ["Steam rice", "Sauté veggies", "Fry egg", "Mix with gochujang"], likes: 540, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),
        
        Recipe(id: "r-49", title: "Kimchi Jjigae", author: "Chef Sun-Hi", vendorId: "v-19", imageUrls: [
            "https://images.unsplash.com/photo-1498654896293-37aacf113fd9?q=80&w=800"
        ], description: "Spicy Korean stew made with aged kimchi and tofu.", ingredients: [
            Ingredient(name: "Fresh Kimchi Jjigae Key Cuts", amount: "500g", price: 420.00, vendorId: "v-19"),
            Ingredient(name: "Kitchen Aromatics & Seasonings", amount: "1 set", price: 110.00, vendorId: "v-19"),
            Ingredient(name: "Fresh Local Greens & Herbs", amount: "1 bunch", price: 60.00, vendorId: "v-19"),
            Ingredient(name: "Artisan Side / Accompaniment", amount: "1 portion", price: 150.00, vendorId: "v-19")
        ], instructions: ["Sauté kimchi", "Add pork and tofu", "Simmer until rich"], likes: 380, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),

        // Lavington - Korean BBQ
        Recipe(id: "r-20", title: "Korean Bulgogi BBQ", author: "Chef Ji-Won", vendorId: "v-20", imageUrls: [
            "https://images.unsplash.com/photo-1529193591184-b1d58069ecdd?q=80&w=800"
        ], description: "Thinly sliced marinated beef grilled to perfection.", ingredients: [
            Ingredient(name: "Fresh Korean Bulgogi BBQ Key Cuts", amount: "500g", price: 420.00, vendorId: "v-20"),
            Ingredient(name: "Kitchen Aromatics & Seasonings", amount: "1 set", price: 110.00, vendorId: "v-20"),
            Ingredient(name: "Fresh Local Greens & Herbs", amount: "1 bunch", price: 60.00, vendorId: "v-20"),
            Ingredient(name: "Artisan Side / Accompaniment", amount: "1 portion", price: 150.00, vendorId: "v-20")
        ], instructions: ["Slice beef", "Marinate in pear", "Grill high heat", "Serve in lettuce"], likes: 620, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),
        
        Recipe(id: "r-50", title: "Samgyetang", author: "Chef Ji-Won", vendorId: "v-20", imageUrls: [
            "https://images.unsplash.com/photo-1547592166-23ac45744acd?q=80&w=800"
        ], description: "Whole young chicken stuffed with ginseng, garlic, and rice.", ingredients: [
            Ingredient(name: "Fresh Samgyetang Key Cuts", amount: "500g", price: 420.00, vendorId: "v-20"),
            Ingredient(name: "Kitchen Aromatics & Seasonings", amount: "1 set", price: 110.00, vendorId: "v-20"),
            Ingredient(name: "Fresh Local Greens & Herbs", amount: "1 bunch", price: 60.00, vendorId: "v-20"),
            Ingredient(name: "Artisan Side / Accompaniment", amount: "1 portion", price: 150.00, vendorId: "v-20")
        ], instructions: ["Stuff chicken", "Simmer with ginseng", "Slow cook until tender"], likes: 290, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),

        // Westlands - Peruvian
        Recipe(id: "r-21", title: "Peruvian Lomo Saltado", author: "Chef Elena", vendorId: "v-21", imageUrls: [
            "https://images.unsplash.com/photo-1504674900247-0877df9cc836?q=80&w=800"
        ], description: "Stir-fried beef with onions, tomatoes, and french fries.", ingredients: [
            Ingredient(name: "Fresh Peruvian Lomo Saltado Key Cuts", amount: "500g", price: 420.00, vendorId: "v-21"),
            Ingredient(name: "Kitchen Aromatics & Seasonings", amount: "1 set", price: 110.00, vendorId: "v-21"),
            Ingredient(name: "Fresh Local Greens & Herbs", amount: "1 bunch", price: 60.00, vendorId: "v-21"),
            Ingredient(name: "Artisan Side / Accompaniment", amount: "1 portion", price: 150.00, vendorId: "v-21")
        ], instructions: ["Sear beef", "Add onions", "Toss in fries", "Serve with rice"], likes: 480, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),
        
        Recipe(id: "r-51", title: "Chupe de Camarones", author: "Chef Elena", vendorId: "v-21", imageUrls: [
            "https://images.unsplash.com/photo-1512058564366-18510be2db19?q=80&w=800"
        ], description: "Rich shrimp chowder with corn, potatoes, and milk.", ingredients: [
            Ingredient(name: "Fresh Chupe de Camarones Key Cuts", amount: "500g", price: 420.00, vendorId: "v-21"),
            Ingredient(name: "Kitchen Aromatics & Seasonings", amount: "1 set", price: 110.00, vendorId: "v-21"),
            Ingredient(name: "Fresh Local Greens & Herbs", amount: "1 bunch", price: 60.00, vendorId: "v-21"),
            Ingredient(name: "Artisan Side / Accompaniment", amount: "1 portion", price: 150.00, vendorId: "v-21")
        ], instructions: ["Sear shrimp", "Make chili paste", "Simmer with milk and egg"], likes: 195, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),

        // Muthaiga - Swiss
        Recipe(id: "r-22", title: "Swiss Cheese Fondue", author: "Chef Hans", vendorId: "v-22", imageUrls: [
            "https://images.unsplash.com/photo-1485962391945-448a60359f6b?q=80&w=800"
        ], description: "Melted Gruyère and Emmental with white wine and garlic.", ingredients: [
            Ingredient(name: "Fresh Swiss Cheese Fondue Key Cuts", amount: "500g", price: 420.00, vendorId: "v-22"),
            Ingredient(name: "Kitchen Aromatics & Seasonings", amount: "1 set", price: 110.00, vendorId: "v-22"),
            Ingredient(name: "Fresh Local Greens & Herbs", amount: "1 bunch", price: 60.00, vendorId: "v-22"),
            Ingredient(name: "Artisan Side / Accompaniment", amount: "1 portion", price: 150.00, vendorId: "v-22")
        ], instructions: ["Rub garlic", "Heat wine", "Stir in cheese", "Dip bread"], likes: 290, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),
        
        Recipe(id: "r-52", title: "Swiss Barley Soup", author: "Chef Hans", vendorId: "v-22", imageUrls: [
            "https://images.unsplash.com/photo-1547592166-23ac45744acd?q=80&w=800"
        ], description: "Hearty alpine soup with pearl barley and smoked meat.", ingredients: [
            Ingredient(name: "Simmer Bone Cuts / Broth Base", amount: "600g", price: 420.00, vendorId: "v-22"),
            Ingredient(name: "Soup Aromatics & Fresh Herbs", amount: "1 bundle", price: 85.00, vendorId: "v-22"),
            Ingredient(name: "Root Vegetables & Onions", amount: "400g", price: 130.00, vendorId: "v-22"),
            Ingredient(name: "Crushed Peppercorns & Lemon", amount: "1 set", price: 60.00, vendorId: "v-22")
        ], instructions: ["Sauté aromatics", "Cook barley", "Add diced ham"], likes: 140, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),

        // Karen - Australian
        Recipe(id: "r-23", title: "Australian Grilled Barramundi", author: "Chef Liam", vendorId: "v-23", imageUrls: [
            "https://images.unsplash.com/photo-1551731359-2b3cf8dfd1ce?q=80&w=800"
        ], description: "Fresh local sea bass grilled with lemon and herbs.", ingredients: [
            Ingredient(name: "Fresh Australian Grilled Barramundi Key Cuts", amount: "500g", price: 420.00, vendorId: "v-23"),
            Ingredient(name: "Kitchen Aromatics & Seasonings", amount: "1 set", price: 110.00, vendorId: "v-23"),
            Ingredient(name: "Fresh Local Greens & Herbs", amount: "1 bunch", price: 60.00, vendorId: "v-23"),
            Ingredient(name: "Artisan Side / Accompaniment", amount: "1 portion", price: 150.00, vendorId: "v-23")
        ], instructions: ["Season fish", "Grill skin down", "Flip gently", "Serve with lemon"], likes: 360, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),
        
        Recipe(id: "r-53", title: "Seafood Chowder Oz", author: "Chef Liam", vendorId: "v-23", imageUrls: [
            "https://images.unsplash.com/photo-1512058564366-18510be2db19?q=80&w=800"
        ], description: "Creamy coastal chowder with local snapper and mussels.", ingredients: [
            Ingredient(name: "Simmer Bone Cuts / Broth Base", amount: "600g", price: 420.00, vendorId: "v-23"),
            Ingredient(name: "Soup Aromatics & Fresh Herbs", amount: "1 bundle", price: 85.00, vendorId: "v-23"),
            Ingredient(name: "Root Vegetables & Onions", amount: "400g", price: 130.00, vendorId: "v-23"),
            Ingredient(name: "Crushed Peppercorns & Lemon", amount: "1 set", price: 60.00, vendorId: "v-23")
        ], instructions: ["Sauté bacon", "Simmer seafood", "Add thick cream"], likes: 210, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),

        // Runda - Canadian
        Recipe(id: "r-24", title: "Canadian Classic Poutine", author: "Chef Marc", vendorId: "v-24", imageUrls: [
            "https://images.unsplash.com/photo-1586511925558-a4c6376fe65f?q=80&w=800"
        ], description: "Golden fries topped with fresh cheese curds and hot gravy.", ingredients: [
            Ingredient(name: "Fresh Canadian Classic Poutine Key Cuts", amount: "500g", price: 420.00, vendorId: "v-24"),
            Ingredient(name: "Kitchen Aromatics & Seasonings", amount: "1 set", price: 110.00, vendorId: "v-24"),
            Ingredient(name: "Fresh Local Greens & Herbs", amount: "1 bunch", price: 60.00, vendorId: "v-24"),
            Ingredient(name: "Artisan Side / Accompaniment", amount: "1 portion", price: 150.00, vendorId: "v-24")
        ], instructions: ["Hand cut fries", "Heat brown gravy", "Top with curds", "Pour gravy"], likes: 510, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),
        
        Recipe(id: "r-54", title: "Habitant Pea Soup", author: "Chef Marc", vendorId: "v-24", imageUrls: [
            "https://images.unsplash.com/photo-1547592115-f99998b94df2?q=80&w=800"
        ], description: "Traditional yellow split pea soup with ham hock.", ingredients: [
            Ingredient(name: "Simmer Bone Cuts / Broth Base", amount: "600g", price: 420.00, vendorId: "v-24"),
            Ingredient(name: "Soup Aromatics & Fresh Herbs", amount: "1 bundle", price: 85.00, vendorId: "v-24"),
            Ingredient(name: "Root Vegetables & Onions", amount: "400g", price: 130.00, vendorId: "v-24"),
            Ingredient(name: "Crushed Peppercorns & Lemon", amount: "1 set", price: 60.00, vendorId: "v-24")
        ], instructions: ["Soak peas", "Simmer with ham", "Mash until thick"], likes: 180, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),

        // Lavington - Portuguese
        Recipe(id: "r-25", title: "Portuguese Bacalhau", author: "Chef Tiago", vendorId: "v-25", imageUrls: [
            "https://images.unsplash.com/photo-1534080564607-198f9dd5d61a?q=80&w=800"
        ], description: "Traditional salted cod dish with potatoes and olives.", ingredients: [
            Ingredient(name: "Fresh Portuguese Bacalhau Key Cuts", amount: "500g", price: 420.00, vendorId: "v-25"),
            Ingredient(name: "Kitchen Aromatics & Seasonings", amount: "1 set", price: 110.00, vendorId: "v-25"),
            Ingredient(name: "Fresh Local Greens & Herbs", amount: "1 bunch", price: 60.00, vendorId: "v-25"),
            Ingredient(name: "Artisan Side / Accompaniment", amount: "1 portion", price: 150.00, vendorId: "v-25")
        ], instructions: ["Soak cod", "Shred fish", "Layer with onions", "Bake with cream"], likes: 220, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),
        
        Recipe(id: "r-55", title: "Caldo Verde Original", author: "Chef Tiago", vendorId: "v-25", imageUrls: [
            "https://images.unsplash.com/photo-1512058564366-18510be2db19?q=80&w=800"
        ], description: "Potato and kale soup with spicy chouriço sausage.", ingredients: [
            Ingredient(name: "Fresh Caldo Verde Original Key Cuts", amount: "500g", price: 420.00, vendorId: "v-25"),
            Ingredient(name: "Kitchen Aromatics & Seasonings", amount: "1 set", price: 110.00, vendorId: "v-25"),
            Ingredient(name: "Fresh Local Greens & Herbs", amount: "1 bunch", price: 60.00, vendorId: "v-25"),
            Ingredient(name: "Artisan Side / Accompaniment", amount: "1 portion", price: 150.00, vendorId: "v-25")
        ], instructions: ["Boil potatoes", "Add shredded kale", "Slice chouriço"], likes: 245, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),

        // Westlands - Danish
        Recipe(id: "r-26", title: "Danish Smørrebrød", author: "Chef Soren", vendorId: "v-26", imageUrls: [
            "https://images.unsplash.com/photo-1559339352-11d035aa65de?q=80&w=800"
        ], description: "Open-faced rye bread sandwich with pickled herring.", ingredients: [
            Ingredient(name: "Fresh Danish Smørrebrød Key Cuts", amount: "500g", price: 420.00, vendorId: "v-26"),
            Ingredient(name: "Kitchen Aromatics & Seasonings", amount: "1 set", price: 110.00, vendorId: "v-26"),
            Ingredient(name: "Fresh Local Greens & Herbs", amount: "1 bunch", price: 60.00, vendorId: "v-26"),
            Ingredient(name: "Artisan Side / Accompaniment", amount: "1 portion", price: 150.00, vendorId: "v-26")
        ], instructions: ["Butter rye bread", "Add herring", "Top with dill", "Add capers"], likes: 180, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),
        
        Recipe(id: "r-56", title: "Yellow Pea Soup", author: "Chef Soren", vendorId: "v-26", imageUrls: [
            "https://images.unsplash.com/photo-1547592115-f99998b94df2?q=80&w=800"
        ], description: "Danish Gule Ærter with pork and aromatic vegetables.", ingredients: [
            Ingredient(name: "Simmer Bone Cuts / Broth Base", amount: "600g", price: 420.00, vendorId: "v-26"),
            Ingredient(name: "Soup Aromatics & Fresh Herbs", amount: "1 bundle", price: 85.00, vendorId: "v-26"),
            Ingredient(name: "Root Vegetables & Onions", amount: "400g", price: 130.00, vendorId: "v-26"),
            Ingredient(name: "Crushed Peppercorns & Lemon", amount: "1 set", price: 60.00, vendorId: "v-26")
        ], instructions: ["Cook peas", "Add root veggies", "Slice pork roast"], likes: 110, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),

        // Muthaiga - Austrian
        Recipe(id: "r-27", title: "Austrian Sachertorte", author: "Chef Franz", vendorId: "v-27", imageUrls: [
            "https://images.unsplash.com/photo-1488477181946-6428a0291777?q=80&w=800"
        ], description: "Dense chocolate cake with a thin layer of apricot jam.", ingredients: [
            Ingredient(name: "Fresh Austrian Sachertorte Key Cuts", amount: "500g", price: 420.00, vendorId: "v-27"),
            Ingredient(name: "Kitchen Aromatics & Seasonings", amount: "1 set", price: 110.00, vendorId: "v-27"),
            Ingredient(name: "Fresh Local Greens & Herbs", amount: "1 bunch", price: 60.00, vendorId: "v-27"),
            Ingredient(name: "Artisan Side / Accompaniment", amount: "1 portion", price: 150.00, vendorId: "v-27")
        ], instructions: ["Bake sponge", "Slice and jam", "Glaze chocolate", "Serve with cream"], likes: 670, isLikedByMe: true, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),
        
        Recipe(id: "r-57", title: "Goulash Soup", author: "Chef Franz", vendorId: "v-27", imageUrls: [
            "https://images.unsplash.com/photo-1547592166-23ac45744acd?q=80&w=800"
        ], description: "Hearty Austrian beef and paprika soup.", ingredients: [
            Ingredient(name: "Simmer Bone Cuts / Broth Base", amount: "600g", price: 420.00, vendorId: "v-27"),
            Ingredient(name: "Soup Aromatics & Fresh Herbs", amount: "1 bundle", price: 85.00, vendorId: "v-27"),
            Ingredient(name: "Root Vegetables & Onions", amount: "400g", price: 130.00, vendorId: "v-27"),
            Ingredient(name: "Crushed Peppercorns & Lemon", amount: "1 set", price: 60.00, vendorId: "v-27")
        ], instructions: ["Sauté onions", "Add paprika and beef", "Slow cook until tender"], likes: 295, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),

        // Karen - Jamaican
        Recipe(id: "r-28", title: "Jamaican Jerk Chicken", author: "Chef Kingsley", vendorId: "v-28", imageUrls: [
            "https://images.unsplash.com/photo-1533777857419-d2d305d7b578?q=80&w=800"
        ], description: "Spicy and smoky chicken marinated in scotch bonnet peppers.", ingredients: [
            Ingredient(name: "Farm-Fresh Chicken Cuts", amount: "600g", price: 460.00, vendorId: "v-28"),
            Ingredient(name: "Garlic, Ginger & Chili Marinade", amount: "1 jar", price: 110.00, vendorId: "v-28"),
            Ingredient(name: "Bell Peppers & Red Onions", amount: "400g", price: 120.00, vendorId: "v-28"),
            Ingredient(name: "Cold-Pressed Sesame Oil & Spices", amount: "150ml", price: 150.00, vendorId: "v-28")
        ], instructions: ["Rub with spice", "Marinate 24h", "Smoke over wood", "Chop and serve"], likes: 490, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),
        
        Recipe(id: "r-58", title: "Red Peas Soup", author: "Chef Kingsley", vendorId: "v-28", imageUrls: [
            "https://images.unsplash.com/photo-1547592115-f99998b94df2?q=80&w=800"
        ], description: "Rich kidney bean soup with coconut milk and flour dumplings.", ingredients: [
            Ingredient(name: "Simmer Bone Cuts / Broth Base", amount: "600g", price: 420.00, vendorId: "v-28"),
            Ingredient(name: "Soup Aromatics & Fresh Herbs", amount: "1 bundle", price: 85.00, vendorId: "v-28"),
            Ingredient(name: "Root Vegetables & Onions", amount: "400g", price: 130.00, vendorId: "v-28"),
            Ingredient(name: "Crushed Peppercorns & Lemon", amount: "1 set", price: 60.00, vendorId: "v-28")
        ], instructions: ["Boil peas", "Make spinners", "Add coconut milk"], likes: 185, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),

        // Runda - Indonesian
        Recipe(id: "r-29", title: "Indonesian Nasi Goreng", author: "Chef Putu", vendorId: "v-29", imageUrls: [
            "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=800"
        ], description: "Spiced fried rice with sweet soy sauce and fried egg.", ingredients: [
            Ingredient(name: "Fresh Indonesian Nasi Goreng Key Cuts", amount: "500g", price: 420.00, vendorId: "v-29"),
            Ingredient(name: "Kitchen Aromatics & Seasonings", amount: "1 set", price: 110.00, vendorId: "v-29"),
            Ingredient(name: "Fresh Local Greens & Herbs", amount: "1 bunch", price: 60.00, vendorId: "v-29"),
            Ingredient(name: "Artisan Side / Accompaniment", amount: "1 portion", price: 150.00, vendorId: "v-29")
        ], instructions: ["Sauté paste", "Add day-old rice", "Add kecap manis", "Top with egg"], likes: 450, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),
        
        Recipe(id: "r-59", title: "Soto Ayam", author: "Chef Putu", vendorId: "v-29", imageUrls: [
            "https://images.unsplash.com/photo-1547592166-23ac45744acd?q=80&w=800"
        ], description: "Turmeric-infused chicken soup with glass noodles and lime.", ingredients: [
            Ingredient(name: "Fresh Soto Ayam Key Cuts", amount: "500g", price: 420.00, vendorId: "v-29"),
            Ingredient(name: "Kitchen Aromatics & Seasonings", amount: "1 set", price: 110.00, vendorId: "v-29"),
            Ingredient(name: "Fresh Local Greens & Herbs", amount: "1 bunch", price: 60.00, vendorId: "v-29"),
            Ingredient(name: "Artisan Side / Accompaniment", amount: "1 portion", price: 150.00, vendorId: "v-29")
        ], instructions: ["Make turmeric spice", "Boil chicken", "Add noodles and egg"], likes: 210, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),

        // Lavington - Egyptian
        Recipe(id: "r-30", title: "Egyptian Koshary", author: "Chef Mahmoud", vendorId: "v-30", imageUrls: [
            "https://images.unsplash.com/photo-1567156942642-4f96446e502c?q=80&w=800"
        ], description: "Hearty mix of rice, pasta, lentils, and spicy tomato sauce.", ingredients: [
            Ingredient(name: "Fresh Egyptian Koshary Key Cuts", amount: "500g", price: 420.00, vendorId: "v-30"),
            Ingredient(name: "Kitchen Aromatics & Seasonings", amount: "1 set", price: 110.00, vendorId: "v-30"),
            Ingredient(name: "Fresh Local Greens & Herbs", amount: "1 bunch", price: 60.00, vendorId: "v-30"),
            Ingredient(name: "Artisan Side / Accompaniment", amount: "1 portion", price: 150.00, vendorId: "v-30")
        ], instructions: ["Boil lentils", "Cook rice", "Make sauce", "Top with onions"], likes: 320, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ]),
        
        Recipe(id: "r-60", title: "Molokhia Traditional", author: "Chef Mahmoud", vendorId: "v-30", imageUrls: [
            "https://images.unsplash.com/photo-1512058564366-18510be2db19?q=80&w=800"
        ], description: "Minced jute mallow leaves cooked in aromatic garlic broth.", ingredients: [
            Ingredient(name: "Fresh Molokhia Traditional Key Cuts", amount: "500g", price: 420.00, vendorId: "v-30"),
            Ingredient(name: "Kitchen Aromatics & Seasonings", amount: "1 set", price: 110.00, vendorId: "v-30"),
            Ingredient(name: "Fresh Local Greens & Herbs", amount: "1 bunch", price: 60.00, vendorId: "v-30"),
            Ingredient(name: "Artisan Side / Accompaniment", amount: "1 portion", price: 150.00, vendorId: "v-30")
        ], instructions: ["Make tasha", "Cook molokhia leaves", "Simmer broth"], likes: 340, isLikedByMe: false, comments: [
            Comment(id: UUID(), author: "Njeri W.", text: "Made this for Sunday family dinner — everyone asked for seconds!", date: Date().addingTimeInterval(-86400), replies: []),
            Comment(id: UUID(), author: "Brian K.", text: "The proportion of spices was spot on. Ordered the basket through the app.", date: Date().addingTimeInterval(-21600), replies: [])
        ])
    ]
    
    private var continuations: [UUID: AsyncStream<[Recipe]>.Continuation] = [:]
    
    func fetchRecipes() async throws -> [Recipe] {
        try? await Task.sleep(nanoseconds: 50_000_000)
        return recipes
    }
    
    func streamRecipes() -> AsyncStream<[Recipe]> {
        AsyncStream { continuation in
            let id = UUID()
            continuation.yield(recipes)
            continuations[id] = continuation
            
            continuation.onTermination = { [weak self] _ in
                self?.continuations.removeValue(forKey: id)
            }
        }
    }
    
    func toggleLike(recipeId: String) async throws {
        try? await Task.sleep(nanoseconds: 50_000_000)
        if let index = recipes.firstIndex(where: { $0.id == recipeId }) {
            var recipe = recipes[index]
            if recipe.isLikedByMe {
                recipe.likes -= 1
                recipe.isLikedByMe = false
            } else {
                recipe.likes += 1
                recipe.isLikedByMe = true
            }
            recipes[index] = recipe
            notify()
        }
    }
    
    func createRecipe(_ recipe: Recipe) async throws {
        try? await Task.sleep(nanoseconds: 50_000_000)
        recipes.insert(recipe, at: 0)
        notify()
    }

    func addComment(recipeId: String, comment: Comment) async throws {
        try? await Task.sleep(nanoseconds: 50_000_000)
        if let index = recipes.firstIndex(where: { $0.id == recipeId }) {
            recipes[index].comments.append(comment)
            notify()
        }
    }
    
    private func notify() {
        for continuation in continuations.values {
            continuation.yield(recipes)
        }
    }
}
