import SwiftUI
import Combine

enum NotificationCenterExample {
    static let notificationName = Notification.Name("демо.уведомление")
    
    struct DemoView: View {
        let text: String
        let clearAction: () -> Void
        let sendAction: () -> Void
        
        var body: some View {
            ZStack {
                if text.isEmpty {
                    Button("Отправить уведомление", action: sendAction)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                } else {
                    VStack(spacing: 20) {
                        Text(text).font(.title)
                        Button("Очистить", action: clearAction)
                    }
                    .transition(.slide.combined(with: .opacity).combined(with: .scale))
                }
            }
            .animation(.default, value: text.isEmpty)
        }
    }
    
    final class ViewModel: ObservableObject {
        @Published private(set) var text = ""
        private var cancellable: AnyCancellable?
        
        init() {
            cancellable = NotificationCenter.default
                .publisher(for: notificationName)
                .sink { notification in
                    if let text = notification.object as? String {
                        self.text = text
                    }
                }
        }
        
        deinit { cancellable?.cancel() }
        
        func sendAction() {
            NotificationCenter.default.post(
                name: notificationName,
                object: "Привет от NotificationCenter!"
            )
        }
        
        func clearAction() { text = "" }
    }
}

extension NotificationCenterExample {
    struct OnReceiveExample: View {
        @State private var notificationText = ""
        
        var body: some View {
            DemoView(
                text: notificationText,
                clearAction: { notificationText = "" },
                sendAction: {
                    NotificationCenter.default.post(
                        name: notificationName,
                        object: "Привет от NotificationCenter!"
                    )
                }
            )
            .onReceive(NotificationCenter.default.publisher(for: notificationName)) { notification in
                if let text = notification.object as? String {
                    notificationText = text
                }
            }
        }
    }
    
    struct ViewModelExample: View {
        @StateObject private var viewModel = ViewModel()
        
        var body: some View {
            DemoView(
                text: viewModel.text,
                clearAction: viewModel.clearAction,
                sendAction: viewModel.sendAction
            )
        }
    }
}

#Preview("Демо onReceive во вьюхе") {
    NotificationCenterExample.OnReceiveExample()
}

#Preview("Демо с ViewModel") {
    NotificationCenterExample.ViewModelExample()
}
