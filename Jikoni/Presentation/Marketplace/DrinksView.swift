import SwiftUI

struct DrinksView: View {
    @Bindable var viewModel: MarketplaceViewModel
    @State private var selectedCategory: String = "All"
    
    let categories = ["All", "Cocktail", "Mocktail", "Lemonade", "Milkshake", "Caffeine", "Beer"]
    
    var allDrinks: [(vendor: Vendor, drink: Ingredient)] {
        var drinks: [(vendor: Vendor, drink: Ingredient)] = []
        for vendor in viewModel.vendors {
            if let vendorDrinks = vendor.inventory?["Drinks"] {
                for drink in vendorDrinks {
                    if selectedCategory == "All" || drink.amount == selectedCategory {
                        drinks.append((vendor, drink))
                    }
                }
            }
        }
        return drinks.sorted { $0.drink.name < $1.drink.name }
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Category Picker
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(categories, id: \.self) { category in
                                    Button {
                                        withAnimation(.spring()) { selectedCategory = category }
                                    } label: {
                                        Text(category)
                                            .font(.system(size: 14, weight: .bold, design: .rounded))
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(selectedCategory == category ? Color(hex: "D4AF37") : Color.gray.opacity(0.1))
                                            .foregroundStyle(selectedCategory == category ? .black : .primary)
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Drinks Grid
                        LazyVStack(spacing: 16) {
                            ForEach(allDrinks, id: \.drink.id) { item in
                                drinkRow(item.drink, from: item.vendor)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
                .background(Color(.systemGroupedBackground))
                
                FloatingCartButton(viewModel: viewModel)
                    .padding(.bottom, 20)
            }
            .navigationTitle("Bar & Drinks")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Drinks")
                        .font(.custom("Georgia-Bold", size: 24))
                }
            }
        }
    }
    
    private func drinkRow(_ drink: Ingredient, from vendor: Vendor) -> some View {
        HStack(spacing: 16) {
            // Drink Icon based on type
            ZStack {
                Circle()
                    .fill(Color(hex: "D4AF37").opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: iconForCategory(drink.amount))
                    .foregroundStyle(Color(hex: "D4AF37"))
                    .font(.title3)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(drink.name)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                
                HStack {
                    Text(vendor.name)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("•")
                    Text(drink.amount)
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color(hex: "D4AF37").opacity(0.2))
                        .foregroundStyle(Color(hex: "D4AF37"))
                        .clipShape(Capsule())
                }
            }
            
            Spacer()
            
            Button {
                viewModel.addToCart(ingredient: drink)
            } label: {
                Text("$\(drink.price.formatted())")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.black)
                    .foregroundStyle(Color(hex: "D4AF37"))
                    .clipShape(Capsule())
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: "D4AF37").opacity(0.1), lineWidth: 0.5)
        )
    }
    
    private func iconForCategory(_ category: String) -> String {
        switch category {
        case "Cocktail": return "wineglass.fill"
        case "Mocktail": return "drop.fill"
        case "Lemonade": return "leaf.fill"
        case "Milkshake": return "cup.and.saucer.fill"
        case "Caffeine": return "cup.and.saucer.fill"
        case "Beer": return "mug.fill"
        default: return "plus.circle.fill"
        }
    }
}
