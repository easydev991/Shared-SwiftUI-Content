import SwiftUI
import OSLog

struct LoggerExample: View {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "PostListScreen")
    @State private var posts = [PostModel]()
    @State private var isLoading = false
    @State private var showLogs = false

    var body: some View {
        NavigationView {
            List(posts) { post in
                VStack(alignment: .leading, spacing: 12) {
                    Text(post.title).font(.title3).bold()
                    Text(post.body)
                }
            }
            .overlay {
                ProgressView().opacity(isLoading ? 1 : 0)
            }
            .animation(.easeInOut, value: isLoading)
            .task { await downloadPosts() }
            .navigationTitle("Список постов")
            .toolbar {
                Button("Логи") {
                    logger.info("Нажали на кнопку для открытия логов")
                    showLogs.toggle()
                }
            }
            .background(
                NavigationLink(
                    destination: LogsView(),
                    isActive: $showLogs
                )
            )
        }
    }

    private func downloadPosts() async {
        logger.info("Вызвали метод `downloadPosts`")
        let stringURL = "https://jsonplaceholder.typicode.com/posts"
        guard let url = URL(string: stringURL) else {
            logger.error("Не удалось собрать URL из строки: \(stringURL, privacy: .public)")
            return
        }
        isLoading = true
        do {
            logger.debug("Начинаем загрузку постов")
            let (data, _) = try await URLSession.shared.data(for: .init(url: url))
            posts = try JSONDecoder().decode([PostModel].self, from: data)
            logger.debug("Успешно загрузили посты, \(posts.count, privacy: .public) шт.")
        } catch {
            logger.error("Не удалось получить данные, ошибка: \(error.localizedDescription, privacy: .public)")
        }
        isLoading = false
    }
}

private final class LoggerGetter: ObservableObject {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "LoggerGetter")
    @Published private(set) var state = State.empty
    var logs: [State.LogModel] {
        switch state {
        case .empty, .loading: []
        case let .ready(array): array
        }
    }

    /// Все категории, которые есть в логах
    @Published private(set) var categories = [String]()
    /// Все уровни, которые есть в логах
    @Published private(set) var levels = [State.LogModel.Level]()

    func getLogs() async {
        logger.info("Начали загружать логи")
        await MainActor.run { state = .loading }
        do {
            let store = try OSLogStore(scope: .currentProcessIdentifier)
            let position = store.position(timeIntervalSinceLatestBoot: 1)
            let entries: [State.LogModel] = try store
                .getEntries(at: position)
                .compactMap { $0 as? OSLogEntryLog }
                .filter { $0.subsystem == Bundle.main.bundleIdentifier! }
                .map {
                    .init(
                        dateString: $0.date.formatted(date: .long, time: .standard),
                        category: $0.category,
                        level: .init(rawValue: $0.level.rawValue) ?? .undefined,
                        message: $0.composedMessage
                    )
                }
            let uniqueCategories = Array(Set(entries.map(\.category)))
            let uniqueLevels = Array(Set(entries.map(\.level)))
            logger.info("Успешно загрузили логи")
            await MainActor.run {
                categories = uniqueCategories
                levels = uniqueLevels
                state = .ready(entries)
            }
        } catch {
            logger.error("\(error.localizedDescription, privacy: .public)")
            await MainActor.run { state = .empty }
        }
    }

    enum State: Equatable {
        case empty, loading, ready([LogModel])

        var isLoading: Bool { self == .loading }

        struct LogModel: Identifiable, Equatable {
            let id = UUID()
            let dateString: String
            let category: String
            let level: Level
            let message: String

            enum Level: Int, CaseIterable, Identifiable {
                var id: Int { rawValue }
                case undefined = 0
                case debug = 1
                case info = 2
                case notice = 3
                case error = 4
                case fault = 5

                var emoji: String {
                    switch self {
                    case .undefined: "🤨"
                    case .debug: "🛠️"
                    case .info: "ℹ️"
                    case .notice: "💁‍♂️"
                    case .error: "⚠️"
                    case .fault: "⛔️"
                    }
                }
            }
        }
    }
}

struct LogsView: View {
    @StateObject private var loggerGetter = LoggerGetter()
    @State private var categoriesToShow = [String]()
    @State private var levelsToShow = [LoggerGetter.State.LogModel.Level]()
    @State private var showFilter = false
    private var isFilterOn: Bool {
        !categoriesToShow.isEmpty || !levelsToShow.isEmpty
    }
    private var filteredLogs: [LoggerGetter.State.LogModel] {
        if isFilterOn {
            let filterCategories = !categoriesToShow.isEmpty
            let filterLevels = !levelsToShow.isEmpty
            return loggerGetter.logs.filter { log in
                let hasCategory = filterCategories
                    ? categoriesToShow.contains(log.category)
                    : true
                let hasLevel = filterLevels
                    ? levelsToShow.contains(log.level)
                    : true
                return hasCategory && hasLevel
            }
        } else {
            return loggerGetter.logs
        }
    }
    
    var body: some View {
        contentView
            .animation(.default, value: loggerGetter.state)
            .overlay {
                ProgressView()
                    .opacity(loggerGetter.state.isLoading ? 1 : 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Логи")
            .task { await loggerGetter.getLogs() }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showFilter.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .symbolVariant(isFilterOn ? .fill : .none)
                    }
                    .disabled(loggerGetter.state.isLoading)
                }
            }
            .sheet(isPresented: $showFilter) { filterView }
    }
    
    private var contentView: some View {
        ZStack {
            switch loggerGetter.state {
            case .empty:
                Text("Логов пока нет")
            case .loading:
                Text("Загружаем логи...")
            case .ready:
                if filteredLogs.isEmpty {
                    Text("С такими фильтрами логов нет")
                } else {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 16) {
                            ForEach(Array(zip(filteredLogs.indices, filteredLogs)), id: \.0) { index, log in
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(spacing: 8) {
                                        Text(log.level.emoji)
                                        Text(log.dateString)
                                    }
                                    Text(log.category).bold()
                                    Text(log.message)
                                    Divider()
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .multilineTextAlignment(.leading)
                            }
                        }
                        .padding([.top, .horizontal])
                    }
                }
            }
        }
    }
    
    private var filterView: some View {
        ScrollView {
            VStack(spacing: 32) {
                Section("Категория") {
                    VStack(spacing: 8) {
                        ForEach(loggerGetter.categories, id: \.self) { category in
                            Button {
                                if categoriesToShow.contains(category) {
                                    categoriesToShow = categoriesToShow.filter { $0 != category }
                                } else {
                                    categoriesToShow.append(category)
                                }
                            } label: {
                                makeFilterItemLabel(title: category, isChecked: categoriesToShow.contains(category))
                            }
                        }
                    }
                }
                Section("Уровень") {
                    VStack(spacing: 8) {
                        ForEach(loggerGetter.levels) { level in
                            Button {
                                if levelsToShow.contains(level) {
                                    levelsToShow = levelsToShow.filter { $0 != level }
                                } else {
                                    levelsToShow.append(level)
                                }
                            } label: {
                                makeFilterItemLabel(title: level.emoji, isChecked: levelsToShow.contains(level))
                            }
                        }
                    }
                }
                Button("Сбросить фильтры") {
                    categoriesToShow = []
                    levelsToShow = []
                }
                .disabled(!isFilterOn)
            }
        }
        .padding()
    }
    
    private func makeFilterItemLabel(title: String, isChecked: Bool) -> some View {
        VStack {
            HStack {
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if isChecked {
                    Image(systemName: "checkmark")
                }
            }
            Divider()
        }
    }
}

#Preview { LoggerExample() }
