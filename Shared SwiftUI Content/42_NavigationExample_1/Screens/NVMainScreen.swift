import SwiftUI

/// Главный экран
struct NVMainScreen: View {
    @EnvironmentObject private var viewModel: NVAppViewModel
    @State private var navigationDestination: NavigationDestination?
    @State private var showOnboarding = false
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 16) {
                profileButton
                bookmarksButton
            }
            settingsButton
        }
        .symbolVariant(.fill)
        .buttonStyle(.bordered)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                onboardingButton
                    .sheet(isPresented: $showOnboarding) {
                        onboardingView
                    }
            }
        }
        .onChange(of: viewModel.shouldPopToMain) { shouldPop in
            // Возвращаемся на главный экран
            if let shouldPop, shouldPop {
                navigationDestination = nil
                viewModel.didPopToMain()
            }
        }
        .background(
            NavigationLink(
                destination: destinationView,
                isActive: $navigationDestination.mappedToBool()
            )
        )
        .navigationTitle("Главный экран")
    }
}

private extension NVMainScreen {
    /// Варианты навигации для главного экрана
    enum NavigationDestination {
        case profile
        case bookmarks
        case settings
    }
    
    var profileButton: some View {
        Button {
            navigationDestination = .profile
        } label: {
            Label("Профиль", systemImage: "person")
        }
    }
    
    var bookmarksButton: some View {
        Button {
            navigationDestination = .bookmarks
        } label: {
            Label("Закладки", systemImage: "bookmark")
        }
    }
    
    var settingsButton: some View {
        Button {
            navigationDestination = .settings
        } label: {
            Label("Настройки", systemImage: "gear")
        }
    }
    
    var onboardingButton: some View {
        Button("Онбординг") {
            showOnboarding = true
        }
    }
    
    var onboardingView: some View {
        Text("Онбординг")
            .font(.title.bold())
    }
    
    @ViewBuilder
    var destinationView: some View {
        switch navigationDestination {
        case .profile: NVProfileScreen()
        case .bookmarks: NVBookmarksScreen()
        case .settings: NVSettingsScreen()
        case .none: EmptyView()
        }
    }
}

#Preview {
    NavigationView {
        NVMainScreen()
    }
}
