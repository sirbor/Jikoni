# Jikoni Roadmap

## About Jikoni

**Jikoni** ("kitchen" in Swahili) is a premium food-and-recipe platform for Nairobi that fuses two experiences into one app: a **social recipe feed** for culinary inspiration and a **restaurant delivery marketplace** for acting on it. Users scroll global recipes shared by home cooks and chefs, save favorites to a personal cookbook, then pivot straight into ordering the ingredients — or the finished dish — from a curated list of local restaurants, tracking the courier in real time on a map until it arrives.

The app targets a "local luxury commerce" niche: polished restaurant profiles (hygiene ratings, dietary tags, price tiers, curated photography), a loyalty/membership system (bronze → platinum, points, referral codes), and an upscale visual identity (gold accent, editorial typography) that differentiates it from a generic delivery app.

The current codebase is a SwiftUI app built with Clean Architecture (Domain / Data / Presentation), running entirely on richly-authored mock data — the full user journey (discovery, cart, checkout, live tracking, order history, profile/loyalty) is demoable end-to-end without a backend. This document tracks what's needed to take it from demo to a fully functional product.

---

## Design — "Modernist" Visual Redesign

A full design canvas ("Modernist") now exists covering 14 screens end-to-end (welcome, feed, recipe, cookbook, recipe authoring, marketplace, vendor, item detail, cart, address, M-Pesa payment, live tracking, orders, profile) plus a reusable component/token system. It replaces the current black/gold glassmorphism identity with: an ink (`#201e1d`) + warm-grey-ground system, red (`#ec3013`) rationed to live/likes/chosen states only, Archivo for UI text with Instrument Serif reserved for recipe titles, pill-shaped controls, and soft large-radius cards with no borders. Tab structure moves from Home/Delivery/Beverages/Profile to Feed/Order/Track/You, with recipes as the front door and a one-tap bridge into ordering.

This is a sequencing decision, not just a reskin — it changes navigation structure and screen inventory, so it's worth landing before too much new backend-driven UI is built on the current identity.

*Codebase-verified 2026-09-13: the app was fully stripped and rebuilt (not reskinned) to match the canvas's actual layouts — custom tab bar/header/row chrome replacing native TabView/NavigationStack/List — and every item below was checked against source and screenshot-verified on the simulator with live Supabase data, including the full checkout chain (item detail → cart → M-Pesa payment). Two known gaps found and left open rather than silently claimed done: the SwiftUI launch screen (`LaunchScreenView`/`JikoniLogo`) still embeds the old ornate gold "JIKONI RESTAURANT" crest image, which clashes with the ink+serif identity everywhere else — the splash isn't part of the canvas's 14-screen inventory, so there's no source design to rebuild it against; and M-Pesa's Daraja API call itself (tracked separately in Phase 2).*

- [x] Port design tokens (colors, type scale, radii, shadow ramp) into the SwiftUI app, replacing `Color(hex:)` gold gradients in `JikoniButton`/`JikoniLogo` — `JikoniButton` deleted as dead code; `JikoniLogo` rebuilt on ink/Instrument Serif (raster crest asset still outdated, see note above)
- [x] Reconcile the canvas's 14-screen inventory against existing views (`ExploreView`, `DrinksView`, `CartAndWishlistView`, `PaymentVaultView`, `RewardsView`, `SupportCenterView`, `AddressVaultView`, `OrderHistoryView`) — decide what merges, what's cut, what's net-new
- [x] Restructure tab bar from Home/Delivery/Beverages/Profile to Feed/Order/Track/You
- [x] Build the recipe-authoring wizard (dish → ingredients → publish) to spec — feeds directly into the Phase 3 recipe authoring item below
- [x] Build the explicit multi-kitchen cart-conflict sheet (new basket / keep existing / schedule separately) to spec — resolves the Phase 2 cart-handling item below
- [x] Build M-Pesa payment as a state machine (idle → pending with countdown/resend/`*334#` fallback → done with receipt) to spec — UI layer for the Phase 2 M-Pesa integration item below
- [x] Servings-scaling ingredient recompute on the recipe detail screen
- [x] Reorder flow that re-prices against current menu rather than replaying the stale order price

## Phase 1 — Backend Foundation (blocking everything else)

*Codebase-verified 2026-09-12: every mock-behavior claim in Phases 1–3 below (repository protocol shapes, `NetworkManager` being unused, in-memory-only session, M-Pesa UI-without-Daraja-call, silent cart wipe in `enforceSingleRestaurantCart()`, unpriced `reorder()`, hardcoded Unsplash URLs, random `generateRewardCode()`, local-only `deleteAccountData()`, the unbounded `while true` in `HubViewModel.observeOrders()`, and the absence of a `Tests` target) was checked directly against source, not just asserted.*

*Codebase-verified 2026-09-13: Supabase backend now exists for real and was exercised end-to-end on the simulator (seeded vendor/menu data through checkout). One critical wiring bug was found and fixed in this pass: `TrackingViewModel.startTracking()` queried orders with a hardcoded `"current-user"` string instead of the signed-in user's real UUID, so live order tracking could never match a real order regardless of backend state — it now takes the real user id reactively and restarts on sign-in/out.*

Nothing in later phases works for real users until this exists.

- [x] API backend (REST/GraphQL) and database (Postgres/Firebase/Supabase) for vendors, menus, orders, users, recipes — Supabase, schema in `supabase/schema.sql`
- [x] Replace `Mock*Repository` implementations with real network-backed repositories (protocol boundaries already support this swap) — `RepositoryFactory` swaps in `Supabase*Repository` whenever `Secrets.plist` is configured, `Mock*Repository` otherwise; verified both paths
- [ ] Wire up / replace `NetworkManager` with retry, auth-header injection, and error mapping — `NetworkManager` deleted as dead code; the Supabase SDK handles auth headers, but there's still no custom retry/error-mapping layer over `client.from(...)` calls
- [x] Real authentication (phone OTP for the Kenyan market) — real `client.auth.signInWithOTP`/`verifyOTP`; Sign in with Apple and email+password still out of scope
- [x] Session persistence (session now lives in Supabase's `client.auth.session`, restored via `restoreSession()`, not in-memory-only) — token *refresh* behavior not separately verified
- [ ] Image upload/hosting pipeline for recipe photos and reviews (currently hardcoded Unsplash URLs)

## Phase 2 — MVP Launch (core transaction loop)

The minimum needed to let a real user discover, pay for, and receive food.

- [ ] M-Pesa STK Push integration via Safaricom Daraja API (UI already references it; nothing calls it yet)
- [ ] Card payment processor integration (Stripe/Flutterwave/Paystack)
- [ ] Server-side promo/discount engine (codes are currently hardcoded client-side)
- [ ] Real-time order status pushed from a restaurant/rider system (currently simulated via `AsyncStream` in the mock repo)
- [ ] Push notifications for order status changes (order confirmed, rider assigned, arriving) via APNs
- [ ] Live courier GPS feed from a rider app, replacing interpolated mock coordinates
- [ ] Inventory/availability sync so out-of-stock or closed-vendor items can't be ordered
- [ ] Explicit UX decision + implementation for multi-restaurant cart handling (currently silently wipes cart on vendor switch)
- [ ] Password reset, email verification, account recovery
- [ ] Real account deletion via backend API (currently just redacts fields locally)
- [ ] Automated test suite: unit tests for cart/pricing math and view models, contract tests for repositories, UI tests for checkout and tracking flows (no `Tests` target exists today)
- [ ] Fix `AsyncStream`/`Task` lifecycle management — `HubViewModel.observeOrders()`'s infinite loop needs cancellation on sign-out/background

## Phase 3 — Post-Launch Growth (retention & social)

Features that deepen engagement once the core loop is proven.

- [ ] Recipe authoring flow (upload photo, ingredients, steps) — models (`Recipe`, `Comment` with nested replies) already support it
- [ ] Follow/followers graph enforcement (counts exist on `User` but nothing updates them)
- [ ] Comment posting/threading UI with server-side persistence
- [ ] Recipe search/discovery by ingredient, cuisine, or dietary tag
- [ ] Vendor review submission gated to verified completed orders, with photo attachments
- [ ] Review and content moderation/reporting flow for recipes, photos, and reviews
- [ ] Real loyalty point accrual/redemption logic (currently `generateRewardCode()` returns a random string)
- [ ] Scheduled delivery (`scheduledDelivery` field exists in the view model but nothing acts on it)
- [ ] Order modification/cancellation window, and post-dispatch tip adjustments
- [ ] ETA recalculation from live traffic via MapKit directions API, replacing static `estimatedDeliveryMinutes`
- [ ] Email/SMS notifications respecting `preferredContact` and `allowsPromotionalEmails`

## Phase 4 — Scale & Operations

Needed to operate the business, not just the app.

- [ ] Vendor-facing dashboard/app for menu management, order acceptance, and hours
- [ ] Rider-facing app for delivery assignment and navigation
- [ ] Internal admin panel for support, refunds, content moderation, and vendor onboarding
- [ ] Server-side search/filtering once vendor counts exceed what client-side filtering can handle
- [ ] Crash reporting and product analytics (Sentry, Firebase Crashlytics) for funnel drop-off
- [ ] Accessibility pass (VoiceOver labels, Dynamic Type, contrast)
- [ ] Localization (English/Swahili at minimum)
- [ ] CI pipeline (build, lint, test) and release automation (fastlane or similar)

---

*Last updated: 2026-09-13*
