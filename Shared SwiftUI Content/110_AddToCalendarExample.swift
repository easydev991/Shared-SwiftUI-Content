import EventKit
import EventKitUI
import SwiftUI

final class CalendarManager: ObservableObject {
    let eventStore = EKEventStore()
    @Published var showCalendar = false
    @Published var showSettingsAlert = false
    private var isRunningPreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }

    @MainActor
    func requestAccess() {
        if isRunningPreview {
            // в превью нельзя запросить доступы
            showCalendar = true
        } else {
            switch EKEventStore.authorizationStatus(for: .event) {
            case .fullAccess: showCalendar = true
            case .restricted, .denied: showSettingsAlert = true
            default:
                eventStore.requestAccess(to: .event) { [weak self] granted, _ in
                    DispatchQueue.main.async {
                        self?.showCalendar = granted
                        self?.showSettingsAlert = !granted
                    }
                }
            }
        }
    }
}

/// Обертка для стандартного календаря - `EKEventEditViewController`
struct EKEventEditViewControllerRepresentable: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss
    let eventStore: EKEventStore
    let event: EventModel

    func makeUIViewController(context: Context) -> EKEventEditViewController {
        let controller = EKEventEditViewController()
        controller.eventStore = eventStore
        controller.editViewDelegate = context.coordinator
        let eventDate = event.beginDate
        let ekevent = EKEvent(eventStore: eventStore)
        ekevent.title = event.title
        ekevent.startDate = eventDate
        ekevent.endDate = eventDate.addingTimeInterval(3600) // +1 час
        ekevent.calendar = eventStore.defaultCalendarForNewEvents
        ekevent.location = event.location
        ekevent.notes = event.description
        ekevent.url = event.shareLink
        ekevent.addAlarm(.init(relativeOffset: -3600)) // Напоминание за 1 час
        controller.event = ekevent
        return controller
    }

    func updateUIViewController(_: EKEventEditViewController, context _: Context) {}

    func makeCoordinator() -> Coordinator { .init(parent: self) }

    final class Coordinator: NSObject, @preconcurrency EKEventEditViewDelegate {
        private let parent: EKEventEditViewControllerRepresentable

        init(parent: EKEventEditViewControllerRepresentable) {
            self.parent = parent
        }

        @MainActor
        func eventEditViewController(_: EKEventEditViewController, didCompleteWith _: EKEventEditViewAction) {
            parent.dismiss()
        }
    }
}

struct EventModel {
    var beginDate: Date
    var title: String
    var location: String
    var description: String
    let shareLink: URL?
}

struct AddToCalendarExample: View {
    @StateObject private var calendarManager = CalendarManager()
    @State private var event = EventModel(
        beginDate: .now,
        title: "Демо-событие",
        location: "Главная улица, 1",
        description: "Описание демо-события",
        shareLink: .init(string: "https://github.com/easydev991/Shared-SwiftUI-Content")
    )
    
    var body: some View {
        VStack(spacing: 20) {
            datePickerView
            Group {
                titleTextField
                locationTextField
                descriptionTextField
            }
            .textFieldStyle(.roundedBorder)
            addToCalendarButton
                .sheet(isPresented: $calendarManager.showCalendar) {
                    EKEventEditViewControllerRepresentable(
                        eventStore: calendarManager.eventStore,
                        event: event
                    )
                }
        }
        .padding()
        .alert(
            "Необходимо разрешить полный доступ к календарю в настройках телефона",
            isPresented: $calendarManager.showSettingsAlert
        ) {
            Button("Отмена", role: .cancel) {}
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                Link("Перейти в настройки", destination: settingsURL)
            }
        }
    }
    
    private var datePickerView: some View {
        DatePicker(
            "Дата и время",
            selection: $event.beginDate,
            displayedComponents: [.date, .hourAndMinute]
        )
    }
    
    private var titleTextField: some View {
        TextField("Название события", text: $event.title)
    }
    
    private var locationTextField: some View {
        TextField("Место проведения", text: $event.location)
    }
    
    private var descriptionTextField: some View {
        TextField("Описание", text: $event.description, axis: .vertical)
            .lineLimit(2...4)
    }
    
    private var addToCalendarButton: some View {
        Button("Добавить в календарь", action: calendarManager.requestAccess)
            .buttonStyle(.borderedProminent)
    }
}

#Preview {
    AddToCalendarExample()
}
