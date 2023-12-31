import SwiftUI

// 1 - Модель поста
struct PostModel: Codable, Identifiable {
    let id: Int
    let title, body: String
}

struct ViewWithTaskExample: View {
    @State private var posts = [PostModel]() // 2 - Свойство для хранения загруженных данных
    @State private var isLoading = false // 3 - Свойство для хранения состояния загрузки

    var body: some View {
        List(posts) { post in
            // 4 - Выводим данные поста на экран в списке
            VStack(alignment: .leading, spacing: 12) {
                Text(post.title).font(.title)
                Text(post.body)
            }
        }
        .overlay {
            // 5 - Индикатор загрузки, который видно, если isLoading == true
            ProgressView {
                Text("Загрузка...")
            }
            .opacity(isLoading ? 1 : 0)
        }
        .animation(.easeInOut, value: isLoading)
        .task {
            // 6 - Задача, которая вызывается при появлении View
            await downloadPosts()
        }
    }

    private func downloadPosts() async {
        // 7 - Будем загружать список постов из jsonplaceholder
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        // 8 - Перед запросом включаем состояние загрузки
        isLoading = true
        // 9 - Выключаем состояние загрузки при выходе из метода
        defer { isLoading = false }
        // 10 - Загружаем данные по url из шага 7 и декодируем в модель из шага 1
        guard let (data, _) = try? await URLSession.shared.data(for: .init(url: url)),
              let decodedModel = try? JSONDecoder().decode([PostModel].self, from: data) else { return }
        // 11 - Ждем 1 секунду для имитации долгой загрузки, иначе ProgressView может не появиться
        if #available(iOS 16.0, *) {
            try? await Task.sleep(for: .seconds(1))
        } else {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
        }
        // 12 - Сохраняем загруженные для отображения на экране
        posts = decodedModel
    }
}

#Preview { ViewWithTaskExample() }
