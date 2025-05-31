import SwiftUI

struct CustomNotificationExample: View {
    private let notificationCenter = UNUserNotificationCenter.current()
    @AppStorage(Key.isAuthorized.rawValue) private var isAuthorized = false
    @AppStorage(Key.dailyReminder.rawValue) private var dailyNotificationEnabled = false
    @AppStorage(Key.notificationTime.rawValue) private var notificationTime: Double = 0
    @State private var showNotificationError = false
    @State private var notificationError: NotificationError?
    
    var body: some View {
        NavigationStack {
            ZStack {
                if isAuthorized {
                    Form {
                        Toggle("Ежедневные уведомления", isOn: dailyNotificationBinding)
                        if dailyNotificationEnabled {
                            DatePicker(
                                "Время уведомлений",
                                selection: notificationTimeBinding,
                                displayedComponents: .hourAndMinute
                            )
                        }
                    }
                } else {
                    Text("Для доступа к уведомлениям нужно войти в учетную запись")
                        .font(.title)
                        .multilineTextAlignment(.leading)
                        .padding()
                        .transition(.slide.combined(with: .opacity))
                }
            }
            .animation(.default, value: isAuthorized)
            .navigationTitle("Настройки")
            .toolbar {
                ToolbarItem {
                    Button(isAuthorized ? "Выйти" : "Войти") {
                        isAuthorized.toggle()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(isAuthorized ? .red : .blue)
                }
            }
        }
        .onChange(of: isAuthorized) { newValue in
            // При выходе из учетки удаляем все запланированные уведомления
            // и выключаем ежедневные уведомления
            if !newValue {
                dailyNotificationEnabled = false
                notificationCenter.removeAllPendingNotificationRequests()
            }
        }
        .alert(
            isPresented: $showNotificationError,
            error: notificationError
        ) {
            Button("Отмена", role: .cancel) {}
            Button("В настройки") {
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                      UIApplication.shared.canOpenURL(settingsUrl)
                else { return }
                UIApplication.shared.open(settingsUrl)
            }
        }
    }
}

private extension CustomNotificationExample {
    enum Key: String {
        case isAuthorized
        case dailyReminder
        case notificationTime
    }
    
    enum NotificationError: Error, LocalizedError {
        case denied

        var errorDescription: String? {
            NSLocalizedString("Нет доступа к уведомлениям", comment: "")
        }
    }
    
    var defaultNotificationTime: Date {
        var components = DateComponents()
        components.hour = 10
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    var dailyNotificationBinding: Binding<Bool> {
        .init(
            get: { dailyNotificationEnabled },
            set: { newValue in
                setDailyNotification(newValue)
            }
        )
    }
    
    func setDailyNotification(_ enabled: Bool) {
        guard enabled else {
            dailyNotificationEnabled = false
            removePendingDailyNotifications()
            return
        }
        Task {
            let granted = await checkNotificationPermissions()
            dailyNotificationEnabled = granted
            if granted {
                scheduleDailyNotification()
            } else {
                showNotificationError = true
                notificationError = .denied
            }
        }
    }
    
    var notificationTimeBinding: Binding<Date> {
        .init(
            get: {
                notificationTime == 0
                ? defaultNotificationTime
                : Date(timeIntervalSinceReferenceDate: notificationTime)
            },
            set: { newDate in
                notificationTime = newDate.timeIntervalSinceReferenceDate
                if dailyNotificationEnabled {
                    scheduleDailyNotification()
                }
            }
        )
    }
    
    func checkNotificationPermissions() async -> Bool {
        let center = UNUserNotificationCenter.current()
        let granted = try? await center.requestAuthorization(options: [.alert, .sound])
        return granted ?? false
    }
    
    func scheduleDailyNotification() {
        removePendingDailyNotifications()

        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("Заголовок уведомления", comment: "")
        content.body = NSLocalizedString("Тело уведомления", comment: "")
        content.sound = .default

        let components = Calendar.current.dateComponents(
            [.hour, .minute],
            from: notificationTimeBinding.wrappedValue
        )
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: components,
            repeats: true
        )
        let request = UNNotificationRequest(
            identifier: Key.dailyReminder.rawValue,
            content: content,
            trigger: trigger
        )
        notificationCenter.add(request)
    }

    func removePendingDailyNotifications() {
        notificationCenter.removePendingNotificationRequests(
            withIdentifiers: [Key.dailyReminder.rawValue]
        )
    }
}

#Preview {
    CustomNotificationExample()
}
