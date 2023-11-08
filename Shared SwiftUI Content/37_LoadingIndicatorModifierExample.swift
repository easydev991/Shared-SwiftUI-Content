import SwiftUI

/// Модификатор для отображения индикатора загрузки
///
/// Делает контент недоступным для нажатия в состоянии загрузки
struct LoadingIndicatorModifier: ViewModifier {
    let isLoading: Bool

    func body(content: Content) -> some View {
        ZStack {
            if isLoading {
                content.opacity(0.5)
                LoadingIndicatorView()
            } else {
                content
            }
        }
        .disabled(isLoading)
        .animation(.default, value: isLoading)
    }
}

/// Вьюшка с анимированным индикатором загрузки
private struct LoadingIndicatorView: View {
    @State private var isAnimating = false

    var body: some View {
        Image(.loadingIndicator) // Картинка из ассетов проекта
            .resizable()
            .frame(width: 50, height: 50)
            .foregroundStyle(.white)
            .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
            .animation(
                .linear(duration: 2.0).repeatForever(autoreverses: false),
                value: isAnimating
            )
            .onAppear { isAnimating = true }
    }
}

extension View {
    /// Метод для удобного применения модификатора
    func loadingOverlay(if isLoading: Bool) -> some View {
        modifier(LoadingIndicatorModifier(isLoading: isLoading))
    }
}

/// Экран для демо
struct LoadingIndicatorModifierExample: View {
    @State private var isLoading = false

    var body: some View {
        Color.black.ignoresSafeArea()
            .overlay {
                Button("Начать загрузку") {
                    isLoading = true
                }
                .font(.title.bold())
                .tint(.yellow)
            }
            .loadingOverlay(if: isLoading)
    }
}

#Preview { LoadingIndicatorModifierExample() }
