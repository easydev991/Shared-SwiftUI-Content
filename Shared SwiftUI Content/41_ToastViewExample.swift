import SwiftUI

// MARK: 1 - Для включения тоста с любого экрана

struct ToastEnvironmentKey: EnvironmentKey {
    static var defaultValue: (_ model: ToastViewModifier.Model) -> Void = { _ in }
}

extension EnvironmentValues {
    var toastInfo: (_ model: ToastViewModifier.Model) -> Void {
        get { self[ToastEnvironmentKey.self] }
        set { self[ToastEnvironmentKey.self] = newValue }
    }
}

// MARK: 2 - Модификатор с тостом

/// Модификатор для отображения тоста
///
/// Нужно применять поверх `NavigationView` / `NavigationStack`
struct ToastViewModifier: ViewModifier {
    struct Model: Equatable {
        let title: String
        var subtitle: String?
        var duration: Duration = .short
    }
    enum Duration: Double {
        case short = 1.5
        case medium = 3
        case long = 4.5
    }
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @Binding private var model: Model?
    @State private var timer: Timer?
    
    /// Инициализатор для управления через `isPresented`
    /// - Parameters:
    ///   - isPresented: `true` - показать тост, `false` - скрыть
    ///   - title: Заголовок
    ///   - subtitle: Подзаголовок
    ///   - duration: Длительность отображения тоста
    init(
        isPresented: Binding<Bool>,
        title: String,
        subtitle: String? = nil,
        duration: Duration = .short
    ) {
        self._model = .init(
            get: {
                isPresented.wrappedValue
                ? Model(title: title, subtitle: subtitle, duration: duration)
                : nil
            },
            set: { newValue in
                if newValue == nil {
                    isPresented.wrappedValue = false
                }
            }
        )
    }
    
    /// Инициализатор для управления через модель
    /// - Parameter model: Модель для тоста
    init(model: Binding<Model?>) {
        self._model = .init(
            get: { model.wrappedValue == nil ? nil : model.wrappedValue },
            set: { newValue in
                if newValue == nil {
                    model.wrappedValue = nil
                }
            }
        )
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(overlayContent, alignment: .top)
            .animation(.easeInOut(duration: 0.25), value: model)
    }
    
    private var overlayContent: some View {
        ZStack(alignment: .top) {
            if let model {
                VStack(alignment: .leading, spacing: 4) {
                    Text(model.title).bold()
                    if let subtitle = model.subtitle, !subtitle.isEmpty {
                        Text(subtitle)
                    }
                }
                .foregroundStyle(.white)
                .padding(.top, safeAreaInsets.bottom > 0 ? 44 : 0) // паддинг для девайсов с чёлкой
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.red)
                .onTapGesture { self.model = nil } // скрываем тост при нажатии на него
                .transition(.move(edge: .top).combined(with: .opacity))
                .onAppear {
                    // при появлении тоста запускаем таймер
                    // по окончании таймера закрываем тост
                    timer = Timer.scheduledTimer(
                        withTimeInterval: model.duration.rawValue,
                        repeats: false
                    ) { _ in self.model = nil }
                }
                .onDisappear {
                    timer?.invalidate()
                    timer = nil
                }
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: 3 - Для удобного применения тоста
// При работе с `ToastEnvironmentKey` нужно применять 
// эти методы к рутовой вьюшке внутри `WindowGroup`,
// к которой применяется модификатор `environment(\.toastInfo) { model in ... }`
// Например:
/*
 @main
 struct MyApp: App {
     @State private var toastModel: ToastViewModifier.Model?
     
     var body: some Scene {
         WindowGroup {
             ContentView() // <- внутри настраивается тост через обращение к @Environment(\.toastInfo)
                 .environment(\.toastInfo) { model in
                     toastModel = model
                 }
                 .toast(item: $toastModel)
         }
     }
 }
 */
extension View {
    func toast(
        isPresented: Binding<Bool>,
        title: String,
        subtitle: String? = nil,
        duration: ToastViewModifier.Duration = .short
    ) -> some View {
        modifier(
            ToastViewModifier(
                isPresented: isPresented,
                title: title,
                subtitle: subtitle,
                duration: duration
            )
        )
    }
    
    func toast(item: Binding<ToastViewModifier.Model?>) -> some View {
        modifier(ToastViewModifier(model: item))
    }
}

// MARK: 4 - Вьюшка для "вызова" тоста

struct ToastViewExample: View {
    @Environment(\.toastInfo) private var toastInfo
    @State private var showToast = false
    @State private var toastModel: ToastViewModifier.Model?
    
    var body: some View {
        NavigationView {
            Button("Показать тост") {
                // Вариант 1
                toastInfo(
                    .init(
                        title: "Тост № 1",
                        subtitle: "Краткое описание 1"
                    )
                )
                // Вариант 2
//                showToast = true
                // Вариант 3
//                toastModel = .init(title: "Тост № 3", subtitle: "Краткое описание 3")
            }
            .buttonStyle(.borderedProminent)
            .navigationTitle("Тестируем тосты")
        }
        // Вариант 2
//        .toast(isPresented: $showToast, title: "Тост № 2", subtitle: "Краткое описание 2")
        // Вариант 3
//        .toast(item: $toastModel)
    }
}

#Preview { ToastViewExample() }
