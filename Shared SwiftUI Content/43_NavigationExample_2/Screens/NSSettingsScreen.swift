import SwiftUI

/// Экран "Настройки"
struct NSSettingsScreen: View {
    @EnvironmentObject private var viewModel: NSAppViewModel
    @State private var screenState = ScreenState.regular
    
    var body: some View {
        ZStack {
            switch screenState {
            case .regular: regularView
            case let .error(message):
                NSErrorScreen.makeView(
                    message: message,
                    closeAction: {
                        screenState = .regular
                    },
                    logoutAction: {
                        viewModel.process(
                            action: .closeError(stayAuthorized: false)
                        )
                    }
                )
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .animation(.default, value: screenState)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension NSSettingsScreen {
    enum ScreenState: Equatable {
        case regular
        case error(String)
    }
    
    var regularView: some View {
        ScrollView {
            VStack(spacing: 8) {
                ForEach(1..<5) { id in
                    VStack(spacing: 0) {
                        makeDemoOptionView(id: id)
                        Divider()
                    }
                }
                Button("Показать ошибку") {
                    screenState = .error("Демо-ошибка")
                }
            }
            .padding()
        }
        .navigationTitle("Настройки")
    }
    
    func makeDemoOptionView(id: Int) -> some View {
        NavigationLink {
            Button("Вернуться на главную", action: viewModel.popToRoot)
                .navigationTitle("Настройка")
        } label: {
            Text("Опция \(id)")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 8)
        }
    }
}

#Preview {
    NavigationStack {
        NSSettingsScreen()
            .environmentObject(NSAppViewModel())
    }
}
