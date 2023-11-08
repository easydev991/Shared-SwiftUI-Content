import SwiftUI

// 1 - Создаем новый PreferenceKey для хранения значения в формате CGFLoat из слайдера
struct ProgressPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct OverlayPreferenceKeyExample: View {
    @State private var progress: CGFloat = 0 // 2 - Создаем свойство для обновления состояния экрана

    var body: some View {
        VStack(spacing: 50) {
            Slider(value: $progress, in: 0...100) // 3 - Добавляем слайдер
                .overlay(
                    GeometryReader { geometry in
                        Color.clear.preference(
                            key: ProgressPreferenceKey.self,
                            value: geometry.size.width
                        ) // 4 - Подключаемся к созданному на первом шаге PreferenceKey
                    }
                )
            Text("Progress: \(Int(progress))%") // 5 - Выводим на экран текст со значением прогресса из слайдера
        }
        // 6 - Добавляем overlay с капсулой, ширина которой зависит от прогресса слайдера
        .overlayPreferenceValue(ProgressPreferenceKey.self) { width in
            Capsule()
                .frame(width: width * (progress / 100), height: 10)
                .animation(.default, value: progress)
        }
        .padding(.horizontal)
    }
}

#Preview { OverlayPreferenceKeyExample() }
