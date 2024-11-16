import SwiftUI

extension Int {
    /// Является ли число нечётным
    var isOdd: Bool { self % 2 != 0 }
}

enum EquatableExample {
    struct ContentView: View {
        @State private var n = 3
        
        var body: some View {
            VStack(spacing: 20) {
                BrokenView1(number: n)
                BrokenView2(number: n, isOdd: n.isOdd)
                HardView(number: n, isOdd: n.isOdd)
                EasyFinalView(isOdd: n.isOdd)
                    
                Button("Сгенерировать число") {
                    n = Int.random(in: 1...1000)
                }
                Text("\(n)")
            }
        }
    }
    
    struct BrokenView1: View, Equatable {
        let number: Int
        
        var body: some View {
            print("Вычисляем body 1, isOdd = \(number.isOdd)")
            return ExampleTextView(
                text: number.isOdd ? "Нечётный" : "Чётный",
                backgroundColor: number.isOdd ? Color.red : Color.green
            )
        }
        
        nonisolated static func == (lhs: BrokenView1, rhs: BrokenView1) -> Bool {
            lhs.number.isOdd == rhs.number.isOdd
        }
    }
    
    struct BrokenView2: View, Equatable {
        let number: Int
        let isOdd: Bool
        
        var body: some View {
            print("Вычисляем body 2, isOdd = \(isOdd)")
            return ExampleTextView(
                text: isOdd ? "Нечётный" : "Чётный",
                backgroundColor: isOdd ? Color.red : Color.green
            )
        }
        
        nonisolated static func == (lhs: BrokenView2, rhs: BrokenView2) -> Bool {
            lhs.number.isOdd == rhs.number.isOdd
        }
    }

    struct HardView: View, Equatable {
        let number: Int
        let isOdd: Bool
        @State private var test = true
        
        var body: some View {
            print("Вычисляем body 3, isOdd = \(isOdd)")
            return ExampleTextView(
                text: isOdd ? "Нечётный" : "Чётный",
                backgroundColor: isOdd ? Color.red : Color.green
            )
            .rotationEffect(.degrees(test ? 0 : 360))
        }
        
        nonisolated static func == (lhs: HardView, rhs: HardView) -> Bool {
            lhs.number.isOdd == rhs.number.isOdd
//            lhs.isOdd == rhs.isOdd // <- тоже рабочий вариант
        }
    }
    
    struct EasyFinalView: View {
        let isOdd: Bool
        
        var body: some View {
            print("Вычисляем body 4, isOdd = \(isOdd)")
            return ExampleTextView(
                text: isOdd ? "Нечётный" : "Чётный",
                backgroundColor: isOdd ? Color.red : Color.green
            )
        }
    }
    
    struct ExampleTextView: View {
        let text: String
        let backgroundColor: Color
        
        var body: some View {
            Text(text)
                .foregroundStyle(.white)
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(backgroundColor)
                )
        }
    }
}


#Preview {
    EquatableExample.ContentView()
}
