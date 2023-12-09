import SwiftUI

struct TVSettingsScreen: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "gear")
            Text("Settings screen").bold()
        }
        .font(.title)
    }
}

#Preview {
    TVSettingsScreen()
}
