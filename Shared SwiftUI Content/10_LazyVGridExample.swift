import SwiftUI

struct LazyVGridExample: View {
    private let colors: [Color] = [.black, .blue, .brown, .gray, .green, .red, .cyan, .indigo, .yellow]

    var body: some View {
        LazyVGrid(
            columns: Array(repeating: .init(spacing: 0), count: 3),
            spacing: 0
        ) {
            ForEach(colors, id: \.description) { color in
                color.frame(height: 50)
            }
        }
    }
}

#Preview { LazyVGridExample() }
