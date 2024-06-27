import SwiftUI

struct OnVisibilityChangeExample: View {
    /// Изменяем при помощи `onAppear`/`onDisappear`
    @State private var isBottomElementVisible = false
    /// Изменяем при помощи кастомного модификатора и `GeometryReader`
    @State private var isBottomElementVisible2 = false
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                LazyVStack(spacing: 24) {
                    ForEach(0..<20) { number in
                        Capsule()
                            .fill(.green.opacity(0.5))
                            .frame(width: 150, height: 70)
                            .overlay {
                                Text("\(number)")
                            }
                    }
                    Rectangle()
                        .frame(width: 5, height: 5)
                        .onAppear { isBottomElementVisible = true }
                        .onDisappear { isBottomElementVisible = false }
                        .onVisibilityChange(proxy: proxy) { isVisible in
                            isBottomElementVisible2 = isVisible
                        }
                }
            }
        }
        .overlay {
            VStack {
                Text("isBottomElementVisible: \(isBottomElementVisible)")
                Text("isBottomElementVisible2: \(isBottomElementVisible2)")
            }
            .bold()
            .padding()
            .background {
                Rectangle()
                    .fill(.yellow.opacity(0.5))
            }
        }
    }
}

extension View {
    /// Добавляет модификатор для проверки, виден ли элемент на экране
    /// - Parameters:
    ///   - proxy: `GeometryProxy` родительской вьюхи. В случае со скроллом
    ///   нужно сложить весь `ScrollView` внутрь `GeometryReader`
    ///   - action: Действие, вызывается при изменении видимости
    /// - Returns: Вьюха, сообщающая о своей видимости в области родительского фрейма
    func onVisibilityChange(
        proxy: GeometryProxy,
        perform action: @escaping (Bool) -> Void
    )-> some View {
        modifier(CheckVisibilityModifier(parentProxy: proxy, action: action))
    }
}

private struct CheckVisibilityModifier: ViewModifier {
    @State private var isVisible = false
    let parentProxy: GeometryProxy
    let action: (Bool) -> Void
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            checkVisibility(proxy: proxy)
                        }
                        .onChange(of: proxy.frame(in: .global)) { _ in
                            checkVisibility(proxy: proxy)
                        }
                }
            )
    }
    
    private func checkVisibility(proxy: GeometryProxy) {
        let parentFrame = parentProxy.frame(in: .global)
        let childFrame = proxy.frame(in: .global)
        let isVisibleNow = parentFrame.intersects(childFrame)
        if isVisible != isVisibleNow {
            isVisible = isVisibleNow
            action(isVisibleNow)
        }
    }
}

#Preview {
    OnVisibilityChangeExample()
}
