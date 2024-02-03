import SwiftUI

struct SkeletonModifier: ViewModifier {
    /// `true` - анимация активна, `false` - неактивна
    @State private var isAnimating = false
    /// Анимация движения градиента
    private let foreverAnimation = Animation.default.speed(0.25)
        .repeatForever(autoreverses: false)
    private let mode: Mode?
    private let cornerRadius: CGFloat
    
    /// - Parameters:
    ///   - mode: Режим (загружается или нужна перезагрузка)
    ///   - cornerRadius: Радиус углов скелетона
    init(mode: Mode?, cornerRadius: CGFloat) {
        self.mode = mode
        self.cornerRadius = cornerRadius
    }
    
    func body(content: Content) -> some View {
        content
            .opacity(mode == nil ? 1 : 0)
            .overlay(
                GeometryReader { geo in
                    let width = geo.size.width
                    let xOffset = isAnimating ? width : -width
                    skeletonIfNeeded(
                        gradientOffset: xOffset,
                        height: geo.size.height
                    )
                }
            )
            .animation(.default, value: mode)
    }
    
    private func skeletonIfNeeded(
        gradientOffset: CGFloat,
        height: CGFloat
    ) -> some View {
        ZStack {
            switch mode {
            case .loading:
                Color.gray.opacity(0.2) // цвет основного контейнера для скелетона
                    .overlay(
                        Color.white // цвет, который ездит слева направо
                            .mask(
                                Rectangle()
                                    .fill(linearGradient)
                                    .offset(x: gradientOffset)
                            )
                            .animation(foreverAnimation, value: isAnimating)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    .onAppear { isAnimating = true }
                    .onDisappear { isAnimating = false }
            case let .needReload(model):
                NeedReloadView(
                    isVertical: height >= 100,
                    message: model.message,
                    action: model.action
                )
            default: EmptyView()
            }
        }
    }
    
    /// Градиент для скелетона
    ///
    /// Поскольку этот градиент применяется внутри маски,
    /// значение второго цвета может быть любым кроме `clear`
    private var linearGradient: LinearGradient {
        LinearGradient(
            gradient: .init(colors: [.clear, .white, .clear]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}
