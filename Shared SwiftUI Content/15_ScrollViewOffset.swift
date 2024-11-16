import SwiftUI

struct ScrollViewOffsetDemo: View {
    let colors: [Color] = [ // 1
        .black, .blue, .brown, .gray,
        .green, .red, .cyan, .indigo, .yellow
    ]
    @State var offset = CGFloat.zero // 2

    let scrollConfig: _ScrollViewConfig = {
        var config = _ScrollViewConfig()
        // 3. Можно задать стартовый оффсет, поменяв значение для `y`
        config.contentOffset = .initially(.init(x: 0, y: 0))
        return config
    }()

    var body: some View {
        _ScrollView( // 4
            contentProvider: _AligningContentProvider(
                content: content
            ),
            config: scrollConfig
        )
        .overlay { // 5
            Text("Offset: \(offset.rounded().description)")
                .font(.title.bold())
                .foregroundColor(.white)
        }
        .onPreferenceChange(_ContainedScrollViewKey.self) { newValue in
            if let contentOffset = newValue?.contentOffset.y,
               offset != contentOffset {
                offset = contentOffset // 6
            }
        }
    }

    private var content: some View { // 7
        ForEach(colors, id: \.self) { color in
            color.frame(height: 200)
        }
    }
}

extension _ContainedScrollViewKey: @retroactive PreferenceKey {} // 8

#Preview { ScrollViewOffsetDemo() }
