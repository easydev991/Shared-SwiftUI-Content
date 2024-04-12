import SwiftUI

struct DrawingAndCompositingGroupExample: View {
    @State private var didTap = false
    
    var body: some View {
        movingExample
//        defaultExample
    }
    
    private var movingExample: some View {
        VStack(spacing: 50) {
            if didTap { Spacer() }
            demoTextButton
            demoTextInCircleButton
            if !didTap { Spacer() }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
    }
    
    private var demoTextButton: some View {
        Button(action: performMoveAction) {
            makeMovingTextView(title: "top")
                .drawingGroup() // <- тут
        }
    }
    
    private var demoTextInCircleButton: some View {
        Button(action: performMoveAction) {
            ZStack {
                Circle()
                    .fill(.black)
                    .frame(width: 200, height: 200)
                makeMovingTextView(title: "bot")
            }
            .compositingGroup() // <- тут
        }
        .buttonStyle(DemoButtonStyleWithShadow(didTap: didTap))
    }
    
    private func performMoveAction() {
        withAnimation(.linear(duration: 1)) { didTap.toggle() }
    }
    
    private func makeMovingTextView(title: String) -> some View {
        Text(didTap ? "TRUE (\(title))" : "FALSE (\(title))")
            .font(.title.bold())
    }
    
    /// Пример из документации
    private var defaultExample: some View {
        VStack {
            ZStack {
                Text("ExampleText")
                    .foregroundColor(.black)
                    .padding(20)
                    .background(Color.red)
                Text("ExampleText")
                    .blur(radius: 2)
            }
            .font(.largeTitle)
            .compositingGroup()
            .opacity(0.9)
        }
         .background(Color.white)
         .drawingGroup()
    }
}

/// Демо-стиль для кнопки, добавляющий обводку и тень
struct DemoButtonStyleWithShadow: ButtonStyle {
    let didTap: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                Circle().stroke(
                    didTap ? .blue : .red,
                    lineWidth: configuration.isPressed ? 10 : 2
                )
            )
            .foregroundStyle(didTap ? .blue : .red)
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
            .shadow(
                color: .green,
                radius: configuration.isPressed ? 0 : 5,
                x: configuration.isPressed ? 0 : 20,
                y: configuration.isPressed ? 0 : 20
            )
            .animation(.default, value: configuration.isPressed)
    }
}

#Preview {
    DrawingAndCompositingGroupExample()
}
