import Foundation

class MockRecipeRepository: RecipeRepository {
    private var recipes: [Recipe] = [
        // Muthaiga - Swahili
        Recipe(id: "r-1", title: "Traditional Beef Pilau", author: "Chef Mama Juma", vendorId: "v-1", imageUrls: [
            "https://images.unsplash.com/photo-1596040033229-a9821ebd058d?q=80&w=800"
        ], description: "Fragrant Swahili rice cooked with tender beef and warm spices.", ingredients: [], instructions: ["Boil beef", "Fry onions until dark", "Add masala", "Cook rice"], likes: 120, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-31", title: "Swahili Goat Soup", author: "Chef Mama Juma", vendorId: "v-1", imageUrls: [
            "https://images.unsplash.com/photo-1547592166-23ac45744acd?q=80&w=800"
        ], description: "Rich, slow-simmered bone broth with tender goat meat and indigenous herbs.", ingredients: [], instructions: ["Simmer goat bones", "Add local herbs", "Slow cook 4 hours"], likes: 85, isLikedByMe: false, comments: []),

        // Westlands - Italian
        Recipe(id: "r-2", title: "Classic Beef Lasagna", author: "Chef Giovanni", vendorId: "v-2", imageUrls: [
            "https://images.unsplash.com/photo-1551183053-bf91a1d81141?q=80&w=800"
        ], description: "Rich meat sauce and creamy béchamel layered with pasta.", ingredients: [], instructions: ["Make ragu", "Make béchamel", "Layer", "Bake"], likes: 340, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-32", title: "Classic Minestrone", author: "Chef Giovanni", vendorId: "v-2", imageUrls: [
            "https://images.unsplash.com/photo-1603105037880-880cd4edfb0d?q=80&w=800"
        ], description: "Hearty vegetable soup with pasta and beans, topped with parmesan.", ingredients: [], instructions: ["Sauté aromatics", "Add seasonal veggies", "Simmer with ditalini"], likes: 150, isLikedByMe: false, comments: []),

        // Karen - Chinese
        Recipe(id: "r-3", title: "Spicy Kung Pao Chicken", author: "Chef Wei", vendorId: "v-3", imageUrls: [
            "https://images.unsplash.com/photo-1525755662778-989d0524087e?q=80&w=800"
        ], description: "Szechuan classic with peanuts and chili peppers.", ingredients: [], instructions: ["Marinate", "Stir fry chicken", "Add peanuts", "Sauce"], likes: 210, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-33", title: "Hot & Sour Soup", author: "Chef Wei", vendorId: "v-3", imageUrls: [
            "https://images.unsplash.com/photo-1541944743827-e04bb64aa79b?q=80&w=800"
        ], description: "Classic Szechuan soup with tofu, mushrooms, and a spicy kick.", ingredients: [], instructions: ["Prep broth", "Add wood ear mushrooms", "Balance vinegar and pepper"], likes: 110, isLikedByMe: false, comments: []),

        // Runda - Turkish
        Recipe(id: "r-4", title: "Turkish Adana Kebab", author: "Chef Selim", vendorId: "v-4", imageUrls: [
            "https://images.unsplash.com/photo-1555939594-58d7cb561ad1?q=80&w=800"
        ], description: "Hand-minced meat mixed with chili and grilled.", ingredients: [], instructions: ["Mince meat", "Season", "Skewer", "Grill"], likes: 450, isLikedByMe: true, comments: []),
        
        Recipe(id: "r-34", title: "Mercimek Corbasi", author: "Chef Selim", vendorId: "v-4", imageUrls: [
            "https://images.unsplash.com/photo-1547592115-f99998b94df2?q=80&w=800"
        ], description: "Traditional Turkish red lentil soup served with lemon and pul biber.", ingredients: [], instructions: ["Sauté onions", "Cook red lentils", "Blend and season"], likes: 195, isLikedByMe: false, comments: []),

        // Lavington - Greek
        Recipe(id: "r-5", title: "Greek Spanakopita", author: "Chef Yiannis", vendorId: "v-5", imageUrls: [
            "https://images.unsplash.com/photo-1512484776495-a09d92e87c3b?q=80&w=800"
        ], description: "Flaky phyllo pastry filled with spinach and feta.", ingredients: [], instructions: ["Prep spinach", "Layer phyllo", "Fill", "Bake"], likes: 180, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-35", title: "Avgolemono", author: "Chef Yiannis", vendorId: "v-5", imageUrls: [
            "https://images.unsplash.com/photo-1604329760661-e71dc83f8f26?q=80&w=800"
        ], description: "Creamy lemon-egg chicken soup with rice, a Greek comfort classic.", ingredients: [], instructions: ["Boil chicken", "Whip eggs and lemon", "Temper into broth"], likes: 230, isLikedByMe: false, comments: []),

        // Westlands - Japanese
        Recipe(id: "r-6", title: "Salmon Sushi Rolls", author: "Chef Hiro", vendorId: "v-6", imageUrls: [
            "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?q=80&w=800"
        ], description: "Fresh salmon and cucumber in premium sushi rice.", ingredients: [], instructions: ["Prep rice", "Slice salmon", "Roll", "Slice"], likes: 520, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-36", title: "Miso Soup Special", author: "Chef Hiro", vendorId: "v-6", imageUrls: [
            "https://images.unsplash.com/photo-1547592166-23ac45744acd?q=80&w=800"
        ], description: "Authentic dashi broth with white miso, silken tofu, and wakame.", ingredients: [], instructions: ["Prepare dashi", "Dissolve miso", "Add tofu and seaweed"], likes: 310, isLikedByMe: false, comments: []),

        // Muthaiga - Georgian
        Recipe(id: "r-7", title: "Georgian Khachapuri", author: "Chef Nino", vendorId: "v-7", imageUrls: [
            "https://images.unsplash.com/photo-1603048588665-791ca8aea617?q=80&w=800"
        ], description: "Cheese-filled bread topped with an egg and butter.", ingredients: [], instructions: ["Make dough", "Shape boat", "Add cheese", "Bake"], likes: 890, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-37", title: "Kharcho Beef Soup", author: "Chef Nino", vendorId: "v-7", imageUrls: [
            "https://images.unsplash.com/photo-1547592166-23ac45744acd?q=80&w=800"
        ], description: "Spicy Georgian beef soup with rice and walnuts.", ingredients: [], instructions: ["Sear beef", "Add walnut paste", "Simmer with tklapi"], likes: 145, isLikedByMe: false, comments: []),

        // Karen - Ethiopian
        Recipe(id: "r-8", title: "Habesha Injera Platter", author: "Chef Abeba", vendorId: "v-8", imageUrls: [
            "https://images.unsplash.com/photo-1548946522-4a313e8972a4?q=80&w=800"
        ], description: "Traditional fermented flatbread with various stews.", ingredients: [], instructions: ["Ferment teff", "Cook injera", "Prepare wats", "Assemble"], likes: 310, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-38", title: "Spiced Lentil Soup", author: "Chef Abeba", vendorId: "v-8", imageUrls: [
            "https://images.unsplash.com/photo-1547592115-f99998b94df2?q=80&w=800"
        ], description: "Ethiopian red lentil soup flavored with berbere spices.", ingredients: [], instructions: ["Sauté with berbere", "Add red lentils", "Simmer until creamy"], likes: 165, isLikedByMe: false, comments: []),

        // Runda - Mexican
        Recipe(id: "r-9", title: "Mexican Street Tacos", author: "Chef Sofia", vendorId: "v-9", imageUrls: [
            "https://images.unsplash.com/photo-1565299585323-38d6b0865b47?q=80&w=800"
        ], description: "Authentic corn tortillas with seasoned meats and salsa.", ingredients: [], instructions: ["Grill meat", "Warm tortillas", "Add toppings", "Squeeze lime"], likes: 640, isLikedByMe: true, comments: []),
        
        Recipe(id: "r-39", title: "Sopa de Tortilla", author: "Chef Sofia", vendorId: "v-9", imageUrls: [
            "https://images.unsplash.com/photo-1512058564366-18510be2db19?q=80&w=800"
        ], description: "Crispy tortilla strips in a rich tomato-guajillo broth.", ingredients: [], instructions: ["Char tomatoes", "Fry tortilla strips", "Add avocado and lime"], likes: 280, isLikedByMe: false, comments: []),

        // Lavington - Indian
        Recipe(id: "r-10", title: "Indian Butter Chicken", author: "Chef Rahul", vendorId: "v-10", imageUrls: [
            "https://images.unsplash.com/photo-1585937421612-70a008356fbe?q=80&w=800"
        ], description: "Tender chicken in rich tomato-butter gravy.", ingredients: [], instructions: ["Marinate", "Tandoor chicken", "Simmer sauce", "Add cream"], likes: 720, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-40", title: "Mulligatawny Soup", author: "Chef Rahul", vendorId: "v-10", imageUrls: [
            "https://images.unsplash.com/photo-1547592166-23ac45744acd?q=80&w=800"
        ], description: "Curry-flavored lentil soup with apple and coconut milk.", ingredients: [], instructions: ["Toast curry spices", "Simmer lentils", "Add coconut milk"], likes: 190, isLikedByMe: false, comments: []),

        // Westlands - French
        Recipe(id: "r-11", title: "French Steak Frites", author: "Chef Jean", vendorId: "v-11", imageUrls: [
            "https://images.unsplash.com/photo-1550966841-3ee20412e23e?q=80&w=800"
        ], description: "Classic bistro steak served with golden fries.", ingredients: [], instructions: ["Sear steak", "Fry potatoes", "Make herb butter", "Rest steak"], likes: 410, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-41", title: "French Onion Soup", author: "Chef Jean", vendorId: "v-11", imageUrls: [
            "https://images.unsplash.com/photo-1512058564366-18510be2db19?q=80&w=800"
        ], description: "Caramelized onions in rich beef broth, topped with gruyère.", ingredients: [], instructions: ["Caramelize onions", "Deglaze with wine", "Broil with cheese"], likes: 560, isLikedByMe: false, comments: []),

        // Muthaiga - Vietnamese
        Recipe(id: "r-12", title: "Vietnamese Beef Pho", author: "Chef Anh", vendorId: "v-12", imageUrls: [
            "https://images.unsplash.com/photo-1583032353423-04fd96ef2211?q=80&w=800"
        ], description: "Fragrant noodle soup with 24-hour beef broth.", ingredients: [], instructions: ["Simmer broth", "Boil noodles", "Thinly slice beef", "Garnish"], likes: 580, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-42", title: "Beef Pho Broth", author: "Chef Anh", vendorId: "v-12", imageUrls: [
            "https://images.unsplash.com/photo-1583032353423-04fd96ef2211?q=80&w=800"
        ], description: "The soul of Vietnamese cuisine - a pure, aromatic beef broth.", ingredients: [], instructions: ["Char ginger and onion", "Simmer bones", "Strain and season"], likes: 215, isLikedByMe: false, comments: []),

        // Karen - Moroccan
        Recipe(id: "r-13", title: "Moroccan Lamb Tagine", author: "Chef Fatima", vendorId: "v-13", imageUrls: [
            "https://images.unsplash.com/photo-1539755530861-84426be99ca0?q=80&w=800"
        ], description: "Slow-cooked lamb with apricots and exotic spices.", ingredients: [], instructions: ["Sear lamb", "Add spices", "Slow cook", "Add dried fruit"], likes: 250, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-43", title: "Harira Traditional", author: "Chef Fatima", vendorId: "v-13", imageUrls: [
            "https://images.unsplash.com/photo-1547592115-f99998b94df2?q=80&w=800"
        ], description: "Tomato-based soup with lentils, chickpeas, and fresh herbs.", ingredients: [], instructions: ["Sauté onions", "Add lentils and chickpeas", "Simmer with coriander"], likes: 175, isLikedByMe: false, comments: []),

        // Runda - Brazilian
        Recipe(id: "r-14", title: "Brazilian Picanha Steak", author: "Chef Ricardo", vendorId: "v-14", imageUrls: [
            "https://images.unsplash.com/photo-1547496502-affa22d38842?q=80&w=800"
        ], description: "Traditional churrasco-style grilled cap of sirloin.", ingredients: [], instructions: ["Score fat", "Salt heavily", "Grill high heat", "Slice thin"], likes: 430, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-44", title: "Caldo de Feijão", author: "Chef Ricardo", vendorId: "v-14", imageUrls: [
            "https://images.unsplash.com/photo-1547592115-f99998b94df2?q=80&w=800"
        ], description: "Rich, creamy black bean soup with bacon and garlic.", ingredients: [], instructions: ["Boil beans", "Blend into cream", "Add crispy bacon"], likes: 130, isLikedByMe: false, comments: []),

        // Lavington - Lebanese
        Recipe(id: "r-15", title: "Lebanese Falafel Wrap", author: "Chef Omar", vendorId: "v-15", imageUrls: [
            "https://images.unsplash.com/photo-1541544741938-0af808871cc0?q=80&w=800"
        ], description: "Crispy chickpea fritters with tahini and fresh veggies.", ingredients: [], instructions: ["Grind chickpeas", "Fry falafel", "Spread hummus", "Wrap tightly"], likes: 190, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-45", title: "Lentil Soup (Shorbat Adas)", author: "Chef Omar", vendorId: "v-15", imageUrls: [
            "https://images.unsplash.com/photo-1547592115-f99998b94df2?q=80&w=800"
        ], description: "Yellow lentil soup with cumin and crispy pita chips.", ingredients: [], instructions: ["Simmer yellow lentils", "Add cumin and turmeric", "Serve with lemon"], likes: 210, isLikedByMe: false, comments: []),

        // Westlands - Russian
        Recipe(id: "r-16", title: "Russian Beef Stroganoff", author: "Chef Dimitri", vendorId: "v-16", imageUrls: [
            "https://images.unsplash.com/photo-1574630758414-996417532a39?q=80&w=800"
        ], description: "Tender beef in sour cream and mushroom sauce.", ingredients: [], instructions: ["Sauté beef", "Add mushrooms", "Stir in cream", "Serve over pasta"], likes: 280, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-46", title: "Traditional Borscht", author: "Chef Dimitri", vendorId: "v-16", imageUrls: [
            "https://images.unsplash.com/photo-1512058564366-18510be2db19?q=80&w=800"
        ], description: "Classic beet soup with cabbage and beef, served with smetana.", ingredients: [], instructions: ["Grate beets", "Sauté with vinegar", "Simmer with beef"], likes: 320, isLikedByMe: false, comments: []),

        // Muthaiga - Thai
        Recipe(id: "r-17", title: "Thai Pad Thai", author: "Chef Malee", vendorId: "v-17", imageUrls: [
            "https://images.unsplash.com/photo-1559339352-11d035aa65de?q=80&w=800"
        ], description: "Stir-fried rice noodles with shrimp, tofu, and peanuts.", ingredients: [], instructions: ["Soak noodles", "Stir fry", "Add tamarind", "Toss peanuts"], likes: 810, isLikedByMe: true, comments: []),
        
        Recipe(id: "r-47", title: "Tom Yum Goong", author: "Chef Malee", vendorId: "v-17", imageUrls: [
            "https://images.unsplash.com/photo-1559339352-11d035aa65de?q=80&w=800"
        ], description: "Hot and sour shrimp soup with lemongrass and galangal.", ingredients: [], instructions: ["Boil aromatics", "Add shrimp and mushrooms", "Balance with lime and chili"], likes: 450, isLikedByMe: false, comments: []),

        // Karen - Spanish
        Recipe(id: "r-18", title: "Spanish Patatas Bravas", author: "Chef Carlos", vendorId: "v-18", imageUrls: [
            "https://images.unsplash.com/photo-1515443961218-a5136d888be7?q=80&w=800"
        ], description: "Crispy fried potatoes with spicy tomato sauce.", ingredients: [], instructions: ["Cube potatoes", "Double fry", "Make salsa brava", "Drizzle aioli"], likes: 370, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-48", title: "Gazpacho Andaluz", author: "Chef Carlos", vendorId: "v-18", imageUrls: [
            "https://images.unsplash.com/photo-1547592115-f99998b94df2?q=80&w=800"
        ], description: "Refreshing cold tomato and vegetable soup from Andalusia.", ingredients: [], instructions: ["Blend raw veggies", "Emulsify with olive oil", "Chill and strain"], likes: 215, isLikedByMe: false, comments: []),

        // Runda - Korean
        Recipe(id: "r-19", title: "Korean Bibimbap", author: "Chef Sun-Hi", vendorId: "v-19", imageUrls: [
            "https://images.unsplash.com/photo-1498654896293-37aacf113fd9?q=80&w=800"
        ], description: "Mixed rice bowl with vegetables, beef, and egg.", ingredients: [], instructions: ["Steam rice", "Sauté veggies", "Fry egg", "Mix with gochujang"], likes: 540, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-49", title: "Kimchi Jjigae", author: "Chef Sun-Hi", vendorId: "v-19", imageUrls: [
            "https://images.unsplash.com/photo-1498654896293-37aacf113fd9?q=80&w=800"
        ], description: "Spicy Korean stew made with aged kimchi and tofu.", ingredients: [], instructions: ["Sauté kimchi", "Add pork and tofu", "Simmer until rich"], likes: 380, isLikedByMe: false, comments: []),

        // Lavington - Korean BBQ
        Recipe(id: "r-20", title: "Korean Bulgogi BBQ", author: "Chef Ji-Won", vendorId: "v-20", imageUrls: [
            "https://images.unsplash.com/photo-1529193591184-b1d58069ecdd?q=80&w=800"
        ], description: "Thinly sliced marinated beef grilled to perfection.", ingredients: [], instructions: ["Slice beef", "Marinate in pear", "Grill high heat", "Serve in lettuce"], likes: 620, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-50", title: "Samgyetang", author: "Chef Ji-Won", vendorId: "v-20", imageUrls: [
            "https://images.unsplash.com/photo-1547592166-23ac45744acd?q=80&w=800"
        ], description: "Whole young chicken stuffed with ginseng, garlic, and rice.", ingredients: [], instructions: ["Stuff chicken", "Simmer with ginseng", "Slow cook until tender"], likes: 290, isLikedByMe: false, comments: []),

        // Westlands - Peruvian
        Recipe(id: "r-21", title: "Peruvian Lomo Saltado", author: "Chef Elena", vendorId: "v-21", imageUrls: [
            "https://images.unsplash.com/photo-1504674900247-0877df9cc836?q=80&w=800"
        ], description: "Stir-fried beef with onions, tomatoes, and french fries.", ingredients: [], instructions: ["Sear beef", "Add onions", "Toss in fries", "Serve with rice"], likes: 480, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-51", title: "Chupe de Camarones", author: "Chef Elena", vendorId: "v-21", imageUrls: [
            "https://images.unsplash.com/photo-1512058564366-18510be2db19?q=80&w=800"
        ], description: "Rich shrimp chowder with corn, potatoes, and milk.", ingredients: [], instructions: ["Sear shrimp", "Make chili paste", "Simmer with milk and egg"], likes: 195, isLikedByMe: false, comments: []),

        // Muthaiga - Swiss
        Recipe(id: "r-22", title: "Swiss Cheese Fondue", author: "Chef Hans", vendorId: "v-22", imageUrls: [
            "https://images.unsplash.com/photo-1485962391945-448a60359f6b?q=80&w=800"
        ], description: "Melted Gruyère and Emmental with white wine and garlic.", ingredients: [], instructions: ["Rub garlic", "Heat wine", "Stir in cheese", "Dip bread"], likes: 290, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-52", title: "Swiss Barley Soup", author: "Chef Hans", vendorId: "v-22", imageUrls: [
            "https://images.unsplash.com/photo-1547592166-23ac45744acd?q=80&w=800"
        ], description: "Hearty alpine soup with pearl barley and smoked meat.", ingredients: [], instructions: ["Sauté aromatics", "Cook barley", "Add diced ham"], likes: 140, isLikedByMe: false, comments: []),

        // Karen - Australian
        Recipe(id: "r-23", title: "Australian Grilled Barramundi", author: "Chef Liam", vendorId: "v-23", imageUrls: [
            "https://images.unsplash.com/photo-1551731359-2b3cf8dfd1ce?q=80&w=800"
        ], description: "Fresh local sea bass grilled with lemon and herbs.", ingredients: [], instructions: ["Season fish", "Grill skin down", "Flip gently", "Serve with lemon"], likes: 360, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-53", title: "Seafood Chowder Oz", author: "Chef Liam", vendorId: "v-23", imageUrls: [
            "https://images.unsplash.com/photo-1512058564366-18510be2db19?q=80&w=800"
        ], description: "Creamy coastal chowder with local snapper and mussels.", ingredients: [], instructions: ["Sauté bacon", "Simmer seafood", "Add thick cream"], likes: 210, isLikedByMe: false, comments: []),

        // Runda - Canadian
        Recipe(id: "r-24", title: "Canadian Classic Poutine", author: "Chef Marc", vendorId: "v-24", imageUrls: [
            "https://images.unsplash.com/photo-1586511925558-a4c6376fe65f?q=80&w=800"
        ], description: "Golden fries topped with fresh cheese curds and hot gravy.", ingredients: [], instructions: ["Hand cut fries", "Heat brown gravy", "Top with curds", "Pour gravy"], likes: 510, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-54", title: "Habitant Pea Soup", author: "Chef Marc", vendorId: "v-24", imageUrls: [
            "https://images.unsplash.com/photo-1547592115-f99998b94df2?q=80&w=800"
        ], description: "Traditional yellow split pea soup with ham hock.", ingredients: [], instructions: ["Soak peas", "Simmer with ham", "Mash until thick"], likes: 180, isLikedByMe: false, comments: []),

        // Lavington - Portuguese
        Recipe(id: "r-25", title: "Portuguese Bacalhau", author: "Chef Tiago", vendorId: "v-25", imageUrls: [
            "https://images.unsplash.com/photo-1534080564607-198f9dd5d61a?q=80&w=800"
        ], description: "Traditional salted cod dish with potatoes and olives.", ingredients: [], instructions: ["Soak cod", "Shred fish", "Layer with onions", "Bake with cream"], likes: 220, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-55", title: "Caldo Verde Original", author: "Chef Tiago", vendorId: "v-25", imageUrls: [
            "https://images.unsplash.com/photo-1512058564366-18510be2db19?q=80&w=800"
        ], description: "Potato and kale soup with spicy chouriço sausage.", ingredients: [], instructions: ["Boil potatoes", "Add shredded kale", "Slice chouriço"], likes: 245, isLikedByMe: false, comments: []),

        // Westlands - Danish
        Recipe(id: "r-26", title: "Danish Smørrebrød", author: "Chef Soren", vendorId: "v-26", imageUrls: [
            "https://images.unsplash.com/photo-1559339352-11d035aa65de?q=80&w=800"
        ], description: "Open-faced rye bread sandwich with pickled herring.", ingredients: [], instructions: ["Butter rye bread", "Add herring", "Top with dill", "Add capers"], likes: 180, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-56", title: "Yellow Pea Soup", author: "Chef Soren", vendorId: "v-26", imageUrls: [
            "https://images.unsplash.com/photo-1547592115-f99998b94df2?q=80&w=800"
        ], description: "Danish Gule Ærter with pork and aromatic vegetables.", ingredients: [], instructions: ["Cook peas", "Add root veggies", "Slice pork roast"], likes: 110, isLikedByMe: false, comments: []),

        // Muthaiga - Austrian
        Recipe(id: "r-27", title: "Austrian Sachertorte", author: "Chef Franz", vendorId: "v-27", imageUrls: [
            "https://images.unsplash.com/photo-1488477181946-6428a0291777?q=80&w=800"
        ], description: "Dense chocolate cake with a thin layer of apricot jam.", ingredients: [], instructions: ["Bake sponge", "Slice and jam", "Glaze chocolate", "Serve with cream"], likes: 670, isLikedByMe: true, comments: []),
        
        Recipe(id: "r-57", title: "Goulash Soup", author: "Chef Franz", vendorId: "v-27", imageUrls: [
            "https://images.unsplash.com/photo-1547592166-23ac45744acd?q=80&w=800"
        ], description: "Hearty Austrian beef and paprika soup.", ingredients: [], instructions: ["Sauté onions", "Add paprika and beef", "Slow cook until tender"], likes: 295, isLikedByMe: false, comments: []),

        // Karen - Jamaican
        Recipe(id: "r-28", title: "Jamaican Jerk Chicken", author: "Chef Kingsley", vendorId: "v-28", imageUrls: [
            "https://images.unsplash.com/photo-1533777857419-d2d305d7b578?q=80&w=800"
        ], description: "Spicy and smoky chicken marinated in scotch bonnet peppers.", ingredients: [], instructions: ["Rub with spice", "Marinate 24h", "Smoke over wood", "Chop and serve"], likes: 490, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-58", title: "Red Peas Soup", author: "Chef Kingsley", vendorId: "v-28", imageUrls: [
            "https://images.unsplash.com/photo-1547592115-f99998b94df2?q=80&w=800"
        ], description: "Rich kidney bean soup with coconut milk and flour dumplings.", ingredients: [], instructions: ["Boil peas", "Make spinners", "Add coconut milk"], likes: 185, isLikedByMe: false, comments: []),

        // Runda - Indonesian
        Recipe(id: "r-29", title: "Indonesian Nasi Goreng", author: "Chef Putu", vendorId: "v-29", imageUrls: [
            "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=800"
        ], description: "Spiced fried rice with sweet soy sauce and fried egg.", ingredients: [], instructions: ["Sauté paste", "Add day-old rice", "Add kecap manis", "Top with egg"], likes: 450, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-59", title: "Soto Ayam", author: "Chef Putu", vendorId: "v-29", imageUrls: [
            "https://images.unsplash.com/photo-1547592166-23ac45744acd?q=80&w=800"
        ], description: "Turmeric-infused chicken soup with glass noodles and lime.", ingredients: [], instructions: ["Make turmeric spice", "Boil chicken", "Add noodles and egg"], likes: 210, isLikedByMe: false, comments: []),

        // Lavington - Egyptian
        Recipe(id: "r-30", title: "Egyptian Koshary", author: "Chef Mahmoud", vendorId: "v-30", imageUrls: [
            "https://images.unsplash.com/photo-1567156942642-4f96446e502c?q=80&w=800"
        ], description: "Hearty mix of rice, pasta, lentils, and spicy tomato sauce.", ingredients: [], instructions: ["Boil lentils", "Cook rice", "Make sauce", "Top with onions"], likes: 320, isLikedByMe: false, comments: []),
        
        Recipe(id: "r-60", title: "Molokhia Traditional", author: "Chef Mahmoud", vendorId: "v-30", imageUrls: [
            "https://images.unsplash.com/photo-1512058564366-18510be2db19?q=80&w=800"
        ], description: "Minced jute mallow leaves cooked in aromatic garlic broth.", ingredients: [], instructions: ["Make tasha", "Cook molokhia leaves", "Simmer broth"], likes: 340, isLikedByMe: false, comments: [])
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
