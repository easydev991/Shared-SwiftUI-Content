import SwiftUI

/// Главный экран
struct NSMainScreen: View {
    @EnvironmentObject private var viewModel: NSAppViewModel
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
        .navigationTitle("Главный экран")
    }
}

extension NSMainScreen {
    /// Варианты навигации для главного экрана
    enum NavigationDestination {
        case profile
        case bookmarks
        case settings
    }
}

private extension NSMainScreen {
    var profileButton: some View {
        Button {
            viewModel.path.append(NavigationDestination.profile)
        } label: {
            Label("Профиль", systemImage: "person")
        }
    }
    
    var bookmarksButton: some View {
        Button {
            viewModel.path.append(NavigationDestination.bookmarks)
        } label: {
            Label("Закладки", systemImage: "bookmark")
        }
    }
    
    var settingsButton: some View {
        Button {
            viewModel.path.append(NavigationDestination.settings)
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
}

#Preview {
    NavigationStack {
        NSMainScreen()
            .environmentObject(NSAppViewModel())
    }
}
