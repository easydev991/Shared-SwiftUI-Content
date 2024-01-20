import SwiftUI

extension SUIOnboarding {
    struct TooltipViewModifier: ViewModifier {
        let item: ItemModel?
        
        func body(content: Content) -> some View {
            content.background(backgroundView)
        }
        
        @ViewBuilder
        private var backgroundView: some View {
            if let item {
                GeometryReader { geo in
                    Color.clear
                        .preference(
                            key: MaskFramePreferenceKey.self,
                            value: [
                                item: geo.frame(in: .named(coordinateNamespace))
                            ]
                        )
                }
            }
        }
    }
}

extension View {
    /// Добавляет вьюшке модель для тултипа онбординга
    /// - Parameter item: Модель для онбординга
    /// - Returns: Вьюшка с данными для онбординга
    public func tooltipItem(_ item: SUIOnboarding.ItemModel?) -> some View {
        modifier(SUIOnboarding.TooltipViewModifier(item: item))
    }
}
