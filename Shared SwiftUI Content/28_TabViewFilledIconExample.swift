import SwiftUI

struct TabViewFilledIconExample: View {
    var body: some View {
        TabView {
            Color.green.opacity(0.5)
                .tabItem { // 1 - Первый "таб"
                    Image(systemName: "person")
                        .environment(\.symbolVariants, .none) // <- сбросили `symbolVariant`
                }
            Color.blue.opacity(0.5)
                .tabItem { // 2 - Второй "таб"
                    Image(systemName: "house")
                        .environment(\.symbolVariants, .none) // <- сбросили `symbolVariant`
                }
        }

    }
}

#Preview { TabViewFilledIconExample() }
