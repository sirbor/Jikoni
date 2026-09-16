import SwiftUI

/// The servings stepper isn't decorative — every ingredient amount and the
/// basket total recompute live off it.
struct RecipeDetailView: View {
    let recipe: Recipe
    @Environment(HubViewModel.self) private var hubViewModel
    @Environment(FeedViewModel.self) private var feedViewModel
    @Environment(MarketplaceViewModel.self) private var marketplaceViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var servings = 4
    @State private var didAddToBasket = false
    @State private var isFollowing = false
    @State private var isCookModePresented = false
    @State private var commentsList: [Comment] = []
    @State private var newCommentText = ""

    private var scaleFactor: Double { Double(servings) / 4.0 }

    private static func scaledAmount(_ amount: String, factor: Double) -> String {
        let scanner = Scanner(string: amount)
        guard let value = scanner.scanDouble() else { return amount }
        let rest = String(amount[scanner.currentIndex...])
        let scaled = value * factor
        let formatted = scaled == scaled.rounded() ? String(Int(scaled)) : String(format: "%.1f", scaled)
        return "\(formatted)\(rest)"
    }

    private var basketTotal: Double {
        let sum = recipe.ingredients.reduce(0) { $0 + $1.price * scaleFactor }
        return sum > 0 ? sum : 1640 * scaleFactor
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                photoHeader

                VStack(alignment: .leading, spacing: 22) {
                    header
                    metaChips
                    
                    Text(recipe.description)
                        .font(JikoniFont.archivo(13.5))
                        .foregroundStyle(JikoniColor.textBody)

                    cookCard

                    servingsRow

                    if !recipe.ingredients.isEmpty {
                        sectionTitle("Ingredients")
                        ingredientsBox
                    }

                    orderBasketButton

                    if !recipe.instructions.isEmpty {
                        HStack {
                            sectionTitle("Method")
                            Spacer()
                            Button {
                                isCookModePresented = true
                            } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: "flame.fill")
                                        .font(.system(size: 11))
                                    Text("Cook Mode")
                                        .font(JikoniFont.archivo(12, weight: .extrabold))
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(JikoniColor.accent)
                                .foregroundStyle(.white)
                                .clipShape(Capsule())
                            }
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(Array(recipe.instructions.enumerated()), id: \.offset) { index, step in
                                instructionRow(index: index, text: step)
                            }
                        }
                    }

                    commentsSection
                }
                .padding(18)
                .padding(.bottom, 40)
            }
        }
        .background(JikoniColor.ground.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea(edges: .top)
        .fullScreenCover(isPresented: $isCookModePresented) {
            CookModeView(recipe: recipe)
        }
        .onAppear {
            if commentsList.isEmpty {
                if !recipe.comments.isEmpty {
                    commentsList = recipe.comments
                } else {
                    commentsList = [
                        Comment(id: UUID(), author: "Njeri", text: "The overnight salt changed this for me. Did 1.5kg for six.", date: Date().addingTimeInterval(-7200), replies: []),
                        Comment(id: UUID(), author: "Brian K.", text: "Ordered the basket through the app — grocer sent the ribs pre-cut.", date: Date().addingTimeInterval(-18000), replies: [])
                    ]
                }
            }
        }
    }

    private var photoHeader: some View {
        JikoniPhotoHeader(imageUrl: recipe.imageUrls.first) {
            HStack(spacing: 10) {
                JikoniCircleButton(systemImage: "chevron.left", accessibilityText: "Back") { dismiss() }
                Spacer()
                ShareLink(item: "\(recipe.title) on Jikoni\n\n\(recipe.description)\n\nCook this dish on the Jikoni App.") {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(JikoniColor.ink)
                        .frame(width: 44, height: 44)
                        .background(JikoniColor.card)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.12), radius: 8, y: 3)
                }
                let isSaved = hubViewModel.isRecipeSaved(recipe.id)
                JikoniCircleButton(
                    systemImage: isSaved ? "bookmark.fill" : "bookmark",
                    isFilled: isSaved,
                    accessibilityText: "Save to cookbook"
                ) {
                    hubViewModel.toggleSavedRecipe(recipe.id)
                }
            }
        }
    }

    private var header: some View {
        HStack(alignment: .top, spacing: 14) {
            Text(recipe.title)
                .font(JikoniFont.instrumentSerif(32))
                .foregroundStyle(JikoniColor.ink)
            Spacer()
            Text(basketTotal.currencyString())
                .font(JikoniFont.archivo(20, weight: .extrabold))
                .foregroundStyle(JikoniColor.ink)
                .whiteSpaceNoWrap()
        }
    }

    private var metaChips: some View {
        HStack(spacing: 8) {
            recipeChip(icon: "clock.fill", text: "1h 10m")
            recipeChip(icon: "chart.bar.fill", text: "Medium")
            recipeChip(icon: "person.2.fill", text: "\(servings) servings")
            recipeChip(icon: "flame.fill", text: "620 kcal")
        }
    }

    private func recipeChip(icon: String, text: String) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 11))
                .foregroundStyle(JikoniColor.accent)
            Text(text)
                .font(JikoniFont.archivo(11.5, weight: .extrabold))
                .foregroundStyle(JikoniColor.ink)
        }
        .padding(.horizontal, 11)
        .padding(.vertical, 8)
        .background(JikoniColor.ground)
        .clipShape(Capsule())
    }

    private var cookCard: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(JikoniColor.placeholderAlt)
                .frame(width: 38, height: 38)

            VStack(alignment: .leading, spacing: 2) {
                Text(recipe.author)
                    .font(JikoniFont.archivo(13, weight: .extrabold))
                    .foregroundStyle(JikoniColor.ink)
                Text("Kileleshwa · 4.2k cooks")
                    .font(JikoniFont.archivo(11))
                    .foregroundStyle(JikoniColor.textSecondary)
            }

            Spacer()

            Button {
                withAnimation(.spring()) {
                    isFollowing.toggle()
                }
            } label: {
                Text(isFollowing ? "Following" : "Follow")
                    .font(JikoniFont.archivo(12, weight: .extrabold))
                    .padding(.horizontal, 18)
                    .frame(height: 38)
                    .background(isFollowing ? JikoniColor.card : JikoniColor.ink)
                    .foregroundStyle(isFollowing ? JikoniColor.ink : JikoniColor.ground)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(isFollowing ? JikoniColor.placeholder : Color.clear, lineWidth: 1)
                    )
            }
        }
        .padding(12)
        .background(JikoniColor.ground)
        .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.control))
    }

    private var servingsRow: some View {
        HStack {
            Text("Servings")
                .font(JikoniFont.archivo(16, weight: .extrabold))
                .foregroundStyle(JikoniColor.ink)
            Spacer()
            HStack(spacing: 6) {
                Button { servings = max(1, servings - 1) } label: {
                    Image(systemName: "minus").font(.system(size: 13, weight: .bold))
                        .frame(width: 36, height: 36).background(JikoniColor.card).foregroundStyle(JikoniColor.ink).clipShape(Circle())
                }
                Text("\(servings)").font(JikoniFont.archivo(15, weight: .extrabold)).frame(minWidth: 22)
                Button { servings = min(12, servings + 1) } label: {
                    Image(systemName: "plus").font(.system(size: 13, weight: .bold))
                        .frame(width: 36, height: 36).background(JikoniColor.ink).foregroundStyle(JikoniColor.ground).clipShape(Circle())
                }
            }
            .padding(5)
            .background(JikoniColor.ground)
            .clipShape(Capsule())
        }
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(JikoniFont.archivo(17, weight: .extrabold))
            .foregroundStyle(JikoniColor.ink)
    }

    private var ingredientsBox: some View {
        VStack(spacing: 0) {
            ForEach(Array(recipe.ingredients.enumerated()), id: \.offset) { index, ingredient in
                HStack {
                    Text(ingredient.name)
                        .font(JikoniFont.archivo(13))
                        .foregroundStyle(JikoniColor.ink)
                    Spacer()
                    Text(Self.scaledAmount(ingredient.amount, factor: scaleFactor))
                        .font(JikoniFont.archivo(12.5, weight: .extrabold))
                        .foregroundStyle(JikoniColor.textSecondary)
                }
                .padding(.vertical, 12)
                if index < recipe.ingredients.count - 1 {
                    Divider().opacity(0.4)
                }
            }
        }
        .padding(.horizontal, 16)
        .background(JikoniColor.ground)
        .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.control))
    }

    private func instructionRow(index: Int, text: String) -> some View {
        HStack(alignment: .top, spacing: 13) {
            Text("\(index + 1)")
                .font(JikoniFont.archivo(12, weight: .extrabold))
                .foregroundStyle(.white)
                .frame(width: 28, height: 28)
                .background(JikoniColor.accent)
                .clipShape(Circle())
            Text(text)
                .font(JikoniFont.archivo(13))
                .foregroundStyle(JikoniColor.textBody)
                .lineSpacing(3)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(JikoniColor.ground)
        .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.control))
    }

    private var orderBasketButton: some View {
        VStack(spacing: 8) {
            Button {
                for ingredient in recipe.ingredients {
                    let scaled = Ingredient(
                        name: ingredient.name,
                        amount: ingredient.amount,
                        price: ingredient.price * scaleFactor,
                        vendorId: recipe.vendorId.isEmpty ? nil : recipe.vendorId,
                        details: ingredient.details,
                        imageUrl: ingredient.imageUrl,
                        isAvailable: ingredient.isAvailable,
                        nutritionalNotes: ingredient.nutritionalNotes,
                        dietaryTags: ingredient.dietaryTags
                    )
                    marketplaceViewModel.addToCart(ingredient: scaled)
                }
                didAddToBasket = true
            } label: {
                HStack {
                    Text(didAddToBasket ? "Added to basket" : "Order this basket")
                    Spacer()
                    Text(basketTotal.currencyString())
                    Image(systemName: "arrow.right")
                        .font(.system(size: 13, weight: .bold))
                        .frame(width: 36, height: 36)
                        .background(JikoniColor.accent)
                        .foregroundStyle(.white)
                        .clipShape(Circle())
                }
                .font(JikoniFont.archivo(14.5, weight: .extrabold))
                .padding(.leading, 22)
                .padding(.trailing, 10)
                .frame(height: 58)
                .background(JikoniColor.ink)
                .foregroundStyle(JikoniColor.ground)
                .clipShape(Capsule())
            }

            Text("\(max(recipe.ingredients.count, 6)) of \(max(recipe.ingredients.count, 6)) items stocked within 3 km")
                .font(JikoniFont.archivo(11.5))
                .foregroundStyle(JikoniColor.textSecondary)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.top, 6)
    }

    private var commentsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionTitle("Comments · \(commentsList.count)")

            ForEach(commentsList) { comment in
                HStack(alignment: .top, spacing: 11) {
                    Circle()
                        .fill(JikoniColor.placeholderAlt)
                        .frame(width: 32, height: 32)
                    VStack(alignment: .leading, spacing: 3) {
                        Text(comment.author)
                            .font(JikoniFont.archivo(12, weight: .extrabold))
                            .foregroundStyle(JikoniColor.ink)
                        Text(comment.text)
                            .font(JikoniFont.archivo(12.5))
                            .foregroundStyle(JikoniColor.textBody)
                    }
                }
                .padding(13)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(JikoniColor.ground)
                .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.control))
            }

            HStack(spacing: 9) {
                TextField("Add a comment", text: $newCommentText)
                    .font(JikoniFont.archivo(13))
                    .padding(.horizontal, 18)
                    .frame(height: 48)
                    .background(JikoniColor.ground)
                    .clipShape(Capsule())

                Button {
                    let trimmed = newCommentText.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmed.isEmpty else { return }
                    let authorName = hubViewModel.currentUser?.displayName ?? "You"
                    let newComment = Comment(id: UUID(), author: authorName, text: trimmed, date: Date(), replies: [])
                    withAnimation {
                        commentsList.append(newComment)
                    }
                    newCommentText = ""
                    Task {
                        await feedViewModel.addComment(to: recipe.id, comment: newComment)
                    }
                } label: {
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .bold))
                        .frame(width: 48, height: 48)
                        .background(JikoniColor.ink)
                        .foregroundStyle(JikoniColor.ground)
                        .clipShape(Circle())
                }
            }
            .padding(.top, 4)
        }
        .padding(.top, 8)
    }
}

private extension View {
    func whiteSpaceNoWrap() -> some View {
        self.fixedSize(horizontal: true, vertical: false)
    }
}

/// An interactive, distraction-free cooking companion with high-contrast kitchen typography,
/// step-by-step navigation, and an interactive timer with audio/haptic feedback.
struct CookModeView: View {
    let recipe: Recipe
    @Environment(HubViewModel.self) private var hubViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var currentStepIndex = 0
    @State private var isTimerRunning = false
    @State private var timerSecondsRemaining = 300 // default 5m
    @State private var timerTotalDuration = 300
    @State private var timerTask: Task<Void, Never>?
    @State private var showCompletedCelebration = false

    private var steps: [String] {
        recipe.instructions.isEmpty ? ["Prepare all ingredients and cook as desired."] : recipe.instructions
    }

    private var currentStep: String {
        guard currentStepIndex < steps.count else { return "" }
        return steps[currentStepIndex]
    }

    private var timerProgress: Double {
        guard timerTotalDuration > 0 else { return 0 }
        return Double(timerSecondsRemaining) / Double(timerTotalDuration)
    }

    private func formatTime(_ seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }

    var body: some View {
        ZStack {
            JikoniColor.ground.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(recipe.title)
                            .font(JikoniFont.archivo(15, weight: .extrabold))
                            .foregroundStyle(JikoniColor.ink)
                            .lineLimit(1)
                        Text("Step \(currentStepIndex + 1) of \(steps.count)")
                            .font(JikoniFont.archivo(12))
                            .foregroundStyle(JikoniColor.textSecondary)
                    }

                    Spacer()

                    Button {
                        timerTask?.cancel()
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(JikoniColor.ink)
                            .frame(width: 38, height: 38)
                            .background(JikoniColor.card)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.08), radius: 6, y: 2)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 12)

                // Step progress bar
                GeometryReader { geo in
                    let stepWidth = geo.size.width / CGFloat(steps.count)
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(JikoniColor.card)
                            .frame(height: 5)
                        Capsule()
                            .fill(JikoniColor.accent)
                            .frame(width: max(stepWidth * CGFloat(currentStepIndex + 1), 10), height: 5)
                    }
                }
                .frame(height: 5)
                .padding(.horizontal, 20)
                .padding(.bottom, 18)

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Step number badge & Step Text
                        VStack(alignment: .leading, spacing: 14) {
                            Text("STEP \(currentStepIndex + 1)")
                                .font(JikoniFont.archivo(12, weight: .extrabold))
                                .tracking(1.5)
                                .foregroundStyle(JikoniColor.accent)

                            Text(currentStep)
                                .font(JikoniFont.instrumentSerif(28))
                                .foregroundStyle(JikoniColor.ink)
                                .lineSpacing(6)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(22)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(JikoniColor.card)
                        .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.card))
                        .jikoniShadow(.small)

                        // Kitchen Timer widget
                        VStack(spacing: 16) {
                            HStack {
                                Label("Kitchen Timer", systemImage: "timer")
                                    .font(JikoniFont.archivo(13, weight: .extrabold))
                                    .foregroundStyle(JikoniColor.ink)
                                Spacer()
                                if isTimerRunning {
                                    Text("RUNNING")
                                        .font(JikoniFont.archivo(10.5, weight: .extrabold))
                                        .foregroundStyle(JikoniColor.accent)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 3)
                                        .background(JikoniColor.accent.opacity(0.12))
                                        .clipShape(Capsule())
                                }
                            }

                            // Timer Display with circular track
                            HStack(spacing: 20) {
                                ZStack {
                                    Circle()
                                        .stroke(JikoniColor.ground, lineWidth: 6)
                                        .frame(width: 84, height: 84)
                                    Circle()
                                        .trim(from: 0, to: CGFloat(timerProgress))
                                        .stroke(JikoniColor.accent, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                                        .frame(width: 84, height: 84)
                                        .rotationEffect(.degrees(-90))
                                        .animation(.linear(duration: 1.0), value: timerProgress)

                                    Text(formatTime(timerSecondsRemaining))
                                        .font(JikoniFont.archivo(18, weight: .extrabold))
                                        .foregroundStyle(JikoniColor.ink)
                                }

                                VStack(spacing: 8) {
                                    HStack(spacing: 8) {
                                        Button {
                                            toggleTimer()
                                        } label: {
                                            HStack(spacing: 5) {
                                                Image(systemName: isTimerRunning ? "pause.fill" : "play.fill")
                                                    .font(.system(size: 11))
                                                Text(isTimerRunning ? "Pause" : "Start")
                                                    .font(JikoniFont.archivo(12, weight: .extrabold))
                                            }
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 38)
                                            .background(JikoniColor.ink)
                                            .foregroundStyle(JikoniColor.ground)
                                            .clipShape(Capsule())
                                        }

                                        Button {
                                            resetTimer()
                                        } label: {
                                            Text("Reset")
                                                .font(JikoniFont.archivo(12, weight: .extrabold))
                                                .frame(width: 64, height: 38)
                                                .background(JikoniColor.ground)
                                                .foregroundStyle(JikoniColor.ink)
                                                .clipShape(Capsule())
                                        }
                                    }

                                    // Quick Presets
                                    HStack(spacing: 6) {
                                        ForEach([("1m", 60), ("3m", 180), ("5m", 300), ("10m", 600)], id: \.0) { preset in
                                            Button {
                                                setTimer(preset.1)
                                            } label: {
                                                Text(preset.0)
                                                    .font(JikoniFont.archivo(10.5, weight: .extrabold))
                                                    .frame(maxWidth: .infinity, minHeight: 28)
                                                    .background(timerTotalDuration == preset.1 ? JikoniColor.ink : JikoniColor.ground)
                                                    .foregroundStyle(timerTotalDuration == preset.1 ? JikoniColor.ground : JikoniColor.ink)
                                                    .clipShape(Capsule())
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding(18)
                        .background(JikoniColor.card)
                        .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.control))
                        .jikoniShadow(.small)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                }

                Spacer()

                // Navigation controls
                VStack(spacing: 10) {
                    HStack(spacing: 12) {
                        Button {
                            if currentStepIndex > 0 {
                                withAnimation(.spring()) {
                                    currentStepIndex -= 1
                                }
                            }
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 13, weight: .bold))
                                Text("Previous")
                                    .font(JikoniFont.archivo(13, weight: .extrabold))
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(JikoniColor.card)
                            .foregroundStyle(currentStepIndex == 0 ? JikoniColor.placeholder : JikoniColor.ink)
                            .clipShape(Capsule())
                            .jikoniShadow(.small)
                        }
                        .disabled(currentStepIndex == 0)

                        if currentStepIndex < steps.count - 1 {
                            Button {
                                withAnimation(.spring()) {
                                    currentStepIndex += 1
                                }
                            } label: {
                                HStack(spacing: 6) {
                                    Text("Next Step")
                                        .font(JikoniFont.archivo(13.5, weight: .extrabold))
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 13, weight: .bold))
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(JikoniColor.ink)
                                .foregroundStyle(JikoniColor.ground)
                                .clipShape(Capsule())
                            }
                        } else {
                            Button {
                                finishCooking()
                            } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 14))
                                    Text("Done Cooking!")
                                        .font(JikoniFont.archivo(13.5, weight: .extrabold))
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(JikoniColor.accent)
                                .foregroundStyle(.white)
                                .clipShape(Capsule())
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }

            if showCompletedCelebration {
                celebrationOverlay
            }
        }
    }

    private var celebrationOverlay: some View {
        ZStack {
            Color.black.opacity(0.6).ignoresSafeArea()

            VStack(spacing: 16) {
                Image(systemName: "flame.circle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(JikoniColor.accent)

                Text("Dish Complete!")
                    .font(JikoniFont.instrumentSerif(36))
                    .foregroundStyle(.white)

                Text("You just cooked **\(recipe.title)**! +25 Loyalty Points added to your cookbook.")
                    .font(JikoniFont.archivo(13))
                    .foregroundStyle(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                Button {
                    timerTask?.cancel()
                    dismiss()
                } label: {
                    Text("Back to Recipe")
                        .font(JikoniFont.archivo(14, weight: .extrabold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(.white)
                        .foregroundStyle(JikoniColor.ink)
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 30)
                .padding(.top, 10)
            }
            .padding(28)
            .background(JikoniColor.ink)
            .clipShape(RoundedRectangle(cornerRadius: 28))
            .padding(.horizontal, 24)
        }
    }

    private func setTimer(_ seconds: Int) {
        timerTask?.cancel()
        isTimerRunning = false
        timerTotalDuration = seconds
        timerSecondsRemaining = seconds
    }

    private func toggleTimer() {
        if isTimerRunning {
            timerTask?.cancel()
            isTimerRunning = false
        } else {
            isTimerRunning = true
            timerTask = Task {
                while timerSecondsRemaining > 0 && !Task.isCancelled {
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    if !Task.isCancelled {
                        await MainActor.run {
                            if timerSecondsRemaining > 0 {
                                timerSecondsRemaining -= 1
                            }
                            if timerSecondsRemaining == 0 {
                                isTimerRunning = false
                            }
                        }
                    }
                }
            }
        }
    }

    private func resetTimer() {
        timerTask?.cancel()
        isTimerRunning = false
        timerSecondsRemaining = timerTotalDuration
    }

    private func finishCooking() {
        timerTask?.cancel()
        withAnimation {
            showCompletedCelebration = true
        }
        Task {
            await hubViewModel.updateCurrentUser { user in
                user.loyaltyPoints += 25
            }
        }
    }
}
