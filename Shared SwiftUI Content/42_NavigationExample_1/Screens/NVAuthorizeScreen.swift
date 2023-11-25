import SwiftUI

/// Экран "Авторизация"
struct NVAuthorizeScreen: View {
    @EnvironmentObject private var viewModel: NVAppViewModel
    @State private var model = Model()
    
    var body: some View {
        VStack(spacing: 20) {
            Group {
                TextField("Логин", text: $model.login)
                TextField("Пароль", text: $model.password)
            }
            .textFieldStyle(.roundedBorder)
            Button("Авторизоваться") {
                viewModel.process(action: .performAuth)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!model.canLogin)
            .animation(.default, value: model.canLogin)
        }
        .padding()
        .navigationTitle("Авторизация")
    }
}

private extension NVAuthorizeScreen {
    struct Model {
        var login = ""
        var password = ""
        
        /// Можно ли авторизоваться
        var canLogin: Bool {
            !login.isEmpty && !password.isEmpty
        }
    }
}

#Preview {
    NVAuthorizeScreen()
        .environmentObject(NVAppViewModel())
}
