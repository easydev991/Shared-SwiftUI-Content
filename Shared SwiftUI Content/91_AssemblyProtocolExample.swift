import SwiftUI
import PFVImplementation
import PFVInterface

// MARK: - Правильный вариант

struct MainContentView<Provider: GoodDemoViewProvider>: View {
    let viewProvider: Provider
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Все вьюхи ниже имеют тип `some View`")
            viewProvider.demoView
            viewProvider.makeDemoView()
        }
    }
}

#Preview("Правильно") {
    MainContentView(viewProvider: GoodDemoViewProviderImp())
}


// MARK: - Неправильный вариант

struct BadContentView: View {
    let viewProvider: BadDemoViewProvider
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Все вьюхи ниже имеют тип `AnyView`")
            viewProvider.demoView
            viewProvider.makeDemoView()
            AnyView(viewProvider.makeDemoView2())
        }
    }
}

#Preview("Неправильно") {
    BadContentView(viewProvider: BadDemoViewProviderImp())
}
