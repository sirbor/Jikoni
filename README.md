# Jikoni

> **Cook it, Eat it.** — *Recipes from cooks near you, and the kitchens that make them.*

**Jikoni** is a modern East African culinary and food economy iOS application built with SwiftUI and Clean Architecture. Rooted in the flavors of Nairobi and East Africa, Jikoni seamlessly connects home cooking inspiration with local restaurant discovery, on-demand ordering, and real-time delivery tracking.

---

## Core Features

### 1. Modernist Onboarding & Authentication
- **Frictionless Sign In & Sign Up**: Direct email and password authentication with validation and animated state toggles.
- **Guest Exploration**: Browse the entire culinary feed, explore local kitchens, and inspect recipes without requiring an immediate account.
- **Profile Customization**: Tailored onboarding for home cooks, culinary enthusiasts, and professional chefs with dietary preference tags (*Swahili Special, Organic, Healthy, Plant-based, Halal*).

### 2. Culinary Feed & Interactive Cooking
- **Curated Community Recipes**: Rich culinary feed featuring authentic East African dishes (e.g., *Swahili Biryani Ya Kuku, Pilau ya Kondoo, Sukuma Wiki & Ugali, Coconut Fish Curry, Mandazi*).
- **Step-by-Step Cook Mode**: Dedicated distraction-free cooking interface with ingredients checklist, timer helpers, and stage navigation.
- **Social Engagement**: Like recipes, leave reviews, and publish your own family or kitchen recipes with detailed measurements.

### 3. Local Kitchens & Marketplace
- **Nairobi Neighborhood Kitchens**: Discover authentic eateries and home kitchens across Westlands, Kilimani, Nairobi CBD, Karen, and Parklands.
- **Comprehensive Menus & Details**: High-resolution menu items with dish descriptions, dietary tags, preparation times, and customer ratings.
- **Smart Cart Experience**: Multi-item cart management with real-time price calculation in Kenyan Shillings (KSh) and item quantities.

### 4. Checkout & East African Payments
- **Payment Options**: Support for Kenya's primary payment methods:
  - **M-Pesa**: Direct mobile money payment simulation with phone number confirmation.
  - **Credit / Debit Cards**: Secure card entry with inline formatting.
  - **Cash on Delivery**: Pay in cash upon rider arrival.
- **Realistic Pricing**: Authentic Kenyan Shillings (KSh) pricing and dynamic delivery fees based on location.

### 5. Real-Time Delivery Tracking
- **Interactive MapKit Route**: Live map showing vendor location, rider waypoint movement, and user drop-off destination.
- **Rider Waypoint Simulation**: High-fidelity background simulation traversing realistic Nairobi roads with real-time ETA countdowns.
- **Persistent Order Banner**: Global floating order status bar allowing the user to browse other tabs while keeping track of delivery stages (*Received, Preparing, Rider Picked Up, In Transit, Delivered*).
- **Instant Order Management**: Effortlessly stop or cancel demo simulations at any point, or mark orders as delivered to archive them directly into order history.

### 6. Profile & Order History
- **Multi-Role Accounts**: Tailored views for both **Customers** (past orders, saved favorites, addresses) and **Vendors** (restaurant info, active menu, incoming kitchen orders).
- **Hub & History**: Direct access to past orders, saved addresses, payment methods, and account settings.

---

## Pre-Configured Test Accounts

The app comes seeded with test accounts ready for direct sign-in:

| Role | Name / Kitchen | Email | Password |
| :--- | :--- | :--- | :--- |
| **Customer** | Wanjiku Mwangi | `wanjiku@jikoni.com` | `Password123!` |
| **Customer** | Kevin Omondi | `omondi@jikoni.com` | `Password123!` |
| **Vendor** | Mama Juma's African Kitchen | `mamajuma@jikoni.com` | `Password123!` |
| **Vendor** | Swahili Plate (Chef Hassan) | `swahiliplate@jikoni.com` | `Password123!` |

*(You can also use **"Explore as guest"** or sign up with any email address.)*

---

## Architecture & Technical Stack

Jikoni is architected following **Clean Architecture** principles to ensure strict separation of concerns, testability, and high maintainability.

```
Jikoni/
├── Domain/                # Pure business logic and enterprise rules
│   ├── Models/            # User, Recipe, Vendor, Order, Review, Ingredient
│   └── Repositories/      # Abstract repository protocols
├── Data/                  # Data access and API integrations
│   ├── Remote/            # Supabase repositories (Auth, Order, Recipe, Vendor)
│   └── Mocks/             # In-memory realistic repositories for offline/demo use
├── Infrastructure/        # Core plumbing and cross-cutting concerns
│   ├── RepositoryFactory.swift  # Dynamic provider (Supabase vs. Mock fallback)
│   └── Supabase/          # Supabase client configuration and singleton
└── Presentation/          # SwiftUI views and reactive view models
    ├── DesignSystem/      # Brand colors, typography (Instrument Serif & Archivo), chrome
    ├── Onboarding/        # Modernist WelcomeView and authentication
    ├── Feed/              # FeedView, RecipeDetailView, CookbookView, CreateRecipeView
    ├── Marketplace/       # CartView, VendorDetailView, OrderView, PaymentView, AddressView
    ├── Tracking/          # TrackingView, TrackingViewModel, Map overlays
    ├── Profile/           # ProfileView, OrdersView, Settings, Addresses
    └── Hub/               # HubViewModel, centralized state coordination
```

### Technology Highlights
- **Language**: Swift 5.10 / Swift 6 ready
- **Framework**: SwiftUI with iOS 17 Observation framework
- **Maps**: MapKit with dynamic annotations, polyline overlays, and coordinate interpolation
- **Design System**: Custom East African Modernist typography featuring *Instrument Serif* and *Archivo*, and signature cayenne red accent palette
- **Backend Integration**: Dual repository architecture:
  - **Supabase Swift SDK**: PostgreSQL, Row-Level Security, Database functions, and Auth.
  - **Offline Mock Fallback**: Automatic failover ensures seamless offline development and instant interactive demo capabilities.
- **Build System**: Native Xcode Project (`Jikoni.xcodeproj`) and optional [XcodeGen](https://github.com/yonaskolb/XcodeGen) support via `project.yml`.

---

## Getting Started

### Prerequisites
- macOS 14.0+ (Sonoma or Sequoia)
- Xcode 15.0+ or Xcode 16.0+
- iOS 17.0+ Simulator or physical device

### Running the App
1. **Clone the repository:**
   ```bash
   git clone https://github.com/sirbor/Jikoni.git
   cd Jikoni
   ```

2. **Open the project in Xcode:**
   ```bash
   open Jikoni.xcodeproj
   ```

3. **Select Scheme and Destination:**
   - Choose the `Jikoni` scheme.
   - Select any iOS 17+ Simulator (e.g., iPhone 15 Pro, iPhone 16 Pro, iPhone 17 Pro).

4. **Build and Run:**
   - Press `Cmd + R` to compile and run.

### Optional Supabase Backend Setup
To connect to a live Supabase instance instead of the in-memory fallback:
1. Copy `Jikoni/Secrets.example.plist` to `Jikoni/Secrets.plist`.
2. Fill in your project URL and anon public key:
   ```xml
   <key>SUPABASE_URL</key>
   <string>https://your-project.supabase.co</string>
   <key>SUPABASE_ANON_KEY</key>
   <string>your-anon-key</string>
   ```
3. Run the SQL migrations located in `supabase/schema.sql` and `supabase/seed_recipes.sql` on your Supabase dashboard.

---

## Author & Acknowledgements

- **Developer**: Dominic Bor ([@sirbor](https://github.com/sirbor))
- **Typography**: *Instrument Serif* by Instrument, *Archivo* by Omnibus-Type
- **Inspiration**: Nairobi's vibrant culinary ecosystem, Swahili coastal kitchens, and modern East African cuisine.
