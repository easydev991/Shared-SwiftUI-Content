import SwiftUI

struct ScenePhaseExample: View {
    @Environment(\.scenePhase) private var scenePhase
    private var phaseTitle: String {
        switch scenePhase {
        case .active: "Active"
        case .background: "Background"
        case .inactive: "Inactive"
        @unknown default: "Unknown"
        }
    }
    @State private var notificationText = ""
    
    var body: some View {
        finalContentView
    }
    
    private var finalContentView: some View {
        VStack(spacing: 20) {
            scenePhaseTextView
            notificationTextView
        }
    }
    
    private var scenePhaseTextView: some View {
        Text("Фаза сцены: \(phaseTitle)")
            .onChange(of: scenePhase) { newPhase in
                print("Новая фаза: \(newPhase)")
            }
    }
    
    private var notificationTextView: some View {
        Text("Уведомление: \(notificationText)")
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                setupNotificationText("willEnterForeground")
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                setupNotificationText("didBecomeActive")
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                setupNotificationText("willResignActive")
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
                setupNotificationText("didEnterBackground")
            }
    }
    
    private func setupNotificationText(_ text: String) {
        print("Уведомление: \(text)")
        notificationText = text
    }
}

#Preview {
    ScenePhaseExample()
}
