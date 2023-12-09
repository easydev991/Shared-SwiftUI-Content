import SwiftUI

/// Корневой экран для примера навигации с использованием `TabView`
///
/// `TV` в наименованиях - сокращение от `TabView`
struct TVRootScreen: View {
    @State private var selectedTab = Tab.home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(Tab.allCases) { tab in
                tab.screen
                    .tabItem { tab.tabItemLabel }
                    .tag(tab)
            }
        }
    }
}

extension TVRootScreen {
    enum Tab: String, Identifiable, CaseIterable {
        var id: String { rawValue }
        
        case home
        case settings
        
        private var imageName: String {
            self == .home ? "house" : "gear"
        }
        
        var tabItemLabel: some View {
            Label(
                title: { Text(rawValue.capitalized) },
                icon: { Image(systemName: imageName) }
            )
        }
        
        @ViewBuilder
        var screen: some View {
            switch self {
            case .home: TVHomeScreen()
            case .settings: TVSettingsScreen()
            }
        }
    }
}

#Preview {
    TVRootScreen()
}
