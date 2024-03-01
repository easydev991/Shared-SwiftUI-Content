import SwiftUI

enum ScrollToExample {
    struct EasyView: View {
        var body: some View {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack {
                        makeScrollButton("Вниз", id: -1) {
                            proxy.scrollTo(1001)
                        }
                        ForEach(Array(0...1000), id: \.self) { i in
                            Text(i.description)
                        }
                        makeScrollButton("Наверх", id: 1001) {
                            proxy.scrollTo(-1)
                        }
                    }
                }
            }
        }
        
        private func makeScrollButton(
            _ title: String,
            id: Int,
            action: @escaping () -> Void
        ) -> some View {
            HStack {
                Spacer()
                Button(title) {
                    withAnimation { action() }
                }
                .buttonStyle(.bordered)
                .padding(.trailing)
            }
            .id(id)
        }
    }
    
    struct ComplexView: View {
        /// Прогресс загрузки данных
        private enum Progress: Equatable {
            case loading
            case ready([Int])
        }
        /// Табы для разных вариантов контента
        private enum Tab: String, CaseIterable {
            case a, b, c
        }
        @State private var progress = Progress.loading
        @State private var selectedTab = Tab.a
        @State private var getItemsTask: Task<Void, Never>?
        
        var body: some View {
            VStack(spacing: 20) {
                tabs
                ScrollViewReader { proxy in
                    ScrollView {
                        ZStack {
                            switch progress {
                            case .loading:
                                skeletons
                            case .ready(let array):
                                makeReadyView(array)
                            }
                        }
                        .onChange(of: progress) { newValue in
                            if case .loading = newValue {
                                proxy.scrollTo(0)
                            }
                        }
                        .onChange(of: selectedTab) { _ in
                            getItems()
                        }
                    }
                }
            }
            .animation(.default, value: progress)
            .padding(.horizontal)
            .onAppear { getItems() }
        }
        
        private var tabs: some View {
            HStack(spacing: 32) {
                ForEach(Tab.allCases, id: \.self) { option in
                    Button(option.rawValue) {
                        selectedTab = option
                    }
                    .tint(option == selectedTab ? .blue : .gray)
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        
        private var skeletons: some View {
            VStack(spacing: 16) {
                ForEach(0..<5, id: \.self) { _ in // Обязательно должен быть id или Identifiable-элементы
                    Rectangle()
                        .frame(height: 120)
                        .skeleton()
                }
            }
        }
        
        private func makeReadyView(_ items: [Int]) -> some View {
            LazyVStack(spacing: 32) {
                ForEach(items, id: \.self) { i in // Обязательно должен быть id или Identifiable-элементы
                    Text("Элемент \(i)")
                }
            }
        }
        
        private func getItems() {
            progress = .loading
            getItemsTask = Task {
                // Имитируем очень быстрый ответ сервера
                try? await Task.sleep(for: .seconds(0.1))
                progress = .ready(Array(0...30))
            }
        }
    }
}

#Preview("Простой сценарий") {
    ScrollToExample.EasyView()
}

#Preview("Сложный сценарий") {
    ScrollToExample.ComplexView()
}
