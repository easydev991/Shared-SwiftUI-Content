import SwiftUI

/*
 Проблема: если нажать на searchBar, и потом открыть экран с кругом, то при закрытии модалки свайпом произойдет пересоздание экрана с "кругом", что приведет к вызову всех событий onAppear/task, и отмене таска, соответственно.
 
 Решение: не использовать стандартный модификатор searchable, или заменить NavigationView на NavigationStack (iOS 16+), или сделать кастомные модалки, или игнорировать ошибку -999.
 */
struct SearchableBugExample: View {
    @State private var showSheet = false
    
    var body: some View {
        NavigationView {
            Button("Открыть модалку") {
                showSheet.toggle()
            }
            .sheet(isPresented: $showSheet) {
                NavigationView {
                    InnerModalView()
                }
            }
            .navigationTitle("Главный экран")
        }
    }
}

private struct InnerModalView: View {
    var body: some View {
        NavigationLink(destination: DemoViewWithTask()) {
            Text("Открыть вьюху с таском")
        }
        .navigationTitle("Модалка")
        .searchable(
            text: .constant(""),
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: ""
        )
    }
}

private struct DemoViewWithTask: View {
    @State private var counter = 0
    
    var body: some View {
        Self._printChanges()
        return Circle().frame(width: 300, height: 300)
            .overlay {
                VStack {
                    Text("Счетчик: \(counter)")
                    Button("Увеличить счетчик") {
                        counter += 1
                        print("счетчик: \(counter)")
                    }
                    .buttonStyle(.borderedProminent)
                }
                .background(.white)
            }
            .onAppear {
                logEvent("onAppear")
            }
            .task {
                logEvent("task")
            }
    }
    
    private func logEvent(_ event: String) {
        print(event)
        print("counter: \(counter)")
    }
}

#Preview {
    SearchableBugExample()
}
