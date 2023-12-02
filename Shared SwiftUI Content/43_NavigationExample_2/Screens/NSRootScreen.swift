import SwiftUI

/// Корневой экран для примера навигации с использованием `NavigationStack`
///
/// `NS` в наименованиях - сокращение от `NavigationStack`
struct NSRootScreen: View {
    @StateObject private var viewModel = NSAppViewModel()
    
    var body: some View {
        NavigationStack(path: $viewModel.path) {
            contentView
                .navigationDestination(
                    for: NSMainScreen.NavigationDestination.self
                ) { destination in
                    switch destination {
                    case .profile: NSProfileScreen()
                    case .settings: NSSettingsScreen()
                    case .bookmarks: NSBookmarksScreen()
                    }
                }
        }
        .environmentObject(viewModel)
    }
}

private extension NSRootScreen {
    var contentView: some View {
        ZStack {
            switch viewModel.appState {
            case .notAuth:
                NSAuthorizeScreen()
                    .transition(.slide)
            case .auth:
                NSMainScreen()
                    .transition(.scale)
            case let .error(message):
                NSErrorScreen(message: message)
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            case .none:
                EmptyView()
            }
        }
        .animation(.default, value: viewModel.appState)
    }
}

#Preview { NSRootScreen() }
