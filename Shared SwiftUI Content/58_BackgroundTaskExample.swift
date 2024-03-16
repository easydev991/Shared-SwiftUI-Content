import SwiftUI

struct BackgroundTaskExample: View {
    var body: some View {
        VStack {
            Text("Дождитесь СМС со ссылкой для авторизации")
            Spacer()
        }
        .task { await requestSMS() }
    }
    
    /// Создает фоновый таск и возвращает его идентификатор
    private func startBackgroundTask() -> UIBackgroundTaskIdentifier {
        var identifier: UIBackgroundTaskIdentifier?
        identifier = UIApplication.shared.beginBackgroundTask {
            // Блок, выполняющийся при завершении таска, нужно вызвать `endBackgroundTask`
            UIApplication.shared.endBackgroundTask(identifier ?? .invalid)
        }
        return identifier ?? .invalid
    }
    
    private func requestSMS() async {
        // Создаем таск для фоновой работы, чтобы завершить его
        // после успешной авторизации
        let taskId = startBackgroundTask()
        // Выполняем запрос
        // await myService.requestSMSForAuth()
        // После завершения авторизации завершаем таск для фоновой работы
        await UIApplication.shared.endBackgroundTask(taskId)
    }
}
