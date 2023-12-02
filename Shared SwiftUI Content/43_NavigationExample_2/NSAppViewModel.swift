import SwiftUI

/// "Вьюмодель" для приложения, управляет состоянием приложения
///
/// Эту роль может выполнять `AppDelegate`/`SceneDelegate`, например,
/// если воспользоваться `@UIApplicationDelegateAdaptor` и подключить оба делегата к приложению.
/// Тогда можно будет обращаться к appDelegate/sceneDelegate через @EnvironmentObject
/// без дополнительного применения модификатора `.environmentObject`
@MainActor
final class NSAppViewModel: ObservableObject {
    @Published var path = NavigationPath()
    /// Авторизован ли пользователь
    @AppStorage("isAuthorized") private var isAuthorized = false
    /// Состояние приложения
    @Published private(set) var appState: AppState?
    
    init() {
        appState = isAuthorized ? .auth : .notAuth
    }
    
    /// Обрабатывает действие
    func process(action: AppAction) {
        switch action {
        case .performAuth:
            appState = .auth
            isAuthorized = true
        case .performLogout:
            popToRoot()
            appState = .notAuth
            isAuthorized = false
        case let .showError(string):
            popToRoot()
            appState = .error(string)
        case let .closeError(stayAuthorized):
            appState = stayAuthorized ? .auth : .notAuth
            isAuthorized = stayAuthorized
            if !stayAuthorized { popToRoot() }
        }
    }
    
    func popToRoot() {
        path = .init()
    }
}

extension NSAppViewModel {
    /// Верхнеуровневое состояние приложения
    enum AppState: Equatable {
        case notAuth
        case auth
        case error(String)
    }
    
    /// Верхнеуровневые действия, доступные в приложении
    enum AppAction {
        case performAuth
        case performLogout
        case showError(String)
        case closeError(stayAuthorized: Bool)
    }
}
