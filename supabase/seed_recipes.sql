-- =============================================================
-- Jikoni Realtime Recipes & Ingredients Seed
-- =============================================================

-- Chef Amani: 17dde0f7-1d1f-452c-9c08-a098bd88fc97
-- Wambui Kamau: 2a6b8b03-b779-4112-93e1-3741ab3f2756

INSERT INTO recipes (id, author_id, vendor_id, title, image_urls, description, instructions) VALUES
  (
    'c1111111-1111-1111-1111-111111111111'::uuid,
    '17dde0f7-1d1f-452c-9c08-a098bd88fc97'::uuid,
    'v-1',
    'Traditional Coastal Beef Pilau',
    ARRAY['https://images.unsplash.com/photo-1596040033229-a9821ebd058d?q=80&w=800'],
    'Fragrant Swahili spiced rice slow-cooked with tender prime beef cubes, whole cumin, and served with tangy kachumbari.',
    ARRAY[
      'Boil prime beef cubes with ginger, garlic, and sea salt until fork tender, reserving the rich broth.',
      'In a heavy-bottom sufuria, brown thinly sliced red onions in ghee until deep mahogany.',
      'Add crushed pilau masala, garlic-ginger paste, and boiled meat; fry until fragrant.',
      'Stir in washed aromatic basmati rice and pour in the seasoned beef broth.',
      'Cover tightly and simmer on low charcoal heat for 25 minutes until fluffy.'
    ]
  ),
  (
    'c2222222-2222-2222-2222-222222222222'::uuid,
    '17dde0f7-1d1f-452c-9c08-a098bd88fc97'::uuid,
    'v-1',
    'Swahili Coconut Fish Curry',
    ARRAY['https://images.unsplash.com/photo-1596040033229-a9821ebd058d?q=80&w=800'],
    'Fresh Red Snapper simmered in freshly squeezed coastal coconut cream, ripe tomatoes, turmeric, and lime.',
    ARRAY[
      'Season fish fillets with sea salt, turmeric, and freshly squeezed lime juice.',
      'Sauté onions, fresh ginger, and garlic in coconut oil until soft.',
      'Add chopped tomatoes, curry powder, and thin coconut milk; simmer for 10 minutes.',
      'Gently lay fish fillets into the simmering gravy and cook for 6 minutes.',
      'Pour in thick coconut cream, turn off heat, and garnish with fresh coriander.'
    ]
  ),
  (
    'c3333333-3333-3333-3333-333333333333'::uuid,
    '17dde0f7-1d1f-452c-9c08-a098bd88fc97'::uuid,
    'v-7',
    'Authentic Doro Wat Spicy Chicken Stew',
    ARRAY['https://images.unsplash.com/photo-1541518763669-27fef04b14ea?q=80&w=800'],
    'Ethiopian national dish: slow-simmered chicken drumsticks in rich berbere spice paste and niter kibbeh clarified butter.',
    ARRAY[
      'Slowly sweat pureed red onions in a dry pan for 30 minutes without oil until deep purple-brown.',
      'Add niter kibbeh spiced butter, minced garlic, and fiery Ethiopian berbere paste; cook for 15 minutes.',
      'Add marinated chicken pieces and gently simmer for 40 minutes on low heat.',
      'Score hard-boiled eggs and submerge into the rich red sauce during the last 10 minutes.',
      'Serve steaming hot with spongy sourdough injera bread.'
    ]
  ),
  (
    'c4444444-4444-4444-4444-444444444444'::uuid,
    '17dde0f7-1d1f-452c-9c08-a098bd88fc97'::uuid,
    'v-11',
    'Nairobi Slow-Smoked Beef Brisket',
    ARRAY['https://images.unsplash.com/photo-1544025162-d76694265947?q=80&w=800'],
    'Smoked 12 hours over native acacia and hickory wood with coarse black pepper rub and spicy tamarind barbecue glaze.',
    ARRAY[
      'Trim brisket fat cap to 1/4 inch and apply mustard binder with coarse sea salt and black pepper.',
      'Preheat smoker to 225°F with acacia logs and wood chips.',
      'Smoke brisket unwrapped until internal temperature reaches 165°F and rich dark bark forms.',
      'Wrap in butcher paper with beef tallow and continue cooking until probe tender at 203°F.',
      'Rest for 2 hours in a cooler before carving thick slices.'
    ]
  ),
  (
    'c5555555-5555-5555-5555-555555555555'::uuid,
    '2a6b8b03-b779-4112-93e1-3741ab3f2756'::uuid,
    'v-11',
    'Kilimani Sunday Mukimo & Sukuma Wiki',
    ARRAY['https://images.unsplash.com/photo-1544025162-d76694265947?q=80&w=800'],
    'Comforting Central Kenyan mash of boiled potatoes, soft maize, pumpkin leaves (kahurura), served with braised beef stew.',
    ARRAY[
      'Boil potatoes, green maize, and drained black nightshade or pumpkin leaves in salted water.',
      'Mash thoroughly using a wooden mwiko until vibrant green, smooth, and uniform.',
      'Sauté chopped spring onions in butter and fold into the mash.',
      'Braised shredded sukuma wiki with sweet tomatoes and red onions.',
      'Plate a generous mound of mukimo beside tender beef stew and greens.'
    ]
  ),
  (
    'c6666666-6666-6666-6666-666666666666'::uuid,
    '2a6b8b03-b779-4112-93e1-3741ab3f2756'::uuid,
    'v-8',
    'Home-Style Birria Beef Tacos',
    ARRAY['https://images.unsplash.com/photo-1565299585323-38d6b0865b47?q=80&w=800'],
    'Tender shredded beef brisket griddled in corn tortillas with melted jack cheese, chopped cilantro, and savory dipping consomé.',
    ARRAY[
      'Sear chuck roast seasoned with Mexican oregano and cumin in hot oil.',
      'Blend rehydrated guajillo chilies, garlic, roasted tomatoes, and beef broth.',
      'Pour chili sauce over beef and slow cook for 4 hours until meltingly tender.',
      'Dip corn tortillas in the red rendered fat and crisp on a smoking hot flat-top.',
      'Layer melted cheese and shredded meat, fold, and serve with hot consomé.'
    ]
  ),
  (
    'c7777777-7777-7777-7777-777777777777'::uuid,
    '2a6b8b03-b779-4112-93e1-3741ab3f2756'::uuid,
    'v-9',
    'Creamy Palak Paneer & Garlic Naan',
    ARRAY['https://images.unsplash.com/photo-1585937421612-70a008356fbe?q=80&w=800'],
    'Fresh artisanal paneer cheese cubes gently folded into spiced creamy spinach puree, paired with charred garlic butter naan.',
    ARRAY[
      'Blanch fresh spinach leaves for 2 minutes, shock in ice water, and puree with green chilies.',
      'Pan fry cubed paneer in ghee until edges are golden.',
      'Sauté cumin seeds, finely diced onions, ginger, and garlic paste in butter.',
      'Stir in blended spinach puree, garam masala, and fresh cooking cream.',
      'Add paneer cubes, gently simmer for 3 minutes, and serve with hot tandoor naan.'
    ]
  ),
  (
    'c8888888-8888-8888-8888-888888888888'::uuid,
    '2a6b8b03-b779-4112-93e1-3741ab3f2756'::uuid,
    'v-10',
    'Classic Pad Thai Noodles',
    ARRAY['https://images.unsplash.com/photo-1559314809-0d155014e29e?q=80&w=800'],
    'Wok-tossed rice noodles with jumbo prawns, firm tofu, crunchy bean sprouts, toasted crushed peanuts, and tart tamarind sauce.',
    ARRAY[
      'Soak flat rice noodles in warm water for 30 minutes until pliable.',
      'Whisk tamarind paste, fish sauce, palm sugar, and chili flakes for sauce.',
      'Heat oil in wok; scramble eggs, prawns, and firm pressed tofu.',
      'Add drained noodles and sauce; toss vigorously over high flame until caramelized.',
      'Fold in fresh bean sprouts, Chinese chives, and top with roasted peanuts.'
    ]
  )
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  image_urls = EXCLUDED.image_urls,
  description = EXCLUDED.description,
  instructions = EXCLUDED.instructions;

-- Recipe Ingredients
DELETE FROM recipe_ingredients WHERE recipe_id IN (
  'c1111111-1111-1111-1111-111111111111'::uuid,
  'c2222222-2222-2222-2222-222222222222'::uuid,
  'c3333333-3333-3333-3333-333333333333'::uuid,
  'c4444444-4444-4444-4444-444444444444'::uuid,
  'c5555555-5555-5555-5555-555555555555'::uuid,
  'c6666666-6666-6666-6666-666666666666'::uuid,
  'c7777777-7777-7777-7777-777777777777'::uuid,
  'c8888888-8888-8888-8888-888888888888'::uuid
);

INSERT INTO recipe_ingredients (recipe_id, name, amount, price, vendor_id, details) VALUES
  ('c1111111-1111-1111-1111-111111111111'::uuid, 'Aromatic Basmati Rice', '500g', 180.0, 'v-1', 'Long grain aged basmati rice'),
  ('c1111111-1111-1111-1111-111111111111'::uuid, 'Prime Beef Chuck Cubes', '500g', 420.0, 'v-1', 'Fresh Kenyan highland beef'),
  ('c1111111-1111-1111-1111-111111111111'::uuid, 'Swahili Pilau Masala', '50g', 90.0, 'v-1', 'Ground cumin, cardamom, and cinnamon blend'),
  ('c1111111-1111-1111-1111-111111111111'::uuid, 'Red Bombay Onions', '500g', 110.0, 'v-1', 'Crisp fresh red onions'),

  ('c2222222-2222-2222-2222-222222222222'::uuid, 'Fresh Red Snapper Fillets', '400g', 550.0, 'v-1', 'Wild-caught coastal snapper'),
  ('c2222222-2222-2222-2222-222222222222'::uuid, 'Pressed Coconut Milk', '400ml', 160.0, 'v-1', 'Fresh Kilifi coconut milk'),
  ('c2222222-2222-2222-2222-222222222222'::uuid, 'Ground Turmeric & Lime', '1 set', 80.0, 'v-1', 'Fresh spices'),

  ('c3333333-3333-3333-3333-333333333333'::uuid, 'Free-Range Chicken Drumsticks', '6 pcs', 480.0, 'v-7', 'Fresh local poultry'),
  ('c3333333-3333-3333-3333-333333333333'::uuid, 'Ethiopian Berbere Spice Blend', '100g', 150.0, 'v-7', 'Traditional sun-dried chili blend'),
  ('c3333333-3333-3333-3333-333333333333'::uuid, 'Niter Kibbeh Spiced Butter', '150g', 220.0, 'v-7', 'Clarified spiced butter'),

  ('c4444444-4444-4444-4444-444444444444'::uuid, 'Prime Beef Brisket Flat', '1kg', 850.0, 'v-11', 'Aged marbled beef brisket'),
  ('c4444444-4444-4444-4444-444444444444'::uuid, 'Smoked Hickory BBQ Rub', '80g', 120.0, 'v-11', 'Coarse salt, pepper, and paprika'),

  ('c5555555-5555-5555-5555-555555555555'::uuid, 'Fresh Potatoes & Green Maize', '800g', 250.0, 'v-11', 'Farm harvested highland produce'),
  ('c5555555-5555-5555-5555-555555555555'::uuid, 'Pumpkin Leaves (Kahurura)', '1 bunch', 70.0, 'v-11', 'Fresh leafy greens'),

  ('c6666666-6666-6666-6666-666666666666'::uuid, 'Braised Beef Brisket', '500g', 500.0, 'v-8', 'Slow-cooked juicy shredded beef'),
  ('c6666666-6666-6666-6666-666666666666'::uuid, 'White Corn Tortillas', '12 pack', 220.0, 'v-8', 'Authentic stone ground corn tortillas'),
  ('c6666666-6666-6666-6666-666666666666'::uuid, 'Monterey Jack Cheese', '200g', 280.0, 'v-8', 'Melting cheese block'),

  ('c7777777-7777-7777-7777-777777777777'::uuid, 'Artisanal Fresh Paneer', '300g', 320.0, 'v-9', 'Soft cottage cheese cubes'),
  ('c7777777-7777-7777-7777-777777777777'::uuid, 'Baby Spinach Leaves', '400g', 120.0, 'v-9', 'Fresh tender spinach'),
  ('c7777777-7777-7777-7777-777777777777'::uuid, 'Fresh Garlic Naan Dough', '3 pcs', 180.0, 'v-9', 'Ready to bake tandoori naan'),

  ('c8888888-8888-8888-8888-888888888888'::uuid, 'Thai Rice Noodles', '350g', 210.0, 'v-10', 'Flat dried rice noodles'),
  ('c8888888-8888-8888-8888-888888888888'::uuid, 'Jumbo Tiger Prawns', '250g', 600.0, 'v-10', 'Peeled and deveined ocean prawns'),
  ('c8888888-8888-8888-8888-888888888888'::uuid, 'Tamarind Palm Sugar Glaze', '150ml', 150.0, 'v-10', 'Authentic Thai Pad Thai sauce');
