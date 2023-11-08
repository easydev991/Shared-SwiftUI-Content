import SwiftUI

struct TransitionExample: View {
    // 1 - Состояние, смену которого будем анимировать
    @State private var showView = false

    var body: some View {
        VStack {
            Button(showView ? "Скрыть" : "Показать") {
                showView.toggle() // 2 - Переключаем состояние
            }
            Spacer()
            VStack { // 3 - Контейнер для анимированных вьюшек с разными вариантами `transition`
                if showView {
                    exampleContent("default", .gray)
                    exampleContent("slide", .green)
                        .transition(.slide)
                    exampleContent("slide + scale", .blue)
                        .transition(.slide.combined(with: .scale))
                    exampleContent("slide + scale + opacity", .indigo)
                        .transition(.slide.combined(with: .scale).combined(with: .opacity))
                }
            }
            // 4 - Модификатор с анимацией
            .animation(.easeInOut(duration: 2), value: showView)
        }
        .frame(height: 350)
    }

    // 5 - Вьюшка для демонстрации анимаций
    private func exampleContent(_ text: String, _ color: Color) -> some View {
        Text(text)
            .font(.title)
            .foregroundStyle(.white)
            .padding(16)
            .background {
                color.clipShape(.capsule)
            }
    }
}

#Preview { TransitionExample() }
