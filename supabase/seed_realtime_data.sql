-- =============================================================
-- Jikoni Production Seed: Realtime Profiles & Restaurants
-- =============================================================

-- 1. Realtime Test Profiles
INSERT INTO profiles (
  id, display_name, phone_number, profile_bio, skill_level,
  dietary_goals, loyalty_points, membership_tier, favorite_cuisines,
  followers_count, following_count, recipes_count, average_rating
) VALUES
  (
    '17dde0f7-1d1f-452c-9c08-a098bd88fc97'::uuid,
    'Amani Mwangi',
    '+254 700 123 456',
    'Executive Chef & Culinary Curator at Jikoni Nairobi. Exploring Coastal Swahili traditions and contemporary East African street gastronomy.',
    'Executive Chef',
    ARRAY['Healthy', 'Organic', 'Swahili Special'],
    1250,
    'gold',
    ARRAY['Swahili', 'Italian', 'Ethiopian'],
    1540,
    320,
    24,
    4.9
  ),
  (
    '2a6b8b03-b779-4112-93e1-3741ab3f2756'::uuid,
    'Wambui Kamau',
    '+254 711 987 654',
    'Home cook, food explorer, and Sunday dinner enthusiast in Kilimani. Obsessed with hearty stews, fresh vegetables, and quick weeknight meals.',
    'Home Cook',
    ARRAY['Quick Meals', 'Plant-based'],
    450,
    'silver',
    ARRAY['Kenyan', 'Quick Meals', 'Coastal'],
    340,
    180,
    8,
    4.8
  )
ON CONFLICT (id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  phone_number = EXCLUDED.phone_number,
  profile_bio = EXCLUDED.profile_bio,
  skill_level = EXCLUDED.skill_level,
  dietary_goals = EXCLUDED.dietary_goals,
  loyalty_points = EXCLUDED.loyalty_points,
  membership_tier = EXCLUDED.membership_tier,
  favorite_cuisines = EXCLUDED.favorite_cuisines;

-- Addresses for test users
DELETE FROM addresses WHERE user_id IN ('17dde0f7-1d1f-452c-9c08-a098bd88fc97'::uuid, '2a6b8b03-b779-4112-93e1-3741ab3f2756'::uuid);

INSERT INTO addresses (user_id, label, line1, line2, city, delivery_notes, is_default) VALUES
  ('17dde0f7-1d1f-452c-9c08-a098bd88fc97'::uuid, 'Home', '123 Chef Street', 'Lavington', 'Nairobi', 'Call when at the gate', true),
  ('17dde0f7-1d1f-452c-9c08-a098bd88fc97'::uuid, 'Kitchen HQ', 'Jikoni Kitchens HQ', 'Westlands', 'Nairobi', 'Deliver at reception', false),
  ('2a6b8b03-b779-4112-93e1-3741ab3f2756'::uuid, 'Home', '45 Acacia Grove', 'Kilimani', 'Nairobi', 'Leave at apartment reception 4B', true);

-- Payment methods for test users
DELETE FROM payment_methods WHERE user_id IN ('17dde0f7-1d1f-452c-9c08-a098bd88fc97'::uuid, '2a6b8b03-b779-4112-93e1-3741ab3f2756'::uuid);

INSERT INTO payment_methods (user_id, brand, last_four, expiry, holder_name, is_default) VALUES
  ('17dde0f7-1d1f-452c-9c08-a098bd88fc97'::uuid, 'Visa', '1234', '12/27', 'Amani Mwangi', true),
  ('17dde0f7-1d1f-452c-9c08-a098bd88fc97'::uuid, 'Mastercard', '9876', '08/26', 'Amani Mwangi', false),
  ('2a6b8b03-b779-4112-93e1-3741ab3f2756'::uuid, 'Mastercard', '5432', '05/28', 'Wambui Kamau', true);

-- =============================================================
-- 2. 12 Realtime Restaurants with 5+ Meals Each
-- =============================================================

-- Clear existing demo vendor data to insert clean catalog
DELETE FROM menu_items WHERE vendor_id LIKE 'v-%';
DELETE FROM vendors WHERE id LIKE 'v-%';

INSERT INTO vendors (
  id, name, cuisine, image_urls, delivery_fee, rating,
  latitude, longitude, review_count, estimated_delivery_minutes,
  minimum_order, phone_number, hygiene_rating, opening_hours,
  is_open_now, price_range, dietary_tags, is_featured
) VALUES
  (
    'v-1', 'Mama Juma''s African Kitchen', 'Swahili & Coastal',
    ARRAY['https://images.unsplash.com/photo-1596040033229-a9821ebd058d?q=80&w=800'],
    120.0, 4.9, -1.2524, 36.8223, 184, 25, 500, '+254701234567', 'A', '08:00 - 22:00', true, '$$',
    ARRAY['Swahili', 'Halal', 'Organic'], true
  ),
  (
    'v-2', 'La Trattoria Italiana', 'Italian & Artisan Pasta',
    ARRAY['https://images.unsplash.com/photo-1551183053-bf91a1d81141?q=80&w=800'],
    210.0, 4.8, -1.2619, 36.8049, 142, 35, 750, '+254712345678', 'A', '11:00 - 23:00', true, '$$$',
    ARRAY['Vegetarian', 'Pasta', 'Artisan'], true
  ),
  (
    'v-3', 'Great Wall Chinese', 'Sichuan & Cantonese',
    ARRAY['https://images.unsplash.com/photo-1525755662778-989d0524087e?q=80&w=800'],
    240.0, 4.7, -1.3196, 36.7065, 98, 40, 600, '+254723456789', 'A', '11:30 - 22:30', true, '$$',
    ARRAY['Spicy', 'Dim Sum', 'Seafood'], false
  ),
  (
    'v-4', 'Istanbul Grill & Kebab House', 'Turkish & Mediterranean',
    ARRAY['https://images.unsplash.com/photo-1555939594-58d7cb561ad1?q=80&w=800'],
    150.0, 4.8, -1.2224, 36.8123, 115, 30, 650, '+254734567890', 'A', '10:00 - 23:00', true, '$$',
    ARRAY['Halal', 'Charcoal Grill', 'Kebab'], true
  ),
  (
    'v-5', 'Aegean Greek Taverna', 'Greek & Souvlaki',
    ARRAY['https://images.unsplash.com/photo-1540420773420-3366772f4999?q=80&w=800'],
    180.0, 4.6, -1.2724, 36.7723, 87, 30, 550, '+254745678901', 'A', '11:00 - 22:00', true, '$$',
    ARRAY['Mediterranean', 'Seafood', 'Healthy'], false
  ),
  (
    'v-6', 'Tokyo Sushi Zen', 'Japanese & Robata',
    ARRAY['https://images.unsplash.com/photo-1579871494447-9811cf80d66c?q=80&w=800'],
    220.0, 4.9, -1.2655, 36.7988, 210, 35, 800, '+254756789012', 'A', '12:00 - 22:30', true, '$$$',
    ARRAY['Sushi', 'Japanese', 'Premium'], true
  ),
  (
    'v-7', 'Habesha Authentic Ethiopian', 'Ethiopian Traditional',
    ARRAY['https://images.unsplash.com/photo-1541518763669-27fef04b14ea?q=80&w=800'],
    130.0, 4.9, -1.2895, 36.7828, 260, 25, 500, '+254767890123', 'A', '09:00 - 23:00', true, '$$',
    ARRAY['Injera', 'Spicy', 'Vegan Friendly'], true
  ),
  (
    'v-8', 'El Taco Loco Taqueria', 'Mexican Street Food',
    ARRAY['https://images.unsplash.com/photo-1565299585323-38d6b0865b47?q=80&w=800'],
    160.0, 4.7, -1.2688, 36.8115, 134, 30, 450, '+254778901234', 'A', '11:00 - 23:00', true, '$$',
    ARRAY['Tacos', 'Spicy', 'Quick Meals'], false
  ),
  (
    'v-9', 'Curry House Nairobi', 'North Indian & Mughlai',
    ARRAY['https://images.unsplash.com/photo-1585937421612-70a008356fbe?q=80&w=800'],
    140.0, 4.8, -1.2605, 36.8242, 175, 30, 500, '+254789012345', 'A', '11:00 - 22:30', true, '$$',
    ARRAY['Curry', 'Biryani', 'Vegetarian Friendly'], true
  ),
  (
    'v-10', 'Bangkok Street Thai', 'Authentic Thai Cuisine',
    ARRAY['https://images.unsplash.com/photo-1559314809-0d155014e29e?q=80&w=800'],
    190.0, 4.7, -1.2580, 36.7910, 119, 35, 600, '+254790123456', 'A', '11:30 - 22:00', true, '$$',
    ARRAY['Thai', 'Noodles', 'Spicy'], false
  ),
  (
    'v-11', 'Carnivore Smokehouse', 'Kenyan BBQ & Nyama Choma',
    ARRAY['https://images.unsplash.com/photo-1544025162-d76694265947?q=80&w=800'],
    180.0, 4.9, -1.3324, 36.7923, 310, 35, 700, '+254701998877', 'A', '11:00 - 23:00', true, '$$$',
    ARRAY['Nyama Choma', 'BBQ', 'Local Special'], true
  ),
  (
    'v-12', 'Marrakech Tagine & Grill', 'Moroccan & North African',
    ARRAY['https://images.unsplash.com/photo-1541518763669-27fef04b14ea?q=80&w=800'],
    170.0, 4.8, -1.2630, 36.7845, 102, 35, 600, '+254712887766', 'A', '11:00 - 22:30', true, '$$',
    ARRAY['Couscous', 'Tagine', 'Halal'], false
  );

-- =============================================================
-- 3. Menu Items: 5+ Meals per Restaurant + Soups + Drinks
-- =============================================================

INSERT INTO menu_items (vendor_id, category, name, amount, price, details, nutritional_notes, dietary_tags) VALUES
  -- v-1 Mama Juma's African Kitchen (6 Meals, 2 Soups, 3 Drinks)
  ('v-1', 'Meals', 'Traditional Beef Pilau', '1 portion (450g)', 750.0, 'Fragrant spiced basmati rice slow-cooked with tender prime beef and kachumbari.', 'High protein, rich spices', ARRAY['Halal', 'Signature']),
  ('v-1', 'Meals', 'Swahili Coconut Fish Curry', '1 portion (400g)', 900.0, 'Fresh Red Snapper simmered in freshly squeezed coconut cream and turmeric.', 'Omega-3 rich, dairy free', ARRAY['Coastal', 'Seafood']),
  ('v-1', 'Meals', 'Swahili Grilled Chicken', 'Quarter bird', 850.0, 'Marinated in ginger, garlic, and tamarind glaze, roasted over charcoal.', 'Charcoal roasted', ARRAY['High Protein', 'Halal']),
  ('v-1', 'Meals', 'Zanzibar Vegetable Biryani', '1 portion', 650.0, 'Layered saffron rice with garden vegetables, raisins, and roasted cashews.', 'Plant based delicious', ARRAY['Vegetarian']),
  ('v-1', 'Meals', 'Nyama Choma Special Platter', '500g', 1100.0, 'Slow charcoal grilled goat ribs rested with rock salt and chili dip.', 'Kenyas national dish', ARRAY['Keto', 'Signature']),
  ('v-1', 'Meals', 'Stone-Ground Ugali & Sukuma Wiki', '1 portion', 550.0, 'Warm white cornmeal ugali served with braised collard greens and tomatoes.', 'Hearty traditional comfort', ARRAY['Classic Kenyan']),
  ('v-1', 'Soups', 'Swahili Goat Soup (Supu ya Mbuzi)', 'Bowl (350ml)', 450.0, 'Simmered goat bone broth with peppercorns, ginger, and lime.', 'Traditional vitality broth', ARRAY['Gluten Free']),
  ('v-1', 'Soups', 'Creamy Coconut Pumpkin Soup', 'Bowl (350ml)', 400.0, 'Roasted butternut squash blended with fresh coconut milk.', 'Rich in beta-carotene', ARRAY['Vegan']),
  ('v-1', 'Drinks', 'Signature Dawa Cocktail', '250ml', 500.0, 'Vodka, fresh muddled lime, crushed ice, and organic acacia honey.', 'Nairobi iconic cocktail', ARRAY['Alcoholic']),
  ('v-1', 'Drinks', 'Tamarind Mint Refresher', '350ml', 350.0, 'Chilled wild tamarind infusion with fresh garden mint.', 'Refreshing tart & sweet', ARRAY['Alcohol Free']),
  ('v-1', 'Drinks', 'Kenyan Highland Brew Coffee', 'Cup', 250.0, 'Single-origin washed Arabica from Nyeri highlands.', 'Single origin', ARRAY['Caffeine']),

  -- v-2 La Trattoria Italiana (6 Meals, 2 Soups, 3 Drinks)
  ('v-2', 'Meals', 'Classic Beef Lasagna Bolognese', '1 portion', 1000.0, 'Fresh egg pasta sheets layered with slow-simmered Angus ragù and bechamel.', 'Comfort pasta staple', ARRAY['Artisan']),
  ('v-2', 'Meals', 'Spaghetti Carbonara Tradizionale', '1 portion', 850.0, 'Bronze-cut spaghetti, crispy cured pancetta, pecorino romano, and egg yolk.', 'Authentic Roman style', ARRAY['Classic']),
  ('v-2', 'Meals', 'Wood-Fired Margherita Pizza', '12 inch', 800.0, 'San Marzano tomato sauce, fresh buffalo mozzarella, and sweet basil.', '48hr fermented dough', ARRAY['Vegetarian']),
  ('v-2', 'Meals', 'Wild Mushroom Truffle Risotto', '1 portion', 1150.0, 'Carnaroli rice slow-cooked with porcini stock and white truffle oil.', 'Creamy gourmet risotto', ARRAY['Vegetarian']),
  ('v-2', 'Meals', 'Chicken Parmigiana', '1 portion', 1050.0, 'Breaded chicken breast topped with marinara and melted aged mozzarella.', 'High protein favorite', ARRAY['Meat']),
  ('v-2', 'Meals', 'Slow Braised Osso Buco', '1 portion', 1300.0, 'Tender veal shank braised with vegetables, white wine, and gremolata.', 'Chef signature entrée', ARRAY['Gourmet']),
  ('v-2', 'Soups', 'Classic Minestrone Genovese', 'Bowl', 500.0, 'Seasonal vegetable broth with borlotti beans and basil pesto.', 'Nutrient rich', ARRAY['Vegetarian']),
  ('v-2', 'Soups', 'Roasted Tomato & Basil Bisque', 'Bowl', 450.0, 'Fire-roasted vine tomatoes blended with sweet cream and cracked pepper.', 'Rich & velvety', ARRAY['Vegetarian']),
  ('v-2', 'Drinks', 'Aperol Spritz Veneziano', '200ml', 550.0, 'Aperol, Prosecco DOC, and soda water garnished with fresh orange.', 'Aperitivo classic', ARRAY['Cocktail']),
  ('v-2', 'Drinks', 'Italian Lemon Basil Soda', '330ml', 350.0, 'Sparkling mineral water infused with pressed lemons and sweet basil.', 'Crisp zero-proof', ARRAY['Mocktail']),
  ('v-2', 'Drinks', 'Peroni Nastro Azzurro', '330ml', 400.0, 'Crisp Italian lager brewed with Nostrano dell''Isola maize.', '5.1% ABV', ARRAY['Beer']),

  -- v-3 Great Wall Chinese (6 Meals, 2 Soups, 2 Drinks)
  ('v-3', 'Meals', 'Spicy Kung Pao Chicken', '1 portion', 850.0, 'Wok-tossed chicken with Sichuan peppercorns, dried chilies, and roasted peanuts.', 'Spicy & tingling', ARRAY['Spicy']),
  ('v-3', 'Meals', 'Crispy Peking Duck Spring Rolls', '4 rolls', 950.0, 'Roasted duck wrapped in crisp pastry with hoisin and cucumber dip.', 'Crispy appetizer', ARRAY['Signature']),
  ('v-3', 'Meals', 'Stir-Fried Beef with Broccoli', '1 portion', 900.0, 'Tender beef strips in savory ginger-garlic sauce over steamed broccoli.', 'High iron and protein', ARRAY['Classic']),
  ('v-3', 'Meals', 'Steamed Dim Sum Assortment', '8 pcs', 1100.0, 'Handmade prawn har gow, pork siu mai, and vegetable dumplings.', 'Traditional basket', ARRAY['Dim Sum']),
  ('v-3', 'Meals', 'Sichuan Mapo Tofu', '1 portion', 700.0, 'Silken tofu in fiery fermented bean chili broth with minced beef.', 'Authentic fiery staple', ARRAY['Spicy']),
  ('v-3', 'Meals', 'Yangzhou Wok Fried Rice', '1 portion', 650.0, 'Golden jasmine rice tossed with barbecue pork, baby shrimp, and scallions.', 'Comfort rice bowl', ARRAY['Wok Fried']),
  ('v-3', 'Soups', 'Sichuan Hot & Sour Soup', 'Bowl', 400.0, 'Wood ear mushrooms, bamboo shoots, tofu, and white pepper in dark broth.', 'Spicy and tangy', ARRAY['Spicy']),
  ('v-3', 'Soups', 'Handmade Wonton Broth', 'Bowl', 500.0, 'Delicate pork and shrimp wontons in light sesame chicken broth.', 'Gentle & soothing', ARRAY['Comfort']),
  ('v-3', 'Drinks', 'Lychee Jasmine Iced Tea', '400ml', 350.0, 'Brewed jasmine blossoms sweetened with fresh lychee nectar.', 'Floral cooler', ARRAY['Iced Tea']),
  ('v-3', 'Drinks', 'Tsingtao Premium Lager', '330ml', 350.0, 'Clean lager brewed with spring water from Laoshan Mountain.', '4.7% ABV', ARRAY['Beer']),

  -- v-4 Istanbul Grill & Kebab House (6 Meals, 2 Soups, 2 Drinks)
  ('v-4', 'Meals', 'Turkish Adana Minced Lamb Kebab', '2 skewers', 900.0, 'Hand-chopped lamb hand-kneaded with red peppers and sumac onion salad.', 'Charcoal flame grilled', ARRAY['Halal', 'Signature']),
  ('v-4', 'Meals', 'Marinated Lamb Shish Kebab', '2 skewers', 1000.0, 'Tender cubes of prime lamb marinated in yogurt, oregano, and olive oil.', 'Tender charcoal cubes', ARRAY['Halal']),
  ('v-4', 'Meals', 'Tavuk Shish Chicken Skewers', '2 skewers', 850.0, 'Juicy spiced chicken breast skewers served over buttered bulgur pilaf.', 'High protein', ARRAY['Halal']),
  ('v-4', 'Meals', 'Iskender Kebab with Tomato Brown Butter', '1 portion', 1150.0, 'Thin sliced doner meat over warm pita cubes drenched in browned butter and yogurt.', 'Istanbul specialty', ARRAY['Rich']),
  ('v-4', 'Meals', 'Vegetarian Falafel Hummus Platter', '1 portion', 750.0, 'Crisp chickpea croquettes served with tahini sauce and freshly baked pita.', 'Plant protein loaded', ARRAY['Vegetarian']),
  ('v-4', 'Meals', 'Turkish Pide Flatbread with Cheese & Sujuk', '1 whole', 800.0, 'Boat-shaped dough topped with Turkish beef sausage and melted kasar cheese.', 'Baked fresh to order', ARRAY['Comfort']),
  ('v-4', 'Soups', 'Mercimek Corbasi (Red Lentil)', 'Bowl', 350.0, 'Velvety Turkish red lentil soup finished with paprika sizzling butter.', 'Warm & wholesome', ARRAY['Vegan']),
  ('v-4', 'Soups', 'Tavuk Suyu (Shredded Chicken Soup)', 'Bowl', 400.0, 'Hearty chicken and orzo soup with lemon and black pepper.', 'Soothing broth', ARRAY['Comfort']),
  ('v-4', 'Drinks', 'Traditional Chilled Ayran', '300ml', 250.0, 'Whisked yogurt beverage seasoned with sea salt and dried mint.', 'Probiotic refreshment', ARRAY['Yogurt']),
  ('v-4', 'Drinks', 'Authentic Turkish Cardamom Coffee', 'Cup', 250.0, 'Finely ground beans brewed slowly in a cezve pot with cardamom pods.', 'Intense & aromatic', ARRAY['Coffee']),

  -- v-5 Aegean Greek Taverna (6 Meals, 2 Soups, 2 Drinks)
  ('v-5', 'Meals', 'Traditional Baked Moussaka', '1 portion', 950.0, 'Layers of spiced minced beef, eggplant, potato, and golden bechamel crust.', 'Greek comfort classic', ARRAY['Comfort']),
  ('v-5', 'Meals', 'Pork Souvlaki Kalamaki', '3 skewers', 800.0, 'Flame-grilled pork skewers with tzatziki, tomato, and warm pita wedges.', 'Street food icon', ARRAY['Grilled']),
  ('v-5', 'Meals', 'Charcoal Grilled Sea Bass (Lavraki)', 'Whole fish', 1350.0, 'Fresh Mediterranean sea bass dressed in ladolemono olive oil and wild oregano.', 'Clean lean protein', ARRAY['Seafood']),
  ('v-5', 'Meals', 'Spanakopita Spinach Pie', '2 triangles', 650.0, 'Crispy phyllo dough filled with organic spinach, fresh dill, and Greek feta.', 'Flaky artisan pastry', ARRAY['Vegetarian']),
  ('v-5', 'Meals', 'Slow Roasted Lamb Kleftiko', '1 portion', 1250.0, 'Lamb shoulder baked slowly in parchment paper with garlic, lemon, and potatoes.', 'Falls off the bone', ARRAY['Signature']),
  ('v-5', 'Meals', 'Classic Greek Salad & Halloumi', '1 portion', 700.0, 'Kalamata olives, vine tomatoes, cucumbers, feta block, and grilled halloumi.', 'Rich in polyphenols', ARRAY['Vegetarian']),
  ('v-5', 'Soups', 'Avgolemono Chicken Rice Soup', 'Bowl', 450.0, 'Silky lemon and egg-thickened chicken broth with tender rice.', 'Bright & warming', ARRAY['Comfort']),
  ('v-5', 'Soups', 'Fasolada Greek White Bean Stew', 'Bowl', 400.0, 'Slow cooked cannellini beans with carrots, celery, and extra virgin olive oil.', 'Fiber powerhouse', ARRAY['Vegan']),
  ('v-5', 'Drinks', 'Greek Mountain Herbal Tea', 'Cup', 250.0, 'Hand-picked Sideritis wild herbs from mount Olympus.', 'Antioxidant rich', ARRAY['Herbal']),
  ('v-5', 'Drinks', 'Mythos Premium Greek Beer', '330ml', 400.0, 'Light golden Greek lager with mild malt sweetness.', '4.7% ABV', ARRAY['Beer']),

  -- v-6 Tokyo Sushi Zen (6 Meals, 2 Soups, 2 Drinks)
  ('v-6', 'Meals', 'Salmon & Tuna Nigiri Set', '8 pcs', 1200.0, 'Fresh Atlantic salmon and yellowfin tuna slices over seasoned Akita rice.', 'Omega-3 loaded', ARRAY['Sushi', 'Raw']),
  ('v-6', 'Meals', 'Crunchy Spicy Tuna Maki Roll', '8 pcs', 950.0, 'Yellowfin tuna, spicy kewpie mayo, cucumber, topped with tempura crunch.', 'Spicy & crisp', ARRAY['Sushi']),
  ('v-6', 'Meals', 'Chicken Katsu Curry Bowl', '1 portion', 900.0, 'Crispy panko chicken cutlet served over rice with sweet Japanese curry sauce.', 'Hearty comfort', ARRAY['Comfort']),
  ('v-6', 'Meals', 'Tokyo Shoyu Chashu Ramen', 'Large bowl', 1050.0, 'Handmade noodles in rich chicken and dashi soy broth with pork belly chashu.', 'Simmered 14 hours', ARRAY['Ramen']),
  ('v-6', 'Meals', 'Crispy Prawn & Veg Tempura', '6 pcs', 900.0, 'Tiger prawns and seasonal vegetables dipped in airy batter with tentsuyu dip.', 'Light & airy crisp', ARRAY['Tempura']),
  ('v-6', 'Meals', 'Teriyaki Glazed Salmon Bowl', '1 portion', 1100.0, 'Pan-seared Norwegian salmon in homemade sweet mirin teriyaki glaze.', 'Healthy protein', ARRAY['Seafood']),
  ('v-6', 'Soups', 'Agedashi Tofu Miso Soup', 'Bowl', 400.0, 'Fermented white miso broth with silken tofu cubes, wakame, and scallions.', 'Probiotic staple', ARRAY['Vegetarian']),
  ('v-6', 'Soups', 'Spicy Kimchi Seafood Broth', 'Bowl', 500.0, 'Spicy broth with squid rings, clams, and fermented Napa cabbage.', 'Bold & piquant', ARRAY['Seafood']),
  ('v-6', 'Drinks', 'Iced Matcha Green Tea Latte', '350ml', 400.0, 'Ceremonial grade Uji matcha whisked with cold fresh milk.', 'Clean sustained energy', ARRAY['Matcha']),
  ('v-6', 'Drinks', 'Asahi Super Dry Draft Beer', '330ml', 450.0, 'Iconic Karakuchi dry lager with clean, crisp finish.', '5.0% ABV', ARRAY['Beer']),

  -- v-7 Habesha Authentic Ethiopian (6 Meals, 2 Soups, 2 Drinks)
  ('v-7', 'Meals', 'Doro Wat Spicy Chicken Stew', '1 portion', 950.0, 'Slow cooked chicken drumstick in berbere spice paste with hard boiled egg and injera.', 'National dish of Ethiopia', ARRAY['Spicy', 'Signature']),
  ('v-7', 'Meals', 'Key Wat Spicy Prime Beef Stew', '1 portion', 900.0, 'Lean beef chunks simmered with spiced clarified butter and caramelized onions.', 'Rich spice profile', ARRAY['Signature']),
  ('v-7', 'Meals', 'Special Mixed Meat & Veggie Platter', 'For 2', 1350.0, 'Large injera platter topped with tibs, doro wat, misir wat, and gomen greens.', 'Perfect for sharing', ARRAY['Platter']),
  ('v-7', 'Meals', 'Ye-Misir Wat Spicy Red Lentils', '1 portion', 650.0, 'Split red lentils simmered in aromatic berbere sauce until tender and rich.', 'Plant protein loaded', ARRAY['Vegan']),
  ('v-7', 'Meals', 'Beef Tibs Sautéed with Rosemary', '1 portion', 1000.0, 'Pan-seared beef cubes tossed with jalapeños, onions, and fresh rosemary sprigs.', 'Tender hot pan sizzling', ARRAY['High Protein']),
  ('v-7', 'Meals', 'Gomen Braised Collard Greens & Alicha', '1 portion', 600.0, 'Finely chopped collard greens stewed with garlic, ginger, and turmeric.', 'Wholesome greens', ARRAY['Vegan']),
  ('v-7', 'Soups', 'Habesha Spiced Lentil Soup', 'Bowl', 400.0, 'Velvety yellow split peas seasoned with korarima and garlic.', 'Warming & nourishing', ARRAY['Vegan']),
  ('v-7', 'Soups', 'Spiced Lamb Bone Broth', 'Bowl', 450.0, 'Nourishing bone broth simmered with cardamom, ginger, and black cumin.', 'Vitality restorative', ARRAY['Gluten Free']),
  ('v-7', 'Drinks', 'Traditional Ethiopian Claypot Coffee', 'Cup', 250.0, 'Freshly roasted green beans brewed in a jebena pot over glowing charcoal.', 'Ceremonial roast', ARRAY['Coffee']),
  ('v-7', 'Drinks', 'St. George Ethiopian Amber Beer', '330ml', 350.0, 'Historic Ethiopian malt lager brewed in Addis Ababa since 1922.', '4.7% ABV', ARRAY['Beer']),

  -- v-8 El Taco Loco Taqueria (6 Meals, 2 Soups, 2 Drinks)
  ('v-8', 'Meals', 'Birria Beef Tacos with Consomé', '3 tacos', 900.0, 'Braised brisket tacos griddled in beef fat, melted jack cheese, and savory dipping broth.', 'Tiktok viral favorite', ARRAY['Signature']),
  ('v-8', 'Meals', 'Al Pastor Pork Tacos', '3 tacos', 800.0, 'Spit-roasted marinated pork with caramelized pineapple, cilantro, and salsa verde.', 'Street taco classic', ARRAY['Pork']),
  ('v-8', 'Meals', 'Carne Asada Steak Burrito', '1 giant burrito', 850.0, 'Charred flank steak, cilantro-lime rice, pinto beans, guacamole, and sour cream.', 'Substantial dinner wrap', ARRAY['Hearty']),
  ('v-8', 'Meals', 'Sizzling Chicken Fajitas', '1 skillet portion', 950.0, 'Bell peppers and spiced chicken breast served with warm flour tortillas.', 'Sizzling hot', ARRAY['High Protein']),
  ('v-8', 'Meals', 'Loaded Carnitas Nachos Grande', '1 platter', 750.0, 'Corn chips layered with pulled pork, queso sauce, jalapeños, and pico de gallo.', 'Party shareable', ARRAY['Shareable']),
  ('v-8', 'Meals', 'Roasted Corn & Black Bean Quesadilla', '1 portion', 650.0, 'Charred sweetcorn, chipotle black beans, and melted pepper jack in flour tortilla.', 'Vegetarian favorite', ARRAY['Vegetarian']),
  ('v-8', 'Soups', 'Sopa de Tortilla (Chicken Tortilla Soup)', 'Bowl', 450.0, 'Tomato and roasted pasilla chili broth with shredded chicken and crispy tortilla strips.', 'Smoky & rich', ARRAY['Gluten Free']),
  ('v-8', 'Soups', 'Pozole Rojo Pork Hominy Soup', 'Bowl', 500.0, 'Traditional Mexican red stew made with hominy corn and tender pork shoulder.', 'Festive classic', ARRAY['Pork']),
  ('v-8', 'Drinks', 'Horchata Sweet Cinnamon Rice Milk', '400ml', 300.0, 'House-made rice beverage blended with vanilla, cinnamon, and condensed milk.', 'Creamy sweet cooler', ARRAY['Sweet']),
  ('v-8', 'Drinks', 'Corona Extra with Fresh Lime', '355ml', 400.0, 'Crisp Mexican pale lager served ice cold with lime wedge.', '4.5% ABV', ARRAY['Beer']),

  -- v-9 Curry House Nairobi (6 Meals, 2 Soups, 2 Drinks)
  ('v-9', 'Meals', 'Butter Chicken Masala (Murgh Makhani)', '1 portion', 950.0, 'Charcoal roasted tandoori chicken cooked in creamy tomato, butter, and cashew gravy.', 'Mild and luxurious', ARRAY['Signature']),
  ('v-9', 'Meals', 'Slow Cooked Lamb Rogan Josh', '1 portion', 1050.0, 'Kashmiri style lamb curry simmered with browned onions, yogurt, and aromatic spices.', 'Deep rich flavors', ARRAY['Halal']),
  ('v-9', 'Meals', 'Palak Paneer Fresh Spinach Curry', '1 portion', 800.0, 'Fresh artisanal cottage cheese cubes in spiced creamy pureed spinach.', 'Rich in calcium & iron', ARRAY['Vegetarian']),
  ('v-9', 'Meals', 'Dum Handi Chicken Biryani', '1 portion', 850.0, 'Sealed clay pot basmati rice layered with spiced marinated chicken and mint.', 'Royal Mughal recipe', ARRAY['Signature']),
  ('v-9', 'Meals', 'Dal Makhani Slow Simmered Black Lentils', '1 portion', 700.0, 'Black lentils cooked overnight on low heat with butter, cream, and ginger.', 'Slow cooked 24 hours', ARRAY['Vegetarian']),
  ('v-9', 'Meals', 'Garlic Butter Naan Basket & Samosas', 'Combo basket', 600.0, 'Tandoor baked garlic naan paired with 3 crispy Punjabi potato pea samosas.', 'Fresh from tandoor', ARRAY['Vegetarian']),
  ('v-9', 'Soups', 'Mulligatawny Spiced Lentil Soup', 'Bowl', 450.0, 'Colonial Anglo-Indian spiced curry and yellow lentil soup with apple essence.', 'Unique spice fusion', ARRAY['Vegetarian']),
  ('v-9', 'Soups', 'Tomato Shorba Herb Broth', 'Bowl', 400.0, 'Delicately spiced roasted tomato broth infused with fresh coriander stems.', 'Light & aromatic', ARRAY['Vegan']),
  ('v-9', 'Drinks', 'Mango Lassi Yogurt Smoothie', '350ml', 350.0, 'Ripe Alphonso mango puree blended with thick whole milk yogurt and cardamom.', 'Cooling digestive', ARRAY['Yogurt']),
  ('v-9', 'Drinks', 'Masala Chai Spiced Milk Tea', 'Cup', 250.0, 'Brewed Assam tea leaves with crushed ginger, cardamom, cinnamon, and whole milk.', 'Energizing warmth', ARRAY['Tea']),

  -- v-10 Bangkok Street Thai (6 Meals, 2 Soups, 2 Drinks)
  ('v-10', 'Meals', 'Classic Pad Thai with Jumbo Prawns', '1 portion', 900.0, 'Stir-fried rice noodles with eggs, tofu, bean sprouts, peanuts, and tamarind glaze.', 'Thailands national street dish', ARRAY['Signature']),
  ('v-10', 'Meals', 'Green Curry Chicken (Gaeng Kiew Wan)', '1 portion', 850.0, 'Fragrant coconut milk curry with pea eggplants, bamboo shoots, and Thai sweet basil.', 'Medium heat aromatic', ARRAY['Curry']),
  ('v-10', 'Meals', 'Spicy Thai Basil Beef (Pad Krapow)', '1 portion', 800.0, 'Wok-seared minced beef with holy basil, garlic, and fiery bird''s eye chilies with fried egg.', 'Bold & savory', ARRAY['Spicy']),
  ('v-10', 'Meals', 'Massaman Lamb Shank Curry', '1 portion', 1200.0, 'Slow cooked lamb in rich roasted peanut, cinnamon, and coconut milk curry.', 'Southern Thai rich gravy', ARRAY['Halal']),
  ('v-10', 'Meals', 'Pineapple Fried Rice with Cashews', '1 portion', 750.0, 'Jasmine rice fried with fresh pineapple, curry powder, raisins, and roasted cashews.', 'Sweet savory balance', ARRAY['Vegetarian']),
  ('v-10', 'Meals', 'Crispy Golden Thai Spring Rolls', '4 rolls', 600.0, 'Crispy rolls packed with glass noodles, cabbage, and shiitake mushrooms with plum sauce.', 'Appetizer staple', ARRAY['Vegan']),
  ('v-10', 'Soups', 'Tom Yum Goong Spicy Prawn Soup', 'Bowl', 550.0, 'Hot and sour soup infused with lemongrass, kaffir lime leaves, galangal, and prawns.', 'Immunity boosting broth', ARRAY['Spicy']),
  ('v-10', 'Soups', 'Tom Kha Gai Coconut Chicken Soup', 'Bowl', 500.0, 'Creamy coconut soup with sliced chicken, mushrooms, and fragrant galangal.', 'Velvety & soothing', ARRAY['Gluten Free']),
  ('v-10', 'Drinks', 'Cha Yen Thai Sweet Iced Tea', '350ml', 350.0, 'Brewed Ceylon tea spiced with star anise and served over crushed ice with sweet milk.', 'Iconic orange tea', ARRAY['Sweet']),
  ('v-10', 'Drinks', 'Singha Premium Thai Lager', '330ml', 400.0, 'Original Thai beer with rich body and dry finish.', '5.0% ABV', ARRAY['Beer']),

  -- v-11 Carnivore Smokehouse (6 Meals, 2 Soups, 2 Drinks)
  ('v-11', 'Meals', 'Charcoal Grilled Goat Leg (Nyama Choma)', '500g', 1200.0, 'Prime Kenyan highland goat leg roasted slowly over whistling acacia charcoal.', 'Iconic Nairobi feast', ARRAY['Signature', 'Keto']),
  ('v-11', 'Meals', 'Smoked Beef Brisket Platter', '400g', 1100.0, 'Smoked 12 hours over hickory wood, carved thick with spicy tamarind BBQ sauce.', 'Tender smoke ring', ARRAY['BBQ']),
  ('v-11', 'Meals', 'Honey Glazed Pork Ribs', 'Half rack', 1250.0, 'Succulent pork ribs basted with Baringo forest honey and crushed chilies.', 'Sticky sweet savory', ARRAY['Pork']),
  ('v-11', 'Meals', 'Flame Grilled Kienyeji Chicken', 'Half bird', 950.0, 'Indigenous free-range Kenyan chicken seasoned with rosemary and sea salt.', 'Firm flavorful meat', ARRAY['Free Range']),
  ('v-11', 'Meals', 'Grilled Boerwors Sausage with Chakalaka', '2 big coils', 800.0, 'Coarse ground beef and coriander sausage served with spicy vegetable relish.', 'South African style', ARRAY['Spicy']),
  ('v-11', 'Meals', 'Mukimo Mash with Sukuma Wiki', '1 portion', 550.0, 'Traditional mashed potatoes, pumpkin leaves, maize, and beans.', 'Central Kenya classic', ARRAY['Vegetarian']),
  ('v-11', 'Soups', 'Nairobi Oxtail Bone Broth', 'Bowl', 450.0, 'Rich gelatinous bone broth slow cooked with root vegetables and black pepper.', 'Collagen rich', ARRAY['Keto']),
  ('v-11', 'Soups', 'Creamy Sweet Potato Ginger Soup', 'Bowl', 400.0, 'Roasted orange sweet potatoes pureed with fresh ginger and coriander.', 'Nutrient rich', ARRAY['Vegan']),
  ('v-11', 'Drinks', 'Tusker Lager Nairobi Pride', '500ml', 350.0, 'Kenya''s legendary brewing icon since 1922, brewed with local barley.', '4.2% ABV', ARRAY['Beer']),
  ('v-11', 'Drinks', 'Passion Fruit & Ginger Cooler', '350ml', 300.0, 'Freshly pressed coastal passion fruit with spicy ginger extract.', 'Refreshing cooler', ARRAY['Mocktail']),

  -- v-12 Marrakech Tagine & Grill (6 Meals, 2 Soups, 2 Drinks)
  ('v-12', 'Meals', 'Slow Cooked Lamb & Prune Tagine', '1 portion', 1150.0, 'Tender lamb shank stewed in earthen clay with honeyed prunes and toasted almonds.', 'Moroccan royal tagine', ARRAY['Signature']),
  ('v-12', 'Meals', 'Chicken Tagine with Preserved Lemons & Olives', '1 portion', 950.0, 'Free range chicken simmered with saffron, turmeric, and tangy cured lemons.', 'Zesty & fragrant', ARRAY['Halal']),
  ('v-12', 'Meals', 'Seven Vegetable Steamed Couscous', '1 portion', 750.0, 'Fluffy hand-rolled semolina couscous smothered in rich spiced vegetable broth.', 'Plant based feast', ARRAY['Vegan']),
  ('v-12', 'Meals', 'Kefta Meatball Tagine with Baked Eggs', '1 portion', 850.0, 'Spiced minced beef meatballs in tomato cumin sauce with gently poached eggs.', 'Comfort breakfast or dinner', ARRAY['Halal']),
  ('v-12', 'Meals', 'Crispy Chicken Pastilla Filo Pie', '1 portion', 900.0, 'Sweet and savory pie layered with shredded spiced chicken, almonds, and cinnamon sugar.', 'Fes culinary marvel', ARRAY['Artisan']),
  ('v-12', 'Meals', 'Merguez Spicy Sausage Grill', '3 sausages', 800.0, 'North African spiced beef and lamb sausages served with harissa and warm khobz bread.', 'Fiery harissa dip', ARRAY['Spicy']),
  ('v-12', 'Soups', 'Traditional Moroccan Harira Soup', 'Bowl', 450.0, 'Rich tomato and lentil soup with chickpeas, fresh herbs, and warming spices.', 'Ramadan comfort bowl', ARRAY['Vegetarian']),
  ('v-12', 'Soups', 'Chilled Cucumber Mint Gazpacho', 'Bowl', 400.0, 'Blended garden cucumbers, Greek yogurt, garlic, and fresh crushed spearmint.', 'Light & crisp', ARRAY['Vegetarian']),
  ('v-12', 'Drinks', 'Moroccan Mint Maghrebi Tea', 'Pot', 250.0, 'Green gunpowder tea brewed with fresh spearmint leaves and cane sugar.', 'Hospitality emblem', ARRAY['Tea']),
  ('v-12', 'Drinks', 'Pomegranate Rose Refresher', '350ml', 350.0, 'Tart pomegranate juice with a touch of rosewater and sparkling water.', 'Floral & antioxidant', ARRAY['Mocktail']);
