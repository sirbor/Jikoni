import Foundation

class MockRecipeRepository: RecipeRepository {
    private var recipes: [Recipe] = [
        Recipe(id: "r-1", title: "Traditional Beef Pilau", author: "Chef Mama Juma", vendorId: "v-1", imageUrls: [
            "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=800",
            "https://images.unsplash.com/photo-1541544741938-0af808871cc0?q=80&w=800",
            "https://images.unsplash.com/photo-1541544741938-0af808871cc0?q=80&w=800"
        ], description: "Fragrant Swahili rice cooked with tender beef and warm spices.", ingredients: [], instructions: ["Boil beef", "Fry onions until dark", "Add masala", "Cook rice"], likes: 120, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-2", title: "Classic Beef Lasagna", author: "Chef Giovanni", vendorId: "v-2", imageUrls: [
            "https://images.unsplash.com/photo-1551183053-bf91a1d81141?q=80&w=800",
            "https://images.unsplash.com/photo-1551183053-bf91a1d81141?q=80&w=800",
            "https://images.unsplash.com/photo-1551183053-bf91a1d81141?q=80&w=800"
        ], description: "Rich meat sauce and creamy béchamel layered with pasta.", ingredients: [], instructions: ["Make ragu", "Make béchamel", "Layer", "Bake"], likes: 340, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-3", title: "Spicy Kung Pao Chicken", author: "Chef Wei", vendorId: "v-3", imageUrls: [
            "https://images.unsplash.com/photo-1525755662778-989d0524087e?q=80&w=800",
            "https://images.unsplash.com/photo-1552566626-52f8b828add9?q=80&w=800",
            "https://images.unsplash.com/photo-1563245372-f21724e3856d?q=80&w=800"
        ], description: "Szechuan classic with peanuts and chili peppers.", ingredients: [], instructions: ["Marinate", "Stir fry chicken", "Add peanuts", "Sauce"], likes: 210, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-4", title: "Turkish Adana Kebab", author: "Chef Selim", vendorId: "v-4", imageUrls: [
            "https://images.unsplash.com/photo-1555939594-58d7cb561ad1?q=80&w=800",
            "https://images.unsplash.com/photo-1565895405138-6c3a1555da6a?q=80&w=800",
            "https://images.unsplash.com/photo-1473093226795-af9932fe5856?q=80&w=800"
        ], description: "Hand-minced meat mixed with chili and grilled.", ingredients: [], instructions: ["Mince meat", "Season", "Skewer", "Grill"], likes: 450, isLikedByMe: true, comments: []),
        
        Recipe(id: "r-5", title: "Greek Spanakopita", author: "Chef Yiannis", vendorId: "v-5", imageUrls: [
            "https://images.unsplash.com/photo-1512484776495-a09d92e87c3b?q=80&w=800",
            "https://images.unsplash.com/photo-1544148103-6375bc3d9310?q=80&w=800",
            "https://images.unsplash.com/photo-1533777857419-d2d305d7b578?q=80&w=800"
        ], description: "Flaky phyllo pastry filled with spinach and feta.", ingredients: [], instructions: ["Prep spinach", "Layer phyllo", "Fill", "Bake"], likes: 180, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-6", title: "Salmon Sushi Rolls", author: "Chef Hiro", vendorId: "v-6", imageUrls: [
            "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?q=80&w=800",
            "https://images.unsplash.com/photo-1517248135467-d64a6d4c4b5d?q=80&w=800",
            "https://images.unsplash.com/photo-1555396273-fc6723b82a3a?q=80&w=800"
        ], description: "Fresh salmon and cucumber in premium sushi rice.", ingredients: [], instructions: ["Prep rice", "Slice salmon", "Roll", "Slice"], likes: 520, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-7", title: "Georgian Khachapuri", author: "Chef Nino", vendorId: "v-7", imageUrls: [
            "https://images.unsplash.com/photo-1603048588665-791ca8aea617?q=80&w=800",
            "https://images.unsplash.com/photo-1560624052-449f5ddf0c31?q=80&w=800",
            "https://images.unsplash.com/photo-1514362545851-46043bc9289b?q=80&w=800"
        ], description: "Cheese-filled bread topped with an egg and butter.", ingredients: [], instructions: ["Make dough", "Shape boat", "Add cheese", "Bake"], likes: 890, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-8", title: "Habesha Injera Platter", author: "Chef Abeba", vendorId: "v-8", imageUrls: [
            "https://images.unsplash.com/photo-1548946522-4a313e8972a4?q=80&w=800",
            "https://images.unsplash.com/photo-1514933651103-005eec06c04b?q=80&w=800",
            "https://images.unsplash.com/photo-1414235077428-338989a2e8c0?q=80&w=800"
        ], description: "Traditional fermented flatbread with various stews.", ingredients: [], instructions: ["Ferment teff", "Cook injera", "Prepare wats", "Assemble"], likes: 310, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-9", title: "Mexican Street Tacos", author: "Chef Sofia", vendorId: "v-9", imageUrls: [
            "https://images.unsplash.com/photo-1565299585323-38d6b0865b47?q=80&w=800",
            "https://images.unsplash.com/photo-1565299624-94451961502b?q=80&w=800",
            "https://images.unsplash.com/photo-1552332386-f8dd00dc2f85?q=80&w=800"
        ], description: "Authentic corn tortillas with seasoned meats and salsa.", ingredients: [], instructions: ["Grill meat", "Warm tortillas", "Add toppings", "Squeeze lime"], likes: 640, isLikedByMe: true, comments: []),
        
        Recipe(id: "r-10", title: "Indian Butter Chicken", author: "Chef Rahul", vendorId: "v-10", imageUrls: [
            "https://images.unsplash.com/photo-1585937421612-70a008356fbe?q=80&w=800",
            "https://images.unsplash.com/photo-1517248135467-d64a6d4c4b5d?q=80&w=800",
            "https://images.unsplash.com/photo-1502301103665-0b95cc738def?q=80&w=800"
        ], description: "Tender chicken in rich tomato-butter gravy.", ingredients: [], instructions: ["Marinate", "Tandoor chicken", "Simmer sauce", "Add cream"], likes: 720, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-11", title: "French Steak Frites", author: "Chef Jean", vendorId: "v-11", imageUrls: [
            "https://images.unsplash.com/photo-1502301103665-0b95cc738def?q=80&w=800",
            "https://images.unsplash.com/photo-1550966841-3ee20412e23e?q=80&w=800",
            "https://images.unsplash.com/photo-1544148103-6375bc3d9310?q=80&w=800"
        ], description: "Classic bistro steak served with golden fries.", ingredients: [], instructions: ["Sear steak", "Fry potatoes", "Make herb butter", "Rest steak"], likes: 410, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-12", title: "Vietnamese Beef Pho", author: "Chef Anh", vendorId: "v-12", imageUrls: [
            "https://images.unsplash.com/photo-1583032353423-04fd96ef2211?q=80&w=800",
            "https://images.unsplash.com/photo-1503767849114-976b67568b02?q=80&w=800",
            "https://images.unsplash.com/photo-1552566626-52f8b828add9?q=80&w=800"
        ], description: "Fragrant noodle soup with 24-hour beef broth.", ingredients: [], instructions: ["Simmer broth", "Boil noodles", "Thinly slice beef", "Garnish"], likes: 580, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-13", title: "Moroccan Lamb Tagine", author: "Chef Fatima", vendorId: "v-13", imageUrls: [
            "https://images.unsplash.com/photo-1539755530861-84426be99ca0?q=80&w=800",
            "https://images.unsplash.com/photo-1541544741938-0af808871cc0?q=80&w=800",
            "https://images.unsplash.com/photo-1514362545851-46043bc9289b?q=80&w=800"
        ], description: "Slow-cooked lamb with apricots and exotic spices.", ingredients: [], instructions: ["Sear lamb", "Add spices", "Slow cook", "Add dried fruit"], likes: 250, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-14", title: "Brazilian Picanha Steak", author: "Chef Ricardo", vendorId: "v-14", imageUrls: [
            "https://images.unsplash.com/photo-1547496502-affa22d38842?q=80&w=800",
            "https://images.unsplash.com/photo-1559339352-11d035aa65de?q=80&w=800",
            "https://images.unsplash.com/photo-1517248135467-d64a6d4c4b5d?q=80&w=800"
        ], description: "Traditional churrasco-style grilled cap of sirloin.", ingredients: [], instructions: ["Score fat", "Salt heavily", "Grill high heat", "Slice thin"], likes: 430, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-15", title: "Lebanese Falafel Wrap", author: "Chef Omar", vendorId: "v-15", imageUrls: [
            "https://images.unsplash.com/photo-1541544741938-0af808871cc0?q=80&w=800",
            "https://images.unsplash.com/photo-1514933651103-005eec06c04b?q=80&w=800",
            "https://images.unsplash.com/photo-1555396273-fc6723b82a3a?q=80&w=800"
        ], description: "Crispy chickpea fritters with tahini and fresh veggies.", ingredients: [], instructions: ["Grind chickpeas", "Fry falafel", "Spread hummus", "Wrap tightly"], likes: 190, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-16", title: "Russian Beef Stroganoff", author: "Chef Dimitri", vendorId: "v-16", imageUrls: [
            "https://images.unsplash.com/photo-1574630758414-996417532a39?q=80&w=800",
            "https://images.unsplash.com/photo-1552566626-52f8b828add9?q=80&w=800",
            "https://images.unsplash.com/photo-1563245372-f21724e3856d?q=80&w=800"
        ], description: "Tender beef in sour cream and mushroom sauce.", ingredients: [], instructions: ["Sauté beef", "Add mushrooms", "Stir in cream", "Serve over pasta"], likes: 280, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-17", title: "Thai Pad Thai", author: "Chef Malee", vendorId: "v-17", imageUrls: [
            "https://images.unsplash.com/photo-1559339352-11d035aa65de?q=80&w=800",
            "https://images.unsplash.com/photo-1502301103665-0b95cc738def?q=80&w=800",
            "https://images.unsplash.com/photo-1517248135467-d64a6d4c4b5d?q=80&w=800"
        ], description: "Stir-fried rice noodles with shrimp, tofu, and peanuts.", ingredients: [], instructions: ["Soak noodles", "Stir fry", "Add tamarind", "Toss peanuts"], likes: 810, isLikedByMe: true, comments: []),
        
        Recipe(id: "r-18", title: "Spanish Patatas Bravas", author: "Chef Carlos", vendorId: "v-18", imageUrls: [
            "https://images.unsplash.com/photo-1515443961218-a5136d888be7?q=80&w=800",
            "https://images.unsplash.com/photo-1565895405138-6c3a1555da6a?q=80&w=800",
            "https://images.unsplash.com/photo-1473093226795-af9932fe5856?q=80&w=800"
        ], description: "Crispy fried potatoes with spicy tomato sauce.", ingredients: [], instructions: ["Cube potatoes", "Double fry", "Make salsa brava", "Drizzle aioli"], likes: 370, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-19", title: "Korean Bibimbap", author: "Chef Sun-Hi", vendorId: "v-19", imageUrls: [
            "https://images.unsplash.com/photo-1498654896293-37aacf113fd9?q=80&w=800",
            "https://images.unsplash.com/photo-1555396273-fc6723b82a3a?q=80&w=800",
            "https://images.unsplash.com/photo-1517248135467-d64a6d4c4b5d?q=80&w=800"
        ], description: "Mixed rice bowl with vegetables, beef, and egg.", ingredients: [], instructions: ["Steam rice", "Sauté veggies", "Fry egg", "Mix with gochujang"], likes: 540, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-20", title: "Korean Bulgogi BBQ", author: "Chef Ji-Won", vendorId: "v-20", imageUrls: [
            "https://images.unsplash.com/photo-1529193591184-b1d58069ecdd?q=80&w=800",
            "https://images.unsplash.com/photo-1544148103-6375bc3d9310?q=80&w=800",
            "https://images.unsplash.com/photo-1514933651103-005eec06c04b?q=80&w=800"
        ], description: "Thinly sliced marinated beef grilled to perfection.", ingredients: [], instructions: ["Slice beef", "Marinate in pear", "Grill high heat", "Serve in lettuce"], likes: 620, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-21", title: "Peruvian Lomo Saltado", author: "Chef Elena", vendorId: "v-21", imageUrls: [
            "https://images.unsplash.com/photo-1504674900247-0877df9cc836?q=80&w=800",
            "https://images.unsplash.com/photo-1550966841-3ee20412e23e?q=80&w=800",
            "https://images.unsplash.com/photo-1551183053-bf91a1d81141?q=80&w=800"
        ], description: "Stir-fried beef with onions, tomatoes, and french fries.", ingredients: [], instructions: ["Sear beef", "Add onions", "Toss in fries", "Serve with rice"], likes: 480, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-22", title: "Swiss Cheese Fondue", author: "Chef Hans", vendorId: "v-22", imageUrls: [
            "https://images.unsplash.com/photo-1485962391945-448a60359f6b?q=80&w=800",
            "https://images.unsplash.com/photo-1514362545851-46043bc9289b?q=80&w=800",
            "https://images.unsplash.com/photo-1552566626-52f8b828add9?q=80&w=800"
        ], description: "Melted Gruyère and Emmental with white wine and garlic.", ingredients: [], instructions: ["Rub garlic", "Heat wine", "Stir in cheese", "Dip bread"], likes: 290, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-23", title: "Australian Grilled Barramundi", author: "Chef Liam", vendorId: "v-23", imageUrls: [
            "https://images.unsplash.com/photo-1551731359-2b3cf8dfd1ce?q=80&w=800",
            "https://images.unsplash.com/photo-1517248135467-d64a6d4c4b5d?q=80&w=800",
            "https://images.unsplash.com/photo-1555396273-fc6723b82a3a?q=80&w=800"
        ], description: "Fresh local sea bass grilled with lemon and herbs.", ingredients: [], instructions: ["Season fish", "Grill skin down", "Flip gently", "Serve with lemon"], likes: 360, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-24", title: "Canadian Classic Poutine", author: "Chef Marc", vendorId: "v-24", imageUrls: [
            "https://images.unsplash.com/photo-1586511925558-a4c6376fe65f?q=80&w=800",
            "https://images.unsplash.com/photo-1563245372-f21724e3856d?q=80&w=800",
            "https://images.unsplash.com/photo-1552332386-f8dd00dc2f85?q=80&w=800"
        ], description: "Golden fries topped with fresh cheese curds and hot gravy.", ingredients: [], instructions: ["Hand cut fries", "Heat brown gravy", "Top with curds", "Pour gravy"], likes: 510, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-25", title: "Portuguese Bacalhau", author: "Chef Tiago", vendorId: "v-25", imageUrls: [
            "https://images.unsplash.com/photo-1534080564607-198f9dd5d61a?q=80&w=800",
            "https://images.unsplash.com/photo-1502301103665-0b95cc738def?q=80&w=800",
            "https://images.unsplash.com/photo-1544148103-6375bc3d9310?q=80&w=800"
        ], description: "Traditional salted cod dish with potatoes and olives.", ingredients: [], instructions: ["Soak cod", "Shred fish", "Layer with onions", "Bake with cream"], likes: 220, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-26", title: "Danish Smørrebrød", author: "Chef Soren", vendorId: "v-26", imageUrls: [
            "https://images.unsplash.com/photo-1559339352-11d035aa65de?q=80&w=800",
            "https://images.unsplash.com/photo-1514933651103-005eec06c04b?q=80&w=800",
            "https://images.unsplash.com/photo-1555396273-fc6723b82a3a?q=80&w=800"
        ], description: "Open-faced rye bread sandwich with pickled herring.", ingredients: [], instructions: ["Butter rye bread", "Add herring", "Top with dill", "Add capers"], likes: 180, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-27", title: "Austrian Sachertorte", author: "Chef Franz", vendorId: "v-27", imageUrls: [
            "https://images.unsplash.com/photo-1488477181946-6428a0291777?q=80&w=800",
            "https://images.unsplash.com/photo-1552566626-52f8b828add9?q=80&w=800",
            "https://images.unsplash.com/photo-1517248135467-d64a6d4c4b5d?q=80&w=800"
        ], description: "Dense chocolate cake with a thin layer of apricot jam.", ingredients: [], instructions: ["Bake sponge", "Slice and jam", "Glaze chocolate", "Serve with cream"], likes: 670, isLikedByMe: true, comments: []),
        
        Recipe(id: "r-28", title: "Jamaican Jerk Chicken", author: "Chef Kingsley", vendorId: "v-28", imageUrls: [
            "https://images.unsplash.com/photo-1533777857419-d2d305d7b578?q=80&w=800",
            "https://images.unsplash.com/photo-1514362545851-46043bc9289b?q=80&w=800",
            "https://images.unsplash.com/photo-1551183053-bf91a1d81141?q=80&w=800"
        ], description: "Spicy and smoky chicken marinated in scotch bonnet peppers.", ingredients: [], instructions: ["Rub with spice", "Marinate 24h", "Smoke over wood", "Chop and serve"], likes: 490, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-29", title: "Indonesian Nasi Goreng", author: "Chef Putu", vendorId: "v-29", imageUrls: [
            "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=800",
            "https://images.unsplash.com/photo-1544148103-6375bc3d9310?q=80&w=800",
            "https://images.unsplash.com/photo-1514933651103-005eec06c04b?q=80&w=800"
        ], description: "Spiced fried rice with sweet soy sauce and fried egg.", ingredients: [], instructions: ["Sauté paste", "Add day-old rice", "Add kecap manis", "Top with egg"], likes: 450, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-30", title: "Egyptian Koshary", author: "Chef Mahmoud", vendorId: "v-30", imageUrls: [
            "https://images.unsplash.com/photo-1567156942642-4f96446e502c?q=80&w=800",
            "https://images.unsplash.com/photo-1552332386-f8dd00dc2f85?q=80&w=800",
            "https://images.unsplash.com/photo-1555396273-fc6723b82a3a?q=80&w=800"
        ], description: "Hearty mix of rice, pasta, lentils, and spicy tomato sauce.", ingredients: [], instructions: ["Boil lentils", "Cook rice", "Make sauce", "Top with onions"], likes: 320, isLikedByMe: false, comments: [])
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
    
    private func notify() {
        for continuation in continuations.values {
            continuation.yield(recipes)
        }
    }
}
