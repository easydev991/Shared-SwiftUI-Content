import UIKit
import SwiftUI

@MainActor
public final class EasyAlert {
    public static let shared = EasyAlert()
    private var currentAlert: UIViewController?
    
    /// Показывает системный алерт с заданными параметрами
    /// - Parameters:
    ///   - title: Заголовок. Если передать `nil`, то сообщение выделится жирным. Если передать текст или пустую строку, будет без заголовка, и сообщение будет со стандартным шрифтом
    ///   - message: Текст сообщения
    ///   - closeButtonTitle: Заголовок кнопки для закрытия алерта
    ///   - closeButtonStyle: Стиль кнопки для закрытия алерта
    ///   - closeButtonTintColor: Цвет кнопки для закрытия алерта. Если не настроить явно, то при появлении будет системный (синий) цвет, а при нажатии он изменится на `AccentColor` в вашем проекте
    public func presentStandardUIKit(
        title: String? = "",
        message: String,
        closeButtonTitle: String = "Ok",
        closeButtonStyle: UIAlertAction.Style = .default,
        closeButtonTintColor: UIColor? = nil
    ) {
        guard currentAlert == nil, let topMostViewController else { return }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = closeButtonTintColor
        alert.addAction(
            .init(
                title: closeButtonTitle,
                style: closeButtonStyle,
                handler: { [weak self] _ in
                    self?.currentAlert = nil
                }
            )
        )
        currentAlert = alert
        topMostViewController.present(alert, animated: true)
    }
    
    /// Показывает кастомный SwiftUI-алерт с дефолтным фоном и анимациями
    ///
    /// Для закрытия алерта нужно вызвать метод `dismiss()` у синглтона
    /// - Parameter alertContent: SwiftUI-вьюха для алерта
    public func presentCustomSUI<Content: View>(_ content: Content) {
        presentCustomSUI { content }
    }
    
    /// Показывает кастомный SwiftUI-алерт с дефолтным фоном и анимациями
    ///
    /// Для закрытия алерта нужно вызвать метод `dismiss()` у синглтона
    /// - Parameter alertContent: Замыкание со SwiftUI-вьюхой для алерта
    public func presentCustomSUI<Content: View>(
        @ViewBuilder _ content: () -> Content
    ) {
        guard currentAlert == nil, topMostViewController != nil else { return }
        let hostingController = UIHostingController(rootView: AlertViewContainer(content: content()))
        hostingController.modalPresentationStyle = .overFullScreen
        hostingController.modalTransitionStyle = .crossDissolve
        presentCustomUIKit(hostingController)
    }
    
    /// Показывает кастомный UIKit-алерт
    ///
    /// Алерт не может сам себя закрыть, для закрытия нужно вызвать метод `dismiss()` у синглтона
    /// - Parameter viewController: UIKit-экран для алерта, все настройки алерта нужно делать снаружи, прежде чем передавать в этот метод готовый экран
    public func presentCustomUIKit(_ viewController: UIViewController) {
        guard currentAlert == nil, let topMostViewController else { return }
        viewController.view.backgroundColor = .clear
        currentAlert = viewController
        topMostViewController.present(viewController, animated: true)
    }
    
    public func dismiss() {
        currentAlert?.dismiss(animated: true)
        currentAlert = nil
    }
    
    private var topMostViewController: UIViewController? {
        UIApplication.shared.firstKeyWindow?.rootViewController?.topMostViewController
    }
}

private extension UIApplication {
    var firstKeyWindow: UIWindow? {
        connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .first(where: \.isKeyWindow)
    }
}

private extension UIViewController {
    var topMostViewController: UIViewController {
        if let presented = presentedViewController {
            return presented.topMostViewController
        }
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController ?? navigation
        }
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController ?? tab
        }
        return self
    }
}

/// Контейнер для кастомного алерта
private struct AlertViewContainer<Content: View>: View {
    @State private var showContent = false
    let content: Content
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.25).ignoresSafeArea()
            if showContent { content }
        }
        .onAppear {
            withAnimation(.spring(duration: 0.2)) { showContent = true }
        }
    }
}

private struct CustomSwiftUIAlertView: View {
    @State private var showContent = false
    let message: String
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.25).ignoresSafeArea()
            if showContent {
                VStack(spacing: 20) {
                    Text(message)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    Button("Ok") {
                        withAnimation(.easeOut(duration: 0.25)) {
                            showContent = false
                        }
                        EasyAlert.shared.dismiss()
                    }
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.background)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 4)
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.scale(scale: 0.5).combined(with: .move(edge: .top)).combined(with: .opacity))
            }
        }
        .onAppear {
            withAnimation(.spring(duration: 0.25)) { showContent = true }
        }
    }
}

struct EasyAlertExample: View {
    private let alertMessage = "Сообщение в алерте"
    @State private var showAlert = false
    @State private var showSheet = false
    
    var body: some View {
        NavigationView {
            Button("Показать модалку") {
                showSheet.toggle()
            }
            .buttonStyle(.borderedProminent)
            .sheet(isPresented: $showSheet) {
                sheetContentView
            }
            .navigationTitle("Главный экран")
        }
        .alert(alertMessage, isPresented: $showAlert) {
            Button("Ок") { print("ok") }
        }
    }
    
    private var sheetContentView: some View {
        VStack(spacing: 40) {
            Button("Показать обычный алерт") {
                showAlert.toggle()
            }
            Button("Показать кастомный алерт") {
                let view = CustomSwiftUIAlertView(message: alertMessage)
                let hosting = UIHostingController(rootView: view)
                hosting.modalPresentationStyle = .overFullScreen
                hosting.modalTransitionStyle = .crossDissolve
                EasyAlert.shared.presentCustomUIKit(hosting)
            }
        }
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    EasyAlertExample()
}
