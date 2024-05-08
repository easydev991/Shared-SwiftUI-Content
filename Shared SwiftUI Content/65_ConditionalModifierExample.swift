import SwiftUI

extension View {
    @ViewBuilder
    func applyIf<M: View>(condition: Bool, transform: (Self) -> M) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

struct ConditionalModifierExample: View {
    @State private var isOn = false
    
    var body: some View {
        VStack {
            Toggle("Toggle", isOn: $isOn)
            Rectangle()
                .applyIf(
                    condition: isOn,
                    transform: { $0.frame(width: 100) }
                )
        }
        .animation(.linear(duration: 1), value: isOn)
        .padding(.horizontal)
        .frame(height: 200)
    }
}

struct ConditionalModifierExample2: View {
    @State private var isOn = false
    
    var body: some View {
        VStack {
            Toggle("Toggle", isOn: $isOn)
            Rectangle()
                .frame(width: isOn ? 100 : nil)
        }
        .animation(.linear(duration: 1), value: isOn)
        .padding(.horizontal)
        .frame(height: 200)
    }
}

struct ConditionalModifierExample3: View {
    @State private var isOn = false
    
    var body: some View {
        VStack {
            Toggle("Toggle", isOn: $isOn)
            Rectangle()
                .frame(width: isOn ? 100 : nil)
                .applyIf(condition: isOn) { $0.border(Color.red) }
        }
        .animation(.linear(duration: 1), value: isOn)
        .padding(.horizontal)
        .frame(height: 200)
    }
}

/// Вьюха, имеющая свое @State-свойство
struct StatefulView: View {
    @State private var text = ""
    
    var body: some View {
        TextField("My text", text: $text)
    }
}

/// Контейнер для `StatefulView`
struct StatefulViewExample: View {
    @State private var isRed = false
    
    var body: some View {
        VStack {
            StatefulView().applyIf(condition: isRed) {
                $0.background(Color.red)
            }
            Button("Change color") {
                isRed.toggle()
            }
        }
    }
}

#Preview("Проблема 1 - 1") {
    ConditionalModifierExample()
}

#Preview("Проблема 1 - 2") {
    ConditionalModifierExample3()
}

#Preview("Решение проблемы 1") {
    ConditionalModifierExample2()
}

#Preview("Проблема 2") {
    StatefulViewExample()
}
