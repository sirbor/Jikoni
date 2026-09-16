-- Jikoni — Phase 1 backend schema (Supabase / Postgres)
--
-- Run this once in the Supabase SQL editor (or via `supabase db push` with the CLI)
-- against a fresh project. Mirrors Jikoni/Domain/Models/*.swift.

-- ─────────────────────────────────────────────────────────────
-- Profiles (1:1 with auth.users)
-- ─────────────────────────────────────────────────────────────
create table profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  display_name text,
  phone_number text unique,
  profile_image_url text,
  profile_bio text not null default '',
  skill_level text not null default 'Home Cook',
  dietary_goals text[] not null default '{}',
  loyalty_points integer not null default 0,
  cookbook_ids text[] not null default '{}',
  followers_count integer not null default 0,
  following_count integer not null default 0,
  recipes_count integer not null default 0,
  average_rating double precision not null default 0,
  membership_tier text not null default 'bronze',
  member_since timestamptz not null default now(),
  favorite_cuisines text[] not null default '{}',
  preferred_contact text not null default 'phone',
  allows_push_notifications boolean not null default true,
  allows_promotional_emails boolean not null default true
);

create table addresses (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references profiles (id) on delete cascade,
  label text not null,
  line1 text not null,
  line2 text,
  city text not null,
  delivery_notes text not null default '',
  is_default boolean not null default false
);

create table payment_methods (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references profiles (id) on delete cascade,
  brand text not null,
  last_four text not null,
  expiry text not null,
  holder_name text not null,
  is_default boolean not null default false
  -- Display metadata only — never store raw card numbers here.
  -- Real tokenization is a Phase 2 payment-provider (Stripe/Flutterwave) concern.
);

-- ─────────────────────────────────────────────────────────────
-- Vendors + menu
-- ─────────────────────────────────────────────────────────────
create table vendors (
  id text primary key,
  name text not null,
  cuisine text not null,
  image_urls text[] not null default '{}',
  delivery_fee double precision not null default 0,
  rating double precision not null default 0,
  latitude double precision not null,
  longitude double precision not null,
  review_count integer not null default 0,
  estimated_delivery_minutes integer not null default 35,
  minimum_order double precision not null default 500,
  phone_number text not null default '+254700000000',
  hygiene_rating text not null default 'A',
  opening_hours text not null default '08:00 - 23:00',
  is_open_now boolean not null default true,
  price_range text not null default '$$',
  dietary_tags text[] not null default '{}',
  is_featured boolean not null default false
);

create table menu_items (
  id uuid primary key default gen_random_uuid(),
  vendor_id text not null references vendors (id) on delete cascade,
  category text not null check (category in ('Soups', 'Meals', 'Drinks')),
  name text not null,
  amount text not null,
  price double precision not null,
  details text not null default '',
  image_url text,
  is_available boolean not null default true,
  nutritional_notes text not null default '',
  dietary_tags text[] not null default '{}'
);

create table vendor_reviews (
  id uuid primary key default gen_random_uuid(),
  vendor_id text not null references vendors (id) on delete cascade,
  author text not null,
  comment text not null,
  rating integer not null check (rating between 1 and 5),
  date timestamptz not null default now(),
  photo_urls text[] not null default '{}'
);

-- ─────────────────────────────────────────────────────────────
-- Recipes
-- ─────────────────────────────────────────────────────────────
create table recipes (
  id uuid primary key default gen_random_uuid(),
  author_id uuid not null references profiles (id) on delete cascade,
  vendor_id text references vendors (id) on delete set null,
  title text not null,
  image_urls text[] not null default '{}',
  description text not null default '',
  instructions text[] not null default '{}',
  created_at timestamptz not null default now()
);

create table recipe_ingredients (
  id uuid primary key default gen_random_uuid(),
  recipe_id uuid not null references recipes (id) on delete cascade,
  name text not null,
  amount text not null,
  price double precision not null default 0,
  vendor_id text references vendors (id) on delete set null,
  details text not null default '',
  image_url text,
  is_available boolean not null default true,
  nutritional_notes text not null default '',
  dietary_tags text[] not null default '{}'
);

create table recipe_likes (
  recipe_id uuid not null references recipes (id) on delete cascade,
  user_id uuid not null references profiles (id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (recipe_id, user_id)
);

create table comments (
  id uuid primary key default gen_random_uuid(),
  recipe_id uuid not null references recipes (id) on delete cascade,
  parent_comment_id uuid references comments (id) on delete cascade,
  author_id uuid not null references profiles (id) on delete cascade,
  text text not null,
  created_at timestamptz not null default now()
);

-- ─────────────────────────────────────────────────────────────
-- Orders
-- ─────────────────────────────────────────────────────────────
create table orders (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references profiles (id) on delete cascade,
  status text not null default 'received'
    check (status in ('received', 'confirmed', 'preparing', 'riderAssigned', 'onTheWay', 'delivered')),
  total double precision not null default 0,
  subtotal double precision not null default 0,
  service_fee double precision not null default 0,
  discount double precision not null default 0,
  tip double precision not null default 0,
  restaurant_name text not null default 'Jikoni Partner',
  payment_method text not null default 'M-Pesa',
  receipt_notes text not null default '',
  is_delivered_confirmed boolean not null default false,
  courier_latitude double precision,
  courier_longitude double precision,
  destination_latitude double precision,
  destination_longitude double precision,
  created_at timestamptz not null default now()
);

create table order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references orders (id) on delete cascade,
  menu_item_id uuid references menu_items (id) on delete set null,
  name text not null,
  amount text not null,
  price double precision not null,
  quantity integer not null default 1
);

-- ─────────────────────────────────────────────────────────────
-- Row Level Security
-- ─────────────────────────────────────────────────────────────
alter table profiles enable row level security;
alter table addresses enable row level security;
alter table payment_methods enable row level security;
alter table vendors enable row level security;
alter table menu_items enable row level security;
alter table vendor_reviews enable row level security;
alter table recipes enable row level security;
alter table recipe_ingredients enable row level security;
alter table recipe_likes enable row level security;
alter table comments enable row level security;
alter table orders enable row level security;
alter table order_items enable row level security;

-- Owner-scoped tables
create policy "profiles: owner read/write" on profiles
  for all using (auth.uid() = id) with check (auth.uid() = id);

create policy "addresses: owner read/write" on addresses
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "payment_methods: owner read/write" on payment_methods
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "orders: owner read/write" on orders
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "order_items: owner read/write via order" on order_items
  for all using (exists (select 1 from orders o where o.id = order_id and o.user_id = auth.uid()))
  with check (exists (select 1 from orders o where o.id = order_id and o.user_id = auth.uid()));

-- Public-read catalog tables
create policy "vendors: public read" on vendors for select using (true);
create policy "menu_items: public read" on menu_items for select using (true);
create policy "vendor_reviews: public read" on vendor_reviews for select using (true);
create policy "vendor_reviews: insert write" on vendor_reviews for insert with check (true);

-- Recipes: public read, author-scoped write
create policy "recipes: public read" on recipes for select using (true);
create policy "recipes: author write" on recipes
  for insert with check (auth.uid() = author_id);
create policy "recipes: author update/delete" on recipes
  for update using (auth.uid() = author_id) with check (auth.uid() = author_id);
create policy "recipes: author delete" on recipes
  for delete using (auth.uid() = author_id);

create policy "recipe_ingredients: public read" on recipe_ingredients for select using (true);
create policy "recipe_ingredients: author write via recipe" on recipe_ingredients
  for insert with check (exists (select 1 from recipes r where r.id = recipe_id and r.author_id = auth.uid()));

create policy "recipe_likes: public read" on recipe_likes for select using (true);
create policy "recipe_likes: self write" on recipe_likes
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "comments: public read" on comments for select using (true);
create policy "comments: authenticated write" on comments
  for insert with check (auth.uid() = author_id);

-- ─────────────────────────────────────────────────────────────
-- Storage buckets (public read, owner-folder write)
-- ─────────────────────────────────────────────────────────────
insert into storage.buckets (id, name, public) values
  ('recipe-photos', 'recipe-photos', true),
  ('review-photos', 'review-photos', true),
  ('profile-photos', 'profile-photos', true)
on conflict (id) do nothing;

create policy "recipe-photos: public read" on storage.objects
  for select using (bucket_id = 'recipe-photos');
create policy "recipe-photos: owner write" on storage.objects
  for insert with check (bucket_id = 'recipe-photos' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "review-photos: public read" on storage.objects
  for select using (bucket_id = 'review-photos');
create policy "review-photos: owner write" on storage.objects
  for insert with check (bucket_id = 'review-photos' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "profile-photos: public read" on storage.objects
  for select using (bucket_id = 'profile-photos');
create policy "profile-photos: owner write" on storage.objects
  for insert with check (bucket_id = 'profile-photos' and (storage.foldername(name))[1] = auth.uid()::text);
