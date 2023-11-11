import SwiftUI

struct ZoomableViewExample: View {
    private let minZoom: CGFloat = 1.0
    private let maxZoom: CGFloat = 3.0
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    // Изменяем в `onChanged` у жеста, но сбрасываем в `onEnded`
    @State private var dragOffset = CGSize.zero
    // Изменяем в `onEnded` у жеста
    @State private var position = CGSize.zero
    
    private var xOffset: CGFloat {
        dragOffset.width + position.width
    }
    
    private var yOffset: CGFloat {
        dragOffset.height + position.height
    }

    var body: some View {
        NavigationView { // Для навбара и кнопки "Сброс"
            exampleView
                // Применяем масштабирование и положение
                .scaleEffect(scale)
                .offset(x: xOffset, y: yOffset)
                // Анимируем смену состояний
                .animation(.easeInOut(duration: 0.2), value: scale)
                .animation(.linear(duration: 0.2), value: dragOffset)
                .animation(.linear(duration: 0.2), value: position)
                // Добавляем жесты
                .gesture(
                    magnificationGesture
                        .simultaneously(with: dragGesture)
                )
                .toolbar {
                    ToolbarItem {
                        resetButton
                    }
                }
        }
    }
    
    var exampleView: some View {
        Rectangle()
            .frame(width: 250, height: 250)
            .overlay {
                VStack {
                    Text("scale: \(scale, specifier: "%.2f")")
                    Text("x: \(xOffset, specifier: "%.2f")")
                    Text("y: \(yOffset, specifier: "%.2f")")
                }
                .foregroundStyle(.white)
                .transaction { transaction in
                    // Выключаем анимации внутри `VStack`, чтобы текст не размазывался
                    transaction.animation = nil
                }
            }
    }
    
    var resetButton: some View {
        Button("Сброс") {
            scale = minZoom
            position = .zero
        }
        .buttonStyle(.borderedProminent)
    }
    
    var magnificationGesture: some Gesture {
        MagnificationGesture(minimumScaleDelta: 0.0)
            .onChanged { gesture in
                process(new: gesture.magnitude, updating: &scale)
            }
            .onEnded { gesture in
                process(new: gesture.magnitude, updating: &lastScale)
                scale = lastScale
            }
    }
    
    func process(new magnitude: CGFloat, updating scale: inout CGFloat) {
        let magnification = lastScale + magnitude - 1.0
        if magnification >= minZoom && magnification <= maxZoom {
            // Не вышли за лимиты, задаем новый `scale`
            scale = magnification
        } else if magnification < minZoom {
            // Вышли за нижнюю границу, задаем минимальный `scale`
            scale = minZoom
        } else if magnification > maxZoom {
            // Вышли за верхнюю границу, задаем максимальный `scale`
            scale = maxZoom
        }
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { gesture in
                dragOffset = gesture.translation
            }
            .onEnded { gesture in
                dragOffset = .zero
                position.width += gesture.translation.width
                position.height += gesture.translation.height
            }
    }
}

#Preview("SwiftUI native") {
    ZoomableViewExample()
}

import PDFKit

struct PDFViewRepresentable: UIViewRepresentable {
    let image: UIImage

    func makeUIView(context _: Context) -> PDFView {
        let view = PDFView()
        guard let page = PDFPage(image: image) else { return view }
        view.document = PDFDocument()
        view.document?.insert(page, at: 0)
        view.autoScales = true
        view.minScaleFactor = 0.5
        view.maxScaleFactor = 3
        return view
    }

    func updateUIView(_ : PDFView, context _: Context) {}
}

#Preview("PDFViewRepresentable") {
    PDFViewRepresentable(image: .swift)
}
