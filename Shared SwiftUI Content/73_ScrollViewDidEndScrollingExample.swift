import SwiftUI
import Combine

// https://stackoverflow.com/a/65062892/11830041

// 1 - Создаем новый PreferenceKey для хранения значения оффсета скролла
fileprivate struct ViewOffsetKey: PreferenceKey {
    static let defaultValue = CGFloat.zero
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

struct ScrollViewDidEndScrollingExample: View {
    /// Распознаватель изменения в оффсете
    private let detector: CurrentValueSubject<CGFloat, Never>
    /// Публикатор сообщений от распознавателя (с дебаунсом в 0.2 сек)
    private let publisher: AnyPublisher<CGFloat, Never>
    private let scrollId = "ScrollID"
    @State private var stopOffset = CGFloat.zero
    
    init() {
        // Настраиваем отслеживание оффсета
        let detector = CurrentValueSubject<CGFloat, Never>(0)
        self.publisher = detector
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .dropFirst() // Пропускаем первое событие при появлении экрана
            .eraseToAnyPublisher()
        self.detector = detector
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // демо-список
            }
            .background(
                // Настраиваем отслеживание оффсета
                GeometryReader {
                    Color.clear.preference(
                        key: ViewOffsetKey.self,
                        value: -$0.frame(in: .named(scrollId)).origin.y
                    )
                }
            )
            // Публикуем изменения оффсета
            .onPreferenceChange(ViewOffsetKey.self, perform: detector.send)
        }
        // Задаем идентификатор для координатной плоскости
        .coordinateSpace(name: scrollId)
        .onReceive(publisher) { finalOffset in
            // обрабатываем "окончание" скролла
        }
    }
}

#Preview {
    ScrollViewDidEndScrollingExample()
}
