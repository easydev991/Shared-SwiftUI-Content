//
//  AttributedStringExample.swift
//  Shared SwiftUI Content
//
//  Created by Еременко Олег Николаевич on 26.07.2025.
//

import SwiftUI

struct AttributedStringExample: View {
    let items: [UserInfo]
    private let boldFont = Font.system(size: 20, weight: .bold)
    private let regularFont = Font.system(size: 16, weight: .regular)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(items) { item in
                makeAttributedStringView(for: item)
                makeTextAdditionView(for: item)
            }
        }
        .padding()
    }
    
    private func makeAttributedStringView(for item: UserInfo) -> some View {
        Text(makeAttributedText(for: item))
    }
    
    private func makeTextAdditionView(for item: UserInfo) -> some View {
        Text(item.label + ": ").font(boldFont)
        +
        Text(item.value).font(regularFont)
    }
    
    private func makeAttributedText(for item: UserInfo) -> AttributedString {
        var namePart = AttributedString(item.label + ":")
        namePart.font = boldFont
        var valuePart = AttributedString(" " + item.value)
        valuePart.font = regularFont
        return namePart + valuePart
    }
}

extension AttributedStringExample {
    struct UserInfo: Identifiable {
        let id = UUID()
        let label: String
        let value: String
    }
}

#Preview {
    let items: [AttributedStringExample.UserInfo] = [
        .init(label: "Почта", value: "test@example.com"),
        .init(label: "Телефон", value: "+79123456789"),
        .init(
            label: "Адрес",
            value: "117513, г. Москва, ул. Профсоюзная, д. 129, корп. 3, кв. 117, подъезд 5, этаж 8"
        )
    ]
    AttributedStringExample(items: items)
}
