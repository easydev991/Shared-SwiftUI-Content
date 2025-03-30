import SwiftUI

// MARK: - Для удобства работы с безопасной зоной

struct SafeAreaInsetsKey: PreferenceKey {
    static let defaultValue: EdgeInsets = .init()
    static func reduce(value: inout EdgeInsets, nextValue: () -> EdgeInsets) {}
}

extension View {
    /// Возвращает безопасную зону в замыкании
    func readSafeAreaInsets(onChange: @Sendable @escaping (EdgeInsets) -> Void) -> some View {
        background(
            GeometryReader { geometry in
                Color.clear
                    .preference(key: SafeAreaInsetsKey.self, value: geometry.safeAreaInsets)
            }
        )
        .onPreferenceChange(SafeAreaInsetsKey.self, perform: onChange)
    }
}

// MARK: - Обертка для модальных окон

struct ModalPageWrapper<Content: View>: View {
    private let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 0) {
            pinView
            content
        }
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
    @State private var bottomPadding: CGFloat?
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
        .readSafeAreaInsets { [$bottomPadding] newValue in
            $bottomPadding.wrappedValue = newValue.bottom
        }
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
        ModalPageWrapper {
            sheetContent
                .padding(.bottom, bottomPadding)
        }
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
