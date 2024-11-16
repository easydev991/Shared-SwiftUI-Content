import SwiftUI

@MainActor
final class BackgroundTaskViewModel: ObservableObject {
    @Published private(set) var text = "Дождитесь СМС со ссылкой для авторизации"
    private var taskIdentifier: UIBackgroundTaskIdentifier?
    
    func requestSMSForAuth() async {
        do {
            try await requestSMS()
            text = "Авторизация успешна"
        } catch {
            text = "Ошибка авторизации: \(error.localizedDescription)"
        }
        
    }
    
    private func requestSMS() async throws {
        // Создаем таск для фоновой работы, чтобы завершить его
        // после успешной авторизации
        let taskId = startBackgroundTask()
        // Имитируем выполнение запроса
        try await Task.sleep(for: .seconds(5))
        // После завершения авторизации завершаем таск для фоновой работы
        UIApplication.shared.endBackgroundTask(taskId)
    }
    
    /// Создает фоновый таск и возвращает его идентификатор
    private func startBackgroundTask() -> UIBackgroundTaskIdentifier {
        taskIdentifier = UIApplication.shared.beginBackgroundTask { [weak self] in
            // Блок, выполняющийся при завершении таска, нужно вызвать `endBackgroundTask`
            UIApplication.shared.endBackgroundTask(self?.taskIdentifier ?? .invalid)
        }
        return taskIdentifier ?? .invalid
    }
}

struct BackgroundTaskExample: View {
    @StateObject private var viewModel = BackgroundTaskViewModel()
    
    var body: some View {
        VStack {
            Text(viewModel.text)
            Spacer()
        }
        .task { await viewModel.requestSMSForAuth() }
    }
}

#Preview {
    BackgroundTaskExample()
}
