# Jikoni (iOS)

**Jikoni** (Swahili for "Kitchen") is a high-fidelity iOS application designed to bridge the gap between home-cooked inspiration and local commerce. It serves as a circular food economy platform where users can discover artisanal recipes from around the world, instantly source ingredients from local vendors, and track their deliveries in real-time.

---

## The Concept: "RecipeDash"
Jikoni is a hybrid of a social recipe community (like Cookpad) and a high-efficiency delivery marketplace (like DoorDash). 

1.  **Discover**: Find authentic recipes (Carbonara, Ramen, Adana Kebab, etc.).
2.  **Shop**: One-tap addition of ingredients to a unified, multi-vendor cart.
3.  **Create**: Follow step-by-step instructions optimized for mobile viewing.
4.  **Track**: Watch your ingredients arrive with live MapKit-powered delivery tracking.

---

##  Key Features

### 1. Recipe Feed
*   **Global Catalog**: Over 20+ artisanal cuisines including Mediterranean, Turkish, Georgian, Chinese, and Italian.
*   **High-Res Imagery**: Immersive visuals powered by Unsplash.
*   **Interactive Details**: Perfectly fitted recipe layouts with wrapped text, difficulty ratings, and cook times.
*   **Threaded Conversations**: A community review system for sharing culinary tips.

### 2. Marketplace & Vendor Network
*   **30+ Local Partners**: A directory of specialty butchers, organic supermarkets, spice markets, and flea markets.
*   **Cuisine Matching**: Intelligent linking between recipe ingredients and local shops specializing in those items.
*   **Smart Grid**: A responsive, non-overlapping vendor exploration layout with Map/Grid toggles.

### 3. Unified Commerce & Wishlist
*   **Consolidated Hub**: A single tab managing both your active **Shopping Cart** and your **Digital Cookbook** (Wishlist).
*   **Multi-Vendor Checkout**: Grouped items by store with automated delivery fee calculations.
*   **Seamless Ordering**: A frictionless flow from recipe discovery to payment.

### 4. Logistics & Live Tracking
*   **Adaptive Overlay**: A minimized tracking widget that only appears when an order is active.
*   **Live MapKit Integration**: Real-time courier movement simulation and order lifecycle management (Placed → Delivering → Completed).

---

## Tech Stack

*   **UI Framework**: SwiftUI (Targeting iOS 17.0+)
*   **Architecture**: Clean Architecture (Domain, Data, Presentation) + MVVM
*   **State Management**: Native `@Observable` framework (Observation)
*   **Concurrency**: Swift Structured Concurrency (`async/await`, `Tasks`)
*   **Database**: SwiftData (Architected for local recipe drafts and archiving)
*   **Maps**: MapKit (iOS 17 `Map` API)
*   **Networking**: Generic `NetworkManager` wrapper for `URLSession`
*   **Design System**: "Rich Aesthetic" featuring `ultraThinMaterial`, custom gradients, and 20pt+ corner radiuses.
*   **Persistence**: `@AppStorage` for user preferences (Dark Mode, Language).

---

##  Design Philosophy
Jikoni is built for the modern user who values both aesthetics and performance:
*   **Dark Mode Ready**: Full support for system-wide appearance changes using dynamic semantic colors.
*   **Page-Fitted Content**: Zero text overlap ensures recipes are readable even on smaller devices.
*   **Snappy UX**: Optimized mock repositories with ultra-low latency for an "instant" app feel.

---

##  Getting Started

1.  **Generate Project**: `xcodegen generate`
2.  **Open in Xcode**: `open Jikoni.xcodeproj`
3.  **Run**: Select an iPhone 15/16 Simulator and press `Cmd + R`.

---

*Developed by the Dominic Bor.*
