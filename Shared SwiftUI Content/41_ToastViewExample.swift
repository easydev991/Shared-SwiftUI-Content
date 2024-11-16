import SwiftUI

// MARK: 1 - Для включения тоста с любого экрана

struct ToastModel: Equatable, Sendable {
    let title: String
    var subtitle: String?
    var duration: Duration = .short
    
    enum Duration: Double {
        case short = 1.5
        case medium = 3
        case long = 4.5
    }
}

@MainActor
struct ToastEnvironmentKey: @preconcurrency EnvironmentKey {
    static let defaultValue: (_ model: ToastModel) -> Void = { _ in }
}

extension EnvironmentValues {
    var toastInfo: (_ model: ToastModel) -> Void {
        get { self[ToastEnvironmentKey.self] }
        set { self[ToastEnvironmentKey.self] = newValue }
    }
}

// MARK: 2 - Модификатор с тостом

/// Модификатор для отображения тоста
///
/// Нужно применять поверх `NavigationView` / `NavigationStack`
struct ToastViewModifier: ViewModifier {
    @State private var topPadding: CGFloat?
    @Binding private var model: ToastModel?
    
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
        duration: ToastModel.Duration = .short
    ) {
        self._model = .init(
            get: {
                isPresented.wrappedValue
                ? ToastModel(title: title, subtitle: subtitle, duration: duration)
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
    init(model: Binding<ToastModel?>) {
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
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.red)
                .onTapGesture { self.model = nil } // скрываем тост при нажатии на него
                .transition(.move(edge: .top).combined(with: .opacity))
                .task {
                    // при появлении тоста запускаем ожидание,
                    // по окончании ожидания закрываем тост
                    try? await Task.sleep(for: .seconds(model.duration.rawValue))
                    self.model = nil
                }
            }
        }
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
     @State private var toastModel: ToastModel?
     
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
        duration: ToastModel.Duration = .short
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
    
    func toast(item: Binding<ToastModel?>) -> some View {
        modifier(ToastViewModifier(model: item))
    }
}

// MARK: 4 - Вьюшки для превью

struct ToastViewExample1: View {
    @State private var showToast = false
    @State private var toastModel: ToastModel?
    
    var body: some View {
        NavigationView {
            ChildView()
                .navigationTitle("Тестируем тосты")
        }
        .environment(\.toastInfo) { model in
            toastModel = model
        }
        .toast(item: $toastModel)
    }
    
    struct ChildView: View {
        @Environment(\.toastInfo) private var toastInfo
        
        var body: some View {
            Button("Показать тост") {
                toastInfo(
                    .init(
                        title: "Тост № 1",
                        subtitle: "Краткое описание 1"
                    )
                )
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

struct ToastViewExample2: View {
    @Environment(\.toastInfo) private var toastInfo
    @State private var showToast = false
    @State private var toastModel: ToastModel?
    
    var body: some View {
        NavigationView {
            Button("Показать тост") {
                showToast = true
            }
            .buttonStyle(.borderedProminent)
            .navigationTitle("Тестируем тосты")
        }
        .toast(isPresented: $showToast, title: "Тост № 2", subtitle: "Краткое описание 2")
    }
}

struct ToastViewExample3: View {
    @Environment(\.toastInfo) private var toastInfo
    @State private var showToast = false
    @State private var toastModel: ToastModel?
    
    var body: some View {
        NavigationView {
            Button("Показать тост") {
                toastModel = .init(title: "Тост № 3", subtitle: "Краткое описание 3")
            }
            .buttonStyle(.borderedProminent)
            .navigationTitle("Тестируем тосты")
        }
        .toast(item: $toastModel)
    }
}

#Preview("Вариант 1") { ToastViewExample1() }
#Preview("Вариант 2") { ToastViewExample2() }
#Preview("Вариант 3") { ToastViewExample3() }
