import Foundation

class MockRecipeRepository: RecipeRepository {
    private var recipes: [Recipe] = [
        Recipe(
            id: "r-1",
            title: "Traditional Italian Carbonara",
            author: "Chef Giovanni",
            imageUrl: "https://images.unsplash.com/photo-1612874742237-6526221588e3?q=80&w=800",
            description: "A classic Roman pasta dish made with eggs, hard cheese, cured pork, and black pepper.",
            ingredients: [
                Ingredient(name: "Spaghetti", amount: "200g", price: 2.50, vendorId: "v-8"),
                Ingredient(name: "Pecorino Romano", amount: "50g", price: 4.00, vendorId: "v-8"),
                Ingredient(name: "Guanciale", amount: "100g", price: 6.00, vendorId: "v-3")
            ],
            instructions: ["Boil pasta", "Fry guanciale", "Whisk eggs and cheese", "Combine everything"],
            likes: 450,
            isLikedByMe: false,
            comments: []
        ),
        Recipe(
            id: "r-2",
            title: "Spicy Kung Pao Chicken",
            author: "Chef Wei",
            imageUrl: "https://images.unsplash.com/photo-1525755662778-989d0524087e?q=80&w=800",
            description: "A classic Chinese Szechuan dish with chicken, peanuts, and chili peppers.",
            ingredients: [
                Ingredient(name: "Chicken Breast", amount: "500g", price: 8.00, vendorId: "v-3"),
                Ingredient(name: "Peanuts", amount: "100g", price: 1.50, vendorId: "v-1"),
                Ingredient(name: "Szechuan Peppercorns", amount: "1 tbsp", price: 2.00, vendorId: "v-1")
            ],
            instructions: ["Marinate chicken", "Stir fry aromatics", "Add chicken and peanuts", "Thicken sauce"],
            likes: 320,
            isLikedByMe: false,
            comments: []
        ),
        Recipe(
            id: "r-3",
            title: "Turkish Adana Kebab",
            author: "Chef Selim",
            imageUrl: "https://images.unsplash.com/photo-1555939594-58d7cb561ad1?q=80&w=800",
            description: "Hand-minced meat mixed with chili and grilled on wide iron skewers.",
            ingredients: [
                Ingredient(name: "Lamb Mince", amount: "500g", price: 12.00, vendorId: "v-3"),
                Ingredient(name: "Red Bell Pepper", amount: "1 pc", price: 1.00, vendorId: "v-2"),
                Ingredient(name: "Sumac", amount: "1 tsp", price: 1.50, vendorId: "v-6")
            ],
            instructions: ["Knead meat with spices", "Skewer meat", "Grill over charcoal", "Serve with sumac onions"],
            likes: 580,
            isLikedByMe: true,
            comments: []
        ),
        Recipe(
            id: "r-4",
            title: "Georgian Khachapuri",
            author: "Chef Nino",
            imageUrl: "https://images.unsplash.com/photo-1603048588665-791ca8aea617?q=80&w=800",
            description: "Traditional Georgian cheese-filled bread topped with an egg and butter.",
            ingredients: [
                Ingredient(name: "Suluuni Cheese", amount: "300g", price: 7.00, vendorId: "v-7"),
                Ingredient(name: "All-purpose Flour", amount: "500g", price: 2.00, vendorId: "v-4"),
                Ingredient(name: "Yeast", amount: "1 tsp", price: 0.50, vendorId: "v-4")
            ],
            instructions: ["Make dough", "Fill with cheese", "Bake boat shape", "Add egg at the end"],
            likes: 890,
            isLikedByMe: false,
            comments: []
        ),
        Recipe(
            id: "r-5",
            title: "Mediterranean Mezze Platter",
            author: "Chef Elena",
            imageUrl: "https://images.unsplash.com/photo-1544124499-58912cbddaad?q=80&w=800",
            description: "A variety of small plates including hummus, falafel, and fresh olives.",
            ingredients: [
                Ingredient(name: "Chickpeas", amount: "400g", price: 1.50, vendorId: "v-4"),
                Ingredient(name: "Tahini", amount: "200g", price: 5.00, vendorId: "v-5"),
                Ingredient(name: "Olives", amount: "100g", price: 3.00, vendorId: "v-5")
            ],
            instructions: ["Blend hummus", "Fry falafel", "Arrange platter"],
            likes: 210,
            isLikedByMe: false,
            comments: []
        ),
        Recipe(
            id: "r-6",
            title: "French Beef Bourguignon",
            author: "Chef Jean",
            imageUrl: "https://images.unsplash.com/photo-1534353473418-4cfa6c56fd38?q=80&w=800",
            description: "Slow-cooked beef in red wine with mushrooms and pearl onions.",
            ingredients: [
                Ingredient(name: "Beef Chuck", amount: "1kg", price: 18.00, vendorId: "v-3"),
                Ingredient(name: "Red Wine", amount: "750ml", price: 15.00, vendorId: "v-2"),
                Ingredient(name: "Mushrooms", amount: "200g", price: 3.00, vendorId: "v-2")
            ],
            instructions: ["Sear beef", "Sauté veggies", "Deglaze with wine", "Braise for 3 hours"],
            likes: 670,
            isLikedByMe: true,
            comments: []
        ),
        Recipe(
            id: "r-7",
            title: "Thai Green Curry",
            author: "Chef Malee",
            imageUrl: "https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?q=80&w=800",
            description: "Fragrant and spicy curry with coconut milk and bamboo shoots.",
            ingredients: [
                Ingredient(name: "Green Curry Paste", amount: "3 tbsp", price: 2.00, vendorId: "v-1"),
                Ingredient(name: "Coconut Milk", amount: "400ml", price: 3.00, vendorId: "v-2"),
                Ingredient(name: "Chicken Breast", amount: "500g", price: 8.00, vendorId: "v-3")
            ],
            instructions: ["Fry paste", "Add chicken", "Add coconut milk", "Finish with basil"],
            likes: 430,
            isLikedByMe: false,
            comments: []
        ),
        Recipe(
            id: "r-8",
            title: "Spanish Seafood Paella",
            author: "Chef Carlos",
            imageUrl: "https://images.unsplash.com/photo-1512058564366-18510be2db19?q=80&w=800",
            description: "Traditional rice dish with saffron, seafood, and chorizo.",
            ingredients: [
                Ingredient(name: "Bomba Rice", amount: "300g", price: 4.00, vendorId: "v-4"),
                Ingredient(name: "Saffron", amount: "1 pinch", price: 10.00, vendorId: "v-1"),
                Ingredient(name: "Shrimp", amount: "8 pcs", price: 12.00, vendorId: "v-3")
            ],
            instructions: ["Sauté chorizo", "Add rice and broth", "Arrange seafood", "Cook until crispy bottom"],
            likes: 950,
            isLikedByMe: true,
            comments: []
        ),
        Recipe(
            id: "r-9",
            title: "Japanese Tonkotsu Ramen",
            author: "Chef Kenji",
            imageUrl: "https://images.unsplash.com/photo-1557872245-741f4c666055?q=80&w=800",
            description: "Creamy pork broth with thin noodles and tender chashu.",
            ingredients: [
                Ingredient(name: "Ramen Noodles", amount: "1 bundle", price: 4.00, vendorId: "v-1"),
                Ingredient(name: "Pork Bones", amount: "1kg", price: 5.00, vendorId: "v-3"),
                Ingredient(name: "Soy Sauce", amount: "50ml", price: 2.00, vendorId: "v-2")
            ],
            instructions: ["Boil bones 12h", "Make tare", "Boil noodles", "Assemble bowl"],
            likes: 1200,
            isLikedByMe: false,
            comments: []
        ),
        Recipe(
            id: "r-10",
            title: "Greek Spanakopita",
            author: "Chef Yiannis",
            imageUrl: "https://images.unsplash.com/photo-1512484776495-a09d92e87c3b?q=80&w=800",
            description: "Flaky phyllo pastry filled with spinach and feta cheese.",
            ingredients: [
                Ingredient(name: "Phyllo Dough", amount: "1 pack", price: 5.00, vendorId: "v-4"),
                Ingredient(name: "Spinach", amount: "500g", price: 2.00, vendorId: "v-2"),
                Ingredient(name: "Feta Cheese", amount: "200g", price: 4.50, vendorId: "v-5")
            ],
            instructions: ["Sauté spinach", "Layer phyllo with butter", "Fill and bake"],
            likes: 310,
            isLikedByMe: false,
            comments: []
        ),
        Recipe(
            id: "r-11",
            title: "Indian Butter Chicken",
            author: "Chef Rahul",
            imageUrl: "https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?q=80&w=800",
            description: "Tender chicken in a rich, creamy tomato and butter sauce.",
            ingredients: [
                Ingredient(name: "Chicken Thighs", amount: "500g", price: 10.00, vendorId: "v-3"),
                Ingredient(name: "Garam Masala", amount: "1 tbsp", price: 1.50, vendorId: "v-1"),
                Ingredient(name: "Heavy Cream", amount: "200ml", price: 3.00, vendorId: "v-2")
            ],
            instructions: ["Marinate chicken", "Grill chicken", "Make gravy", "Simmer together"],
            likes: 740,
            isLikedByMe: true,
            comments: []
        ),
        Recipe(
            id: "r-12",
            title: "Mexican Tacos al Pastor",
            author: "Chef Sofia",
            imageUrl: "https://images.unsplash.com/photo-1504674900247-0877df9cc836?q=80&w=800",
            description: "Spit-roasted pork with pineapple and salsa on corn tortillas.",
            ingredients: [
                Ingredient(name: "Pork Shoulder", amount: "500g", price: 12.00, vendorId: "v-3"),
                Ingredient(name: "Pineapple", amount: "1 pc", price: 2.00, vendorId: "v-4"),
                Ingredient(name: "Corn Tortillas", amount: "12 pcs", price: 3.00, vendorId: "v-4")
            ],
            instructions: ["Marinate pork", "Grill with pineapple", "Serve in tortillas"],
            likes: 560,
            isLikedByMe: false,
            comments: []
        ),
        Recipe(
            id: "r-13",
            title: "Vietnamese Pho Bo",
            author: "Chef Anh",
            imageUrl: "https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?q=80&w=800",
            description: "Aromatic beef noodle soup with fresh herbs and bean sprouts.",
            ingredients: [
                Ingredient(name: "Beef Brisket", amount: "500g", price: 15.00, vendorId: "v-3"),
                Ingredient(name: "Rice Noodles", amount: "200g", price: 2.50, vendorId: "v-4"),
                Ingredient(name: "Star Anise", amount: "3 pcs", price: 1.00, vendorId: "v-1")
            ],
            instructions: ["Simmer broth", "Boil noodles", "Top with beef", "Add herbs"],
            likes: 820,
            isLikedByMe: false,
            comments: []
        ),
        Recipe(
            id: "r-14",
            title: "Moroccan Harira Soup",
            author: "Chef Fatima",
            imageUrl: "https://images.unsplash.com/photo-1541518763669-27fef04b14ea?q=80&w=800",
            description: "Traditional tomato-based soup with lentils and chickpeas.",
            ingredients: [
                Ingredient(name: "Lentils", amount: "200g", price: 1.50, vendorId: "v-4"),
                Ingredient(name: "Chickpeas", amount: "200g", price: 1.50, vendorId: "v-4"),
                Ingredient(name: "Tomato Paste", amount: "2 tbsp", price: 1.00, vendorId: "v-2")
            ],
            instructions: ["Sauté aromatics", "Add pulses", "Simmer soup", "Finish with herbs"],
            likes: 190,
            isLikedByMe: false,
            comments: []
        ),
        Recipe(
            id: "r-15",
            title: "Brazilian Pao de Queijo",
            author: "Chef Ricardo",
            imageUrl: "https://images.unsplash.com/photo-1608039829572-78524f79c4c7?q=80&w=800",
            description: "Cheesy bread balls made with tapioca flour.",
            ingredients: [
                Ingredient(name: "Tapioca Flour", amount: "500g", price: 4.00, vendorId: "v-4"),
                Ingredient(name: "Parmesan", amount: "200g", price: 5.00, vendorId: "v-5"),
                Ingredient(name: "Eggs", amount: "2 pcs", price: 1.00, vendorId: "v-2")
            ],
            instructions: ["Mix dough", "Form balls", "Bake until golden"],
            likes: 410,
            isLikedByMe: false,
            comments: []
        ),
        Recipe(
            id: "r-16",
            title: "Middle Eastern Hummus",
            author: "Chef Omar",
            imageUrl: "https://images.unsplash.com/photo-1593001874117-c99c4ed074bc?q=80&w=800",
            description: "Silky smooth chickpea dip with lemon and garlic.",
            ingredients: [
                Ingredient(name: "Chickpeas", amount: "400g", price: 1.50, vendorId: "v-4"),
                Ingredient(name: "Tahini", amount: "100g", price: 3.00, vendorId: "v-1"),
                Ingredient(name: "Lemon", amount: "1 pc", price: 0.50, vendorId: "v-2")
            ],
            instructions: ["Boil chickpeas", "Process with tahini", "Add lemon and garlic"],
            likes: 280,
            isLikedByMe: false,
            comments: []
        ),
        Recipe(
            id: "r-17",
            title: "Ethiopian Doro Wat",
            author: "Chef Abeba",
            imageUrl: "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=800",
            description: "Spicy chicken stew with berbere spice and boiled eggs.",
            ingredients: [
                Ingredient(name: "Chicken Drumsticks", amount: "6 pcs", price: 8.00, vendorId: "v-3"),
                Ingredient(name: "Berbere Spice", amount: "2 tbsp", price: 2.00, vendorId: "v-1"),
                Ingredient(name: "Eggs", amount: "4 pcs", price: 2.00, vendorId: "v-2")
            ],
            instructions: ["Cook onions long time", "Add spices", "Simmer chicken", "Add eggs"],
            likes: 340,
            isLikedByMe: false,
            comments: []
        ),
        Recipe(
            id: "r-18",
            title: "Russian Beef Stroganoff",
            author: "Chef Dimitri",
            imageUrl: "https://images.unsplash.com/photo-1534353473418-4cfa6c56fd38?q=80&w=800",
            description: "Beef strips in a rich sour cream and mushroom sauce.",
            ingredients: [
                Ingredient(name: "Beef Sirloin", amount: "500g", price: 18.00, vendorId: "v-3"),
                Ingredient(name: "Sour Cream", amount: "200ml", price: 2.50, vendorId: "v-2"),
                Ingredient(name: "Mushrooms", amount: "200g", price: 3.00, vendorId: "v-2")
            ],
            instructions: ["Sear beef", "Cook mushrooms", "Combine with cream", "Serve over noodles"],
            likes: 490,
            isLikedByMe: false,
            comments: []
        ),
        Recipe(
            id: "r-19",
            title: "Lebanese Fattoush Salad",
            author: "Chef Layla",
            imageUrl: "https://images.unsplash.com/photo-1540420773420-3366772f4999?q=80&w=800",
            description: "Fresh vegetable salad with toasted pita and sumac dressing.",
            ingredients: [
                Ingredient(name: "Pita Bread", amount: "2 pcs", price: 1.00, vendorId: "v-4"),
                Ingredient(name: "Sumac", amount: "1 tsp", price: 1.50, vendorId: "v-6"),
                Ingredient(name: "Cucumber", amount: "1 pc", price: 0.80, vendorId: "v-2")
            ],
            instructions: ["Toast pita", "Chop veggies", "Mix dressing", "Toss together"],
            likes: 150,
            isLikedByMe: false,
            comments: []
        ),
        Recipe(
            id: "r-20",
            title: "Japanese Sushi Rolls",
            author: "Chef Yuki",
            imageUrl: "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?q=80&w=800",
            description: "Vinegared rice rolls with fresh tuna and avocado.",
            ingredients: [
                Ingredient(name: "Sushi Rice", amount: "500g", price: 5.00, vendorId: "v-4"),
                Ingredient(name: "Nori", amount: "10 sheets", price: 3.50, vendorId: "v-4"),
                Ingredient(name: "Sashimi Tuna", amount: "200g", price: 15.00, vendorId: "v-3")
            ],
            instructions: ["Cook rice", "Slice fish", "Roll with nori", "Slice into pieces"],
            likes: 1100,
            isLikedByMe: false,
            comments: []
        )
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
