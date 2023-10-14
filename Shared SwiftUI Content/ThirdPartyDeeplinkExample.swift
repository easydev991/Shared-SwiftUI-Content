//
//  ThirdPartyDeeplinkExample.swift
//  Shared SwiftUI Content
//
//  Created by Олег Еременко on 14.10.2023.
//

import SwiftUI

struct ThirdPartyDeeplinkExample: View {
    struct Model: Identifiable {
        let id = UUID()
        let title: String
        let url: URL

        /// Проверка на возможность открытия ссылки
        var canOpenURL: Bool {
            UIApplication.shared.canOpenURL(url)
        }
    }

    private let items: [Model] = [
        .init(title: "Telegram", url: .init(string: "https://t.me/easy_dev991")!),
        .init(title: "OtherApp", url: .init(string: "otherApp://linkToSupport")!)
    ]

    var body: some View {
        VStack(spacing: 20) {
            ForEach(items) { item in
                Button(item.title) {
                    UIApplication.shared.open(item.url)
                }
                .font(.title.bold())
                .disabled(!item.canOpenURL) // <- делаем кнопку недоступной, если ссылку нельзя открыть
            }
        }
    }
}

#Preview {
    ThirdPartyDeeplinkExample()
}
