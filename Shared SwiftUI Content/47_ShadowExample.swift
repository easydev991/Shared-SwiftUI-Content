import SwiftUI

extension Color {
    static var random: Self {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

struct ShadowModel {
    var color: Color
    var radius: CGFloat
    var x: CGFloat
    var y: CGFloat
    
    static var randomized: Self {
        .init(
            color: .random,
            radius: CGFloat.random(in: 0...16),
            x: CGFloat.random(in: -16...16),
            y: CGFloat.random(in: -16...16)
        )
    }
}

struct ShadowExample: View {
    @State private var shadowModel = ShadowModel.randomized
    
    var body: some View {
        VStack(spacing: 0) {
            settingsView
            Rectangle()
                .frame(height: 125)
                .foregroundStyle(.white)
                .overlay(alignment: .bottom) {
                    Text("Light mode preview")
                        .insideCard(shadowModel: shadowModel)
                        .padding(.bottom)
                }
            Rectangle()
                .ignoresSafeArea()
                .overlay(alignment: .top) {
                    Text("Dark mode preview")
                        .insideCard(shadowModel: shadowModel)
                        .padding(.top)
                        .environment(\.colorScheme, .dark)
                }
        }
    }
    
    private var settingsView: some View {
        Group {
            ColorPicker(
                "Цвет тени",
                selection: $shadowModel.color,
                supportsOpacity: false
            )
            Divider()
            VStack {
                Slider(value: $shadowModel.radius, in: 0...16, step: 1)
                Text("Радиус: \(makeRoundedText(for: shadowModel.radius))")
            }
            VStack {
                Slider(value: $shadowModel.x, in: -16...16)
                Text("Отступ по оси X: \(makeRoundedText(for: shadowModel.x))")
            }
            VStack {
                Slider(value: $shadowModel.y, in: -16...16)
                Text("Отступ по оси Y: \(makeRoundedText(for: shadowModel.y))")
            }
            Button("Randomize") {
                withAnimation { shadowModel = .randomized }
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 16)
        }
        .padding(.vertical, 4)
        .padding(.horizontal)
    }
    
    private func makeRoundedText(for value: CGFloat) -> String {
        String(format: "%.1f", value)
    }
}

struct CardModifier: ViewModifier {
    let padding: CGFloat
    let shadowModel: ShadowModel
    
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(.cardBackground)
                    .shadow(
                        color: shadowModel.color,
                        radius: shadowModel.radius,
                        x: shadowModel.x,
                        y: shadowModel.y
                    )
            }
    }
}

extension View {
    func insideCard(
        padding: CGFloat = 12,
        shadowModel: ShadowModel
    ) -> some View {
        modifier(
            CardModifier(
                padding: padding,
                shadowModel: shadowModel
            )
        )
    }
}

#Preview {
    ShadowExample()
}
