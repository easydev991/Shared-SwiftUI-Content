import SwiftUI

struct TVHomeScreen: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "house")
            Text("Home screen").bold()
        }
        .font(.title)
    }
}

#Preview {
    TVHomeScreen()
}
