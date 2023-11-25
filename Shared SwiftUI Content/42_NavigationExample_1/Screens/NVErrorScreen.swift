import SwiftUI

/// Экран с ошибкой
///
/// Важно помнить про кнопку "Назад" и заголовок в навбаре,
/// если этот экран находится внутри `NavigationView`
struct NVErrorScreen: View {
    @EnvironmentObject private var viewModel: NVAppViewModel
    let message: String
    
    var body: some View {
        Self.makeView(
            message: message,
            closeAction: {
                viewModel.process(
                    action: .closeError(stayAuthorized: true)
                )
            },
            logoutAction: {
                viewModel.process(
                    action: .closeError(stayAuthorized: false)
                )
            }
        )
    }
}

extension NVErrorScreen {
    /// Создает вьюху для экрана с ошибкой
    /// - Parameters:
    ///   - message: Сообщение об ошибке
    ///   - closeAction: Действие по нажатию на кнопку "Закрыть"
    ///   - logoutAction: Действие по нажатию на кнопку "Выйти"
    /// - Returns: Вьюха с ошибкой
    static func makeView(
        message: String,
        closeAction: @escaping () -> Void,
        logoutAction: @escaping () -> Void
    ) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.warninglight")
                .font(.system(size: 40))
            Text(message).padding()
            Button("Закрыть", action: closeAction)
            Button("Выйти", role: .destructive, action: logoutAction)
        }
        .buttonStyle(.borderedProminent)
        .navigationTitle("")
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    NavigationView {
        NVErrorScreen(message: "Ошибка!")
            .environmentObject(NVAppViewModel())
    }
}
