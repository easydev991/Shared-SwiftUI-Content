import SwiftUI

struct EmptyViewExample: View {
    @State private var someState: SomeState? = .idle
    
    var body: some View {
        VStack(spacing: 20) {
            picker
            HStack {
                Text("1")
                fullSwitchCaseView
            }
            HStack {
                Text("2")
                ifLetElseView
            }
            HStack {
                Text("3")
                ifLetView
            }
            HStack {
                Text("4")
                optionalView
            }
            resetButton
        }
    }
    
    @ViewBuilder
    private var fullSwitchCaseView: some View {
        switch someState {
        case .ready: SomeState.ready.dummyView
        case .loading: SomeState.loading.dummyView
        case .error: SomeState.error.dummyView
        case .idle, nil: EmptyView().frame(width: 1000, height: 1000)
        }
    }
    
    @ViewBuilder
    private var ifLetElseView: some View {
        if let someState {
            someState.dummyView
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder
    private var ifLetView: some View {
        if let someState {
            someState.dummyView
        }
    }
    
    private var optionalView: some View {
        someState?.dummyView
    }
    
    private var picker: some View {
        Picker(
            "Демо-состояние",
            selection: .init(
                get: { someState ?? .idle },
                set: { someState = $0 }
            )
        ) {
            ForEach(SomeState.allCases) { option in
                Text(option.description)
            }
        }
    }
    
    private var resetButton: some View {
        Button("Сбросить на ожидание") {
            someState = nil
        }
    }
}

extension EmptyViewExample {
    enum SomeState: CaseIterable, Identifiable {
        var id: Self { self }
        case idle, ready, loading, error
        
        var description: String {
            switch self {
            case .idle: "в ожидании"
            case .ready: "готов"
            case .loading: "загрузка..."
            case .error: "ошибка!"
            }
        }
        
        @ViewBuilder
        var dummyView: some View {
            switch self {
            case .idle:
                EmptyView().frame(width: 1000, height: 1000)
            case .ready:
                Text("вьюха для состояния готовности")
            case .loading:
                Text("вьюха для загрузки")
            case .error:
                Text("вьюха для ошибки ‼️")
            }
        }
    }
}

#Preview {
    EmptyViewExample()
}
