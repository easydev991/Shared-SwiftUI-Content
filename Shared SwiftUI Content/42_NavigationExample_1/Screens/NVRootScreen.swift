import SwiftUI

/// Корневой экран для примера навигации с использованием NavigationView
///
/// `NV` в наименованиях - сокращение от `NavigationView`
struct NVRootScreen: View {
    @StateObject private var viewModel = NVAppViewModel()
    
    var body: some View {
        NavigationView {
            contentView
        }
        .navigationViewStyle(.stack)
        .environmentObject(viewModel)
    }
}

private extension NVRootScreen {
    var contentView: some View {
        ZStack {
            switch viewModel.appState {
            case .notAuth:
                NVAuthorizeScreen()
                    .transition(.slide)
            case .auth:
                NVMainScreen()
                    .transition(.scale)
            case let .error(message):
                NVErrorScreen(message: message)
                    .transition(.move(edge: .trailing))
            case .none:
                EmptyView()
            }
        }
        .animation(.default, value: viewModel.appState)
    }
}

#Preview {
    NavigationView {
        NVRootScreen()
    }
}
