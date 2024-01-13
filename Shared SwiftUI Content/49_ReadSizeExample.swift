import SwiftUI

// 1 -  Используем для передачи информации о вьюхе наверх по иерархии вьюшек
struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

// 2 - Модификатор для удобства
extension View {
    /// Возвращает размер вьюхи в замыкании
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometry in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometry.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

struct ReadSizeExample: View {
    @State private var myViewSize: CGSize = .zero
    @State private var myViewPadding: CGFloat = 12
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Габариты градиентной вьюшки:\n\(sizeText)")
            Text("Вьюшка, габариты которой мы хотим получить")
                .bold()
                .foregroundStyle(.white)
                .padding(myViewPadding)
                .background(backgroundRectangle)
                .readSize { myViewSize = $0 }
                .animation(.default, value: myViewPadding)
            Slider(value: $myViewPadding, in: 8...80)
        }
        .padding(.horizontal)
    }
    
    private var sizeText: String {
        """
        - ширина: \(myViewSize.width.rounded())
        - высота: \(myViewSize.height.rounded())
        """
    }
    
    private var backgroundRectangle: some View {
        RoundedCornerShape(
            radius: 12,
            corners: [.bottomLeft, .topRight]
        )
        .fill(
            LinearGradient(
                colors: [.red, .purple, .blue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

#Preview {
    ReadSizeExample()
}
