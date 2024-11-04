import SwiftUI

final class TestViewModel: ObservableObject {
    let number: Int
    
    init(number: Int) {
        self.number = number
        print("создаем \(number)")
    }
    
    deinit {
        print("удаляем \(number)")
    }
}

struct DemoLargeContentView: View {
    @State private var showSubview = true
    
    var body: some View {
        VStack(spacing: 20) {
            Button("\(showSubview ? "Скрыть" : "Показать")") {
                withAnimation {
                    showSubview.toggle()
                }
            }
            VStack(spacing: 20) {
                if showSubview {
                    DemoSubview123(number: 1)
                        .background(.green.opacity(0.5))
                }
                DemoSubview123(number: 2)
                    .opacity(showSubview ? 1 : 0)
                    .background(.red.opacity(0.5))
                DemoSubview123(number: 3)
                    .frame(
                        width: showSubview ? nil : 0,
                        height: showSubview ? nil : 0
                    )
                    .background(.yellow.opacity(0.5))
            }
            .border(.black, width: 2)
        }
    }
}

struct DemoSubview123: View {
    @StateObject private var viewModel: TestViewModel
    
    init(number: Int) {
        self._viewModel = .init(wrappedValue: .init(number: number))
    }
    
    var body: some View {
        Text("Вьюха № \(viewModel.number)")
    }
}

struct DemoParentView: View {
    @StateObject private var viewModel = TestViewModel(number: 1)
    @State private var showSubview = true
    
    var body: some View {
        VStack(spacing: 20) {
            Button("\(showSubview ? "Скрыть" : "Показать")") {
                withAnimation {
                    showSubview.toggle()
                }
            }
            if showSubview {
                Text("Вьюха № \(viewModel.number)")
            }
        }
    }
}

#Preview("Основное") {
    DemoLargeContentView()
}

#Preview("Бонус 2") {
    DemoParentView()
}
