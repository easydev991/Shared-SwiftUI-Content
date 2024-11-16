import UIKit

enum ColorThemeService {
    /// Варианты темы
    enum Theme {
        case dark
        case light
        case system
    }

    /// Задает выбранную тему для приложения
    ///
    /// Можно вызвать внутри `onAppear` на самой первой вьюшке в иерархии приложения
    /// - Parameter newValue: Новая тема
    @MainActor static func set(_ newValue: Theme) {
        var userInterfaceStyle: UIUserInterfaceStyle
        switch newValue {
        case .dark:
            userInterfaceStyle = .dark
        case .light:
            userInterfaceStyle = .light
        case .system:
            userInterfaceStyle = .unspecified
        }
        let keyWindow = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .last(where: \.isKeyWindow)
        keyWindow?.overrideUserInterfaceStyle = userInterfaceStyle
    }
}
