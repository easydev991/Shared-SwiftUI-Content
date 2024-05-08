import SwiftUI

struct ScrollTargetExample: View {
    /// Идентификатор текущего элемента для управления скроллом
    @State private var scrollID: String?
    let items: [Item]
    
    public var body: some View {
        if #available(iOS 17.0, *) {
            VStack(spacing: 20) {
                scrollContentView
                buttonStack
            }
        } else {
            Text("Заглушка для ScrollView без крутых фичей")
        }
    }
    
    @available(iOS 17.0, *)
    private var scrollContentView: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 12) {
                ForEach(items) { item in
                    Text(item.title)
                        .foregroundStyle(.white)
                        .font(.title.bold())
                        .frame(width: 300, height: 150)
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    .linearGradient(
                                        colors: item.colors,
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        }
                }
            }
            .scrollTargetLayout() // 1 <- обязательно для "доводки"
        }
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.viewAligned) // 2 <- обязательно для "доводки"
        .safeAreaPadding(.horizontal, 20) // 3 <- для отступов по бокам от безопасной зоны
        .scrollPosition(id: $scrollID) // 4 <- для скролла к элементу
    }
    
    private var buttonStack: some View {
        HStack {
            Button("< К первому") {
                withAnimation {
                    scrollID = items.first?.id
                }
            }
            .disabled(scrollID == items.first?.id || scrollID == nil)
            Spacer()
            Button("К последнему >") {
                withAnimation {
                    scrollID = items.last?.id
                }
            }
            .disabled(scrollID == items.last?.id)
        }
        .padding(.horizontal)
    }
}

extension ScrollTargetExample {
    struct Item: Identifiable {
        let id = UUID().uuidString
        let title: String
        let colors: [Color]
    }
}

#Preview {
    ScrollTargetExample(
        items: [
            .init(title: "Первый элемент", colors: [.blue, .green]),
            .init(title: "Второй элемент", colors: [.green, .yellow]),
            .init(title: "Третий элемент", colors: [.orange, .red])
        ]
    )
}
