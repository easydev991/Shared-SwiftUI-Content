import SwiftUI

struct NotificationBadgeExample: View {
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage("isAuthorized") private var isAuthorized = false
    @State private var counter = 0
    @State private var badgeUpdateTask: Task<Void, Never>?
    
    var body: some View {
        TabView {
            MessagesView(counter: $counter)
                .tabItem {
                    Image(systemName: "message")
                    Text("Сообщения")
                }
                .badge(counter)
            
            ProfileView(isAuthorized: $isAuthorized)
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Профиль")
                }
        }
        .onChange(of: isAuthorized, perform: updateAppIconBadge)
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .background:
                updateAppIconBadge(isAuthorized)
            default: break
            }
        }
    }
    
    private func updateAppIconBadge(_ isAuthorized: Bool) {
        guard isAuthorized else {
            UIApplication.shared.applicationIconBadgeNumber = 0
            return
        }
        badgeUpdateTask?.cancel()
        badgeUpdateTask = Task {
            let center = UNUserNotificationCenter.current()
            let granted = try? await center.requestAuthorization(options: [.badge])
            guard granted == true else { return }
            guard UIApplication.shared.applicationIconBadgeNumber != counter else { return }
            UIApplication.shared.applicationIconBadgeNumber = counter
        }
    }
}

/// Демо-экран сообщений
private struct MessagesView: View {
    @Binding var counter: Int
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Новые сообщения: \(counter)")
                    .contentTransition(.numericText())
                    .font(.largeTitle)
                
                HStack {
                    Button("Добавить") {
                        counter += 1
                    }
                    .buttonStyle(.borderedProminent)
                    
                    if counter > 0 {
                        Button("Прочитать все") {
                            counter = 0
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            .animation(.default, value: counter)
            .navigationTitle("Сообщения")
        }
    }
}

/// Демо-экран профиля
private struct ProfileView: View {
    @Binding var isAuthorized: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text(isAuthorized ? "Авторизован ✅" : "Не авторизован ❌")
                    .font(.title2)
                    .foregroundStyle(isAuthorized ? .green : .red)
                
                Button(
                    isAuthorized ? "Выйти" : "Войти",
                    action: toggleAuthorization
                )
                .buttonStyle(.borderedProminent)
                .tint(isAuthorized ? .red : .blue)
            }
            .navigationTitle("Профиль")
        }
    }
    
    private func toggleAuthorization() {
        withAnimation {
            isAuthorized.toggle()
        }
    }
}

#Preview {
    NotificationBadgeExample()
}
