import SwiftUI

struct ContentTransitionExample: View {
    @State private var count = 0

    var body: some View {
        VStack(spacing: 20) {
            buttonsView
            textView
            textView
                .contentTransition(.numericText())
        }
        .animation(.linear(duration: 2), value: count)
    }
    
    private var textView: some View {
        Text("Число: \(count)")
            .font(.title)
    }
    
    private var buttonsView: some View {
        HStack(spacing: 20) {
            Button("Вычесть") {
                count -= Int.random(in: 1...1000000)
            }
            Button("Прибавить") {
                count += Int.random(in: 1...1000000)
            }
        }
    }
}

struct DemoFromApple: View {
    private static let font1 = Font.system(size: 20)
    private static let font2 = Font.system(size: 45)

    @State private var color = Color.red
    @State private var currentFont = font1

    var body: some View {
        VStack(spacing: 50) {
            Text("Демо из документации")
                .foregroundColor(color)
                .font(currentFont)
                .contentTransition(.interpolate)
            Button("Экшен") {
                withAnimation(.bouncy(duration: 2.0)) {
                    color = color == .red ? .green : .red
                    currentFont = currentFont == DemoFromApple.font1
                    ? DemoFromApple.font2
                    : DemoFromApple.font1
                }
            }
        }
    }
}

#Preview {
    ContentTransitionExample()
}

#Preview {
    DemoFromApple()
}
