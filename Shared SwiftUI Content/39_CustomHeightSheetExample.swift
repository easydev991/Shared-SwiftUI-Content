import SwiftUI

// MARK: - Для удобства работы с безопасной зоной

struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        let keywindow = UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .last(where: \.isKeyWindow)
        let safeAreaInsets = keywindow?.safeAreaInsets ?? .zero
        return safeAreaInsets.insets
    }
}

extension UIEdgeInsets {
    var insets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}

extension EnvironmentValues {
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

// MARK: - Обертка для модальных окон

struct ModalPageWrapper<Content: View>: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(spacing: 0) {
            pinView
            content()
        }
        .padding(.bottom, safeAreaInsets.bottom)
        .background(
            Rectangle().fill(.white)
                .clipShape(
                    RoundedCornerShape(radius: 24, corners: [.topLeft, .topRight])
                )
        )
    }

    private var pinView: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundColor(.gray.opacity(0.5))
            .frame(width: 40, height: 4)
            .padding(.vertical, 8)
    }
}

// MARK: - Модификатор для кастомных модальных окон

struct CustomHeightSheetModifier<SheetContent: View>: ViewModifier {
    @State private var yOffset: CGFloat = 0 // для управления свайпом
    @Binding var isPresented: Bool
    @ViewBuilder let sheetContent: SheetContent

    func body(content: Content) -> some View {
        ZStack {
            content
            overlayContent
        }
        .animation(.easeInOut(duration: 0.25), value: isPresented)
    }

    private var overlayContent: some View {
        ZStack(alignment: .bottom) {
            if isPresented {
                backgroundColor
                sheetContentView
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }

    private var backgroundColor: some View {
        Color.black.opacity(0.45)
            .animation(.default, value: yOffset)
            .ignoresSafeArea()
            .onTapGesture {
                // закрываем модалку, если нажали за пределами ее контента
                if isPresented {
                    isPresented = false
                }
            }
            .zIndex(1)
    }

    private var sheetContentView: some View {
        ModalPageWrapper { sheetContent }
            .zIndex(2)
            .transition( // настраиваем способ показа/скрытия модалки
                .asymmetric(
                    insertion: .move(edge: .bottom),
                    removal: .move(edge: .bottom)
                )
            )
            .offset(y: yOffset)
            .animation(.easeInOut(duration: 0.15), value: yOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let height = value.translation.height
                        // не даем увеличивать модалку выше, чем нужно
                        guard height > 0 else { return }
                        yOffset = height
                    }
                    .onEnded { value in
                        if value.translation.height > 50 {
                            // закрываем модалку
                            isPresented = false
                        } else {
                            // сбрасываем оффсет, чтобы модалка вернулась к исходной высоте
                            yOffset = 0
                        }
                    }
            )
            // обязательно сбрасываем оффсет при закрытии модалки
            .onDisappear { yOffset = 0 }
    }
}

extension View {
    func customHeightSheet<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(
            CustomHeightSheetModifier(
                isPresented: isPresented,
                sheetContent: content
            )
        )
    }
}

// MARK: - Пример использования

struct CustomHeightSheetExample: View {
    @State private var showCustomHeightSheet = false

    var body: some View {
        Button("Показать модалку") {
            showCustomHeightSheet = true
        }
        .customHeightSheet(isPresented: $showCustomHeightSheet) {
            VStack(spacing: 16) {
                Text("Модалка кастомной высоты")
                    .font(.title2.bold())
                    .padding()
                ForEach(0..<5, id: \.self) { i in
                    HStack {
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscin")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("#\(i)")
                    }
                    .padding(.horizontal)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview { CustomHeightSheetExample() }
