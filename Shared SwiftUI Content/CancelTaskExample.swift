//
//  CancelTaskExample.swift
//  Shared SwiftUI Content
//
//  Created by Олег Еременко on 29.07.2023.
//

import SwiftUI

extension PostModel {
    // 1 - Имитируем список постов (используем модель из статьи про .task)
    static let list: [Self] = (1..<5).map {
        .init(id: $0, title: "", body: "")
    }
}

struct CancelTaskExample: View {
    // 2 - Сохраняем задачу для загрузки поста
    @State private var getPostTask: Task<Void, Never>?
    // 3 - Тут сохраним данные загруженного поста
    @State private var postInfo: PostModel?
    // 4 - Управляем открытием модального окна с постом
    @State private var showPostInfo = false

    var body: some View {
        VStack(spacing: 30) {
            // 5 - Кнопки для загрузки постов
            ForEach(PostModel.list) { post in
                Button("Показать пост №\(post.id)") {
                    showPostInfo.toggle()
                    getPostTask = Task {
                        await downloadPost(with: post.id)
                    }
                }
            }
        }
        // 6 - Модальное окно для отображения поста
        .sheet(
            isPresented: $showPostInfo,
            onDismiss: {
                // 7 - При закрытии окна отменяем таск и очищаем загруженные данные
                getPostTask?.cancel()
                postInfo = nil
            },
            content: {
                // 8 - Вьюшка для отображения поста
                VStack(spacing: 20) {
                    if let postInfo {
                        Group {
                            Text(postInfo.title).bold()
                            Text(postInfo.body)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                    } else {
                        ProgressView()
                    }
                }
                .padding()
            }
        )
    }

    private func downloadPost(with id: Int) async {
        // 9 - Будем загружать пост из jsonplaceholder
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts/\(id)") else { return }
        // 10 - Загружаем данные по url из шага 7 и декодируем в модель из шага 1
        guard let (data, _) = try? await URLSession.shared.data(for: .init(url: url)),
              let decodedModel = try? JSONDecoder().decode(PostModel.self, from: data) else { return }
        // 11 - Ждем 1 секунду для имитации долгой загрузки, иначе ProgressView может не появиться
        try? await Task.sleep(for: .seconds(1))
        // 12 - Сохраняем пост для отображения на экране
        postInfo = decodedModel
    }
}

struct CancelTaskExample_Previews: PreviewProvider {
    static var previews: some View {
        CancelTaskExample()
    }
}
