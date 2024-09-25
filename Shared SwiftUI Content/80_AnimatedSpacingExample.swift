import SwiftUI

struct AnimatedSpacingExample: View {
    /// Тут храним спейсинг для анимации
    @State private var hSpacing: CGFloat = 30
    private let numbers = [1, 2, 3, 4]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Спейсинг: \(String(format: "%.1f", hSpacing))")
            HStack(spacing: hSpacing) { // <- вот наш анимируемый спейсинг
                ForEach(numbers, id: \.self) { _ in
                    Circle()
                        .opacity(max(currentProgress, 0.2))
                        .animation(.spring, value: hSpacing)
                        .frame(width: circleSize, height: circleSize)
                }
            }
            .frame(height: 30)
            Slider(value: $hSpacing, in: -20...30)
            Button("Пуск", action: buttonAction)
        }
    }
    
    /// Размер фрейма для каждого круга
    private var circleSize: CGFloat {
        let maxSize: CGFloat = 20
        let minSize: CGFloat = 10
        
        // Нормализуем значение hSpacing в диапазоне от -20 до 30
        let normalizedSpacing = (hSpacing + 20) / (30 + 20)
        
        // Вычисляем размер круга
        return maxSize * (1 - normalizedSpacing) + minSize * normalizedSpacing
    }
    
    /// Текущий прогресс, где 1.0 соответствует спейсингу -20
    private var currentProgress: CGFloat {
        let min: CGFloat = -20.0
        let max: CGFloat = 30.0
        
        // Проверяем, находится ли значение вне диапазона
        if hSpacing <= min {
            return 1.0
        } else if hSpacing >= max {
            return 0.0
        } else {
            // Линейная интерполяция
            return (max - hSpacing) / (max - min)
        }
    }
    
    private func buttonAction() {
        if hSpacing > -20 {
            hSpacing = -20
        } else {
            hSpacing = 30
        }
    }
}

#Preview {
    AnimatedSpacingExample()
}
