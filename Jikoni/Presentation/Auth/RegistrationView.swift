import SwiftUI

struct RegistrationView: View {
    let viewModel: HubViewModel
    @State private var step = 1
    @State private var name = ""
    @State private var skillLevel = "Amateur"
    @State private var dietaryGoals: Set<String> = []
    
    let skills = ["Amateur", "Home Cook", "Sous Chef", "Executive Chef"]
    let goals = ["Healthy", "Vegetarian", "Vegan", "Keto", "Paleo", "Gluten-Free", "Low-Carb"]
    
    var body: some View {
        NavigationStack {
            VStack {
                ProgressView(value: Double(step), total: 3.0)
                    .tint(.orange)
                    .padding()
                
                if step == 1 {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("What's your name?")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        TextField("Display Name", text: $name)
                            .font(.title2)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .padding()
                } else if step == 2 {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Choose your skill level")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        ForEach(skills, id: \.self) { skill in
                            Button(action: { skillLevel = skill }) {
                                HStack {
                                    Text(skill)
                                    Spacer()
                                    if skillLevel == skill {
                                        Image(systemName: "checkmark.circle.fill").foregroundStyle(.orange)
                                    }
                                }
                                .padding()
                                .background(skillLevel == skill ? Color.orange.opacity(0.1) : Color.gray.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay {
                                    if skillLevel == skill {
                                        RoundedRectangle(cornerRadius: 16).stroke(Color.orange, lineWidth: 2)
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                } else {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Your dietary goals")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        FlowLayout(items: goals) { goal in
                            Button(action: {
                                if dietaryGoals.contains(goal) {
                                    dietaryGoals.remove(goal)
                                } else {
                                    dietaryGoals.insert(goal)
                                }
                            }) {
                                Text(goal)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(dietaryGoals.contains(goal) ? Color.orange : Color.gray.opacity(0.1))
                                    .foregroundStyle(dietaryGoals.contains(goal) ? .white : .primary)
                                    .clipShape(Capsule())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                }
                
                Spacer()
                
                HStack {
                    if step > 1 {
                        Button("Back") { step -= 1 }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                    }
                    
                    Button(step == 3 ? "Complete" : "Next") {
                        if step < 3 { 
                            withAnimation {
                                step += 1 
                            }
                        } else {
                            Task {
                                await viewModel.register(
                                    name: name,
                                    skillLevel: skillLevel,
                                    dietaryGoals: Array(dietaryGoals)
                                )
                            }
                        }
                    }
                    .disabled(step == 1 && name.isEmpty)
                    .opacity(step == 1 && name.isEmpty ? 0.5 : 1.0)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                }
                .padding()
            }
            .navigationTitle("Registration")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct FlowLayout<Items: RandomAccessCollection, Content: View>: View where Items.Element: Hashable {
    let items: Items
    let content: (Items.Element) -> Content
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            var width = CGFloat.zero
            var height = CGFloat.zero
            
            ForEach(items, id: \.self) { item in
                content(item)
                    .alignmentGuide(.leading) { d in
                        if abs(width - d.width) > UIScreen.main.bounds.width - 32 {
                            width = 0
                            height -= d.height + 10
                        }
                        let result = width
                        if item == items.last {
                            width = 0
                        } else {
                            width -= d.width + 10
                        }
                        return result
                    }
                    .alignmentGuide(.top) { d in
                        let result = height
                        if item == items.last {
                            height = 0
                        }
                        return result
                    }
            }
        }
    }
}

#Preview {
    RegistrationView(viewModel: HubViewModel(authRepository: MockAuthRepository(), orderRepository: MockOrderRepository()))
}
