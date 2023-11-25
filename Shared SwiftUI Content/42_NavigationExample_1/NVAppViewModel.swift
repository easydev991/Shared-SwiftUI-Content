import SwiftUI

/// "Вьюмодель" для приложения, управляет состоянием приложения
///
/// Эту роль может выполнять `AppDelegate`/`SceneDelegate`, например,
/// если воспользоваться `@UIApplicationDelegateAdaptor` и подключить оба делегата к приложению.
/// Тогда можно будет обращаться к appDelegate/sceneDelegate через @EnvironmentObject
/// без дополнительного применения модификатора `.environmentObject`
@MainActor
final class NVAppViewModel: ObservableObject {
    /// Авторизован ли пользователь
    @AppStorage("isAuthorized") private var isAuthorized = false
    /// Состояние приложения
    @Published private(set) var appState: AppState?
    /// Нужно ли вернуться на главный экран
    @Published private(set) var shouldPopToMain: Bool?
    
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
            appState = .notAuth
            isAuthorized = false
        case let .showError(string):
            appState = .error(string)
        case let .closeError(stayAuthorized):
            appState = stayAuthorized ? .auth : .notAuth
            isAuthorized = stayAuthorized
        }
    }
    
    func popToMain() {
        shouldPopToMain = true
    }
    
    func didPopToMain() {
        shouldPopToMain = nil
    }
}

extension NVAppViewModel {
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
