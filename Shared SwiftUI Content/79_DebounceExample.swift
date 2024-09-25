import Combine
import SwiftUI

final class DebounceViewModel : ObservableObject {
    @Published var searchQuery = ""
    @Published private(set) var debouncedText = ""
    
    init(delay: DispatchQueue.SchedulerTimeType.Stride) {
        $searchQuery
            .debounce(for: delay, scheduler: DispatchQueue.main)
            .assign(to: &$debouncedText)
    }
}

struct DebounceExampleView: View {
    @StateObject private var viewModel: DebounceViewModel
    
    init(debounceDelay: DispatchQueue.SchedulerTimeType.Stride) {
        self._viewModel = .init(wrappedValue: .init(delay: debounceDelay))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Что ищем?", text: $viewModel.searchQuery)
                .textFieldStyle(.roundedBorder)
            if !viewModel.debouncedText.isEmpty {
                Text("Пользователь ввел запрос для поиска:")
                Text(viewModel.debouncedText)
            }
        }
        .padding()
        Spacer()
    }
}

#Preview("1 секунда") {
    DebounceExampleView(debounceDelay: .seconds(1))
}

#Preview("0.5 секунды") {
    DebounceExampleView(debounceDelay: .seconds(0.5))
}
