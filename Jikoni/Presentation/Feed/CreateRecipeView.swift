import SwiftUI

/// Dish → ingredients → publish. Nothing here is decorative: the ingredient
/// and instruction lists are what actually get posted to `feedViewModel`.
struct CreateRecipeView: View {
    @Environment(FeedViewModel.self) private var feedViewModel
    @Environment(HubViewModel.self) private var hubViewModel
    @Environment(\.dismiss) private var dismiss

    private enum Step: Int, CaseIterable { case dish, ingredients, publish }
    @State private var step: Step = .dish

    @State private var title = ""
    @State private var description = ""
    @State private var imageUrl = ""

    @State private var ingredients: [Ingredient] = []
    @State private var draftIngredientName = ""
    @State private var draftIngredientAmount = ""
    @State private var draftIngredientPrice = ""

    @State private var instructions: [String] = []
    @State private var draftInstruction = ""

    @State private var isPublishing = false

    private var canAdvanceFromDish: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            stepDots

            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    switch step {
                    case .dish: dishStep
                    case .ingredients: ingredientsStep
                    case .publish: publishStep
                    }
                }
                .padding(18)
                .padding(.bottom, 100)
            }
        }
        .background(JikoniColor.ground.ignoresSafeArea())
        .overlay(alignment: .bottom) { bottomButton }
    }

    private var header: some View {
        HStack {
            JikoniCircleButton(
                systemImage: step == .dish ? "xmark" : "chevron.left",
                accessibilityText: step == .dish ? "Close" : "Back"
            ) {
                if step == .dish {
                    dismiss()
                } else {
                    step = Step(rawValue: step.rawValue - 1) ?? .dish
                }
            }
            Spacer()
            Text("New recipe")
                .font(JikoniFont.archivo(15, weight: .extrabold))
                .foregroundStyle(JikoniColor.ink)
            Spacer()
            Color.clear.frame(width: 44, height: 44)
        }
        .padding(.horizontal, 18)
        .padding(.top, 12)
    }

    private var stepDots: some View {
        HStack(spacing: 6) {
            ForEach(Step.allCases, id: \.self) { s in
                Capsule()
                    .fill(s.rawValue <= step.rawValue ? JikoniColor.ink : JikoniColor.placeholder)
                    .frame(height: 4)
            }
        }
        .padding(.horizontal, 18)
        .padding(.top, 14)
    }

    // MARK: - Step 1: Dish

    private var dishStep: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("What's the dish?")
                .font(JikoniFont.instrumentSerif(28))
                .foregroundStyle(JikoniColor.ink)

            labeledField("Title") {
                TextField("e.g. Nyama Choma with Kachumbari", text: $title)
                    .font(JikoniFont.archivo(14))
            }
            labeledField("Description") {
                TextField("What makes this dish worth cooking?", text: $description, axis: .vertical)
                    .lineLimit(3...6)
                    .font(JikoniFont.archivo(14))
            }
            labeledField("Photo URL (optional)") {
                TextField("https://…", text: $imageUrl)
                    .font(JikoniFont.archivo(14))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            }
        }
    }

    // MARK: - Step 2: Ingredients

    private var ingredientsStep: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("What goes in it?")
                .font(JikoniFont.instrumentSerif(28))
                .foregroundStyle(JikoniColor.ink)

            if !ingredients.isEmpty {
                VStack(spacing: 10) {
                    ForEach(Array(ingredients.enumerated()), id: \.offset) { index, ingredient in
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text(ingredient.name).font(JikoniFont.archivo(13.5, weight: .extrabold)).foregroundStyle(JikoniColor.ink)
                                Text(ingredient.amount).font(JikoniFont.archivo(11.5)).foregroundStyle(JikoniColor.textSecondary)
                            }
                            Spacer()
                            Text(ingredient.price.currencyString())
                                .font(JikoniFont.archivo(12.5, weight: .extrabold))
                                .foregroundStyle(JikoniColor.ink)
                            Button { ingredients.remove(at: index) } label: {
                                Image(systemName: "trash").foregroundStyle(.red.opacity(0.7))
                            }
                        }
                        .padding(14)
                        .background(JikoniColor.card)
                        .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.control))
                        .jikoniShadow(.small)
                    }
                }
            }

            VStack(spacing: 10) {
                TextField("Ingredient name", text: $draftIngredientName)
                TextField("Amount (e.g. 2 cups)", text: $draftIngredientAmount)
                TextField("Price contribution (KSh)", text: $draftIngredientPrice)
                    .keyboardType(.decimalPad)
            }
            .textFieldStyle(.roundedBorder)
            .padding(16)
            .background(JikoniColor.card)
            .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.card))
            .jikoniShadow(.small)

            Button {
                addDraftIngredient()
            } label: {
                Text("Add ingredient")
                    .font(JikoniFont.archivo(13, weight: .extrabold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(JikoniColor.ground)
                    .foregroundStyle(JikoniColor.ink)
                    .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.pill))
            }
            .disabled(draftIngredientName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
    }

    private func addDraftIngredient() {
        let name = draftIngredientName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return }
        let amount = draftIngredientAmount.trimmingCharacters(in: .whitespacesAndNewlines)
        // The "(KSh)" field takes a real shilling amount; `Ingredient.price` is
        // stored pre-scaled (see `Double.currencyString()`, which multiplies by
        // 100 for display) — divide here so what the user typed is what shows.
        let enteredKSh = Double(draftIngredientPrice.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
        ingredients.append(Ingredient(name: name, amount: amount.isEmpty ? "1" : amount, price: enteredKSh / 100, vendorId: nil))
        draftIngredientName = ""
        draftIngredientAmount = ""
        draftIngredientPrice = ""
    }

    // MARK: - Step 3: Publish

    private var publishStep: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("How's it made?")
                .font(JikoniFont.instrumentSerif(28))
                .foregroundStyle(JikoniColor.ink)

            if !instructions.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(Array(instructions.enumerated()), id: \.offset) { index, step in
                        HStack(alignment: .top, spacing: 12) {
                            Text("\(index + 1)")
                                .font(JikoniFont.archivo(11, weight: .extrabold))
                                .foregroundStyle(JikoniColor.ground)
                                .frame(width: 24, height: 24)
                                .background(JikoniColor.ink)
                                .clipShape(Circle())
                            Text(step)
                                .font(JikoniFont.archivo(13))
                                .foregroundStyle(JikoniColor.textBody)
                            Spacer()
                            Button { instructions.remove(at: index) } label: {
                                Image(systemName: "trash").foregroundStyle(.red.opacity(0.7))
                            }
                        }
                    }
                }
            }

            HStack(spacing: 10) {
                TextField("Add a step", text: $draftInstruction, axis: .vertical)
                    .font(JikoniFont.archivo(13.5))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(JikoniColor.card)
                    .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.control))
                    .jikoniShadow(.small)
                Button {
                    let trimmed = draftInstruction.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmed.isEmpty else { return }
                    instructions.append(trimmed)
                    draftInstruction = ""
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(JikoniColor.ground)
                        .frame(width: 44, height: 44)
                        .background(JikoniColor.ink)
                        .clipShape(Circle())
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("READY TO PUBLISH")
                    .font(JikoniFont.archivo(10.5, weight: .extrabold))
                    .foregroundStyle(JikoniColor.textSecondary)
                Text("\(title.isEmpty ? "Untitled dish" : title) · \(ingredients.count) ingredients · \(instructions.count) steps")
                    .font(JikoniFont.archivo(12.5))
                    .foregroundStyle(JikoniColor.ink)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(JikoniColor.card)
            .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.card))
            .jikoniShadow(.small)
        }
    }

    // MARK: - Shared

    private func labeledField(_ label: String, @ViewBuilder field: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label.uppercased())
                .font(JikoniFont.archivo(10.5, weight: .extrabold))
                .foregroundStyle(JikoniColor.textSecondary)
            field()
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(JikoniColor.card)
                .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.control))
                .jikoniShadow(.small)
        }
    }

    private var bottomButton: some View {
        Button {
            switch step {
            case .dish: step = .ingredients
            case .ingredients: step = .publish
            case .publish: Task { await publish() }
            }
        } label: {
            Text(buttonLabel)
                .font(JikoniFont.archivo(14.5, weight: .extrabold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(JikoniColor.ink)
                .foregroundStyle(JikoniColor.ground)
                .clipShape(Capsule())
        }
        .disabled((step == .dish && !canAdvanceFromDish) || isPublishing)
        .padding(.horizontal, 18)
        .padding(.bottom, 20)
    }

    private var buttonLabel: String {
        switch step {
        case .dish: return "Next: Ingredients"
        case .ingredients: return "Next: Method"
        case .publish: return isPublishing ? "Publishing…" : "Publish recipe"
        }
    }

    private func publish() async {
        isPublishing = true
        let recipe = Recipe(
            id: UUID().uuidString,
            title: title,
            author: hubViewModel.currentUser?.displayName ?? "Jikoni cook",
            vendorId: "",
            imageUrls: imageUrl.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? [] : [imageUrl],
            description: description,
            ingredients: ingredients,
            instructions: instructions,
            likes: 0,
            isLikedByMe: false,
            comments: []
        )
        await feedViewModel.createRecipe(recipe)
        await hubViewModel.updateCurrentUser { user in
            user.recipesCount += 1
            user.loyaltyPoints += 50
        }
        isPublishing = false
        dismiss()
    }
}
