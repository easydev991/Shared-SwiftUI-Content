//
//  ToggleListExample.swift
//  Shared SwiftUI Content
//
//  Created by Олег Еременко on 16.04.2023.
//

import SwiftUI

struct TogglesListExample: View {
    @State private var receiveNotifications = true

    var body: some View {
        List {
            Section("Уведомления") {
                Toggle("Получать уведомления", isOn: $receiveNotifications)
                if receiveNotifications {
                    Toggle("Новости", isOn: .constant(false))
                    Toggle("Обновления друзей", isOn: .constant(false))
                }
            }
            .listRowSeparator(.hidden)
        }
        .animation(.default, value: receiveNotifications)
    }
}

#Preview {
    TogglesListExample()
}
