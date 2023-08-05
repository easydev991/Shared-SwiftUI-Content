//
//  TextEditorPlaceholderExample.swift
//  Shared SwiftUI Content
//
//  Created by Олег Еременко on 05.08.2023.
//

import SwiftUI

struct TextEditorPlaceholderExample: View {
    // 1 - свойство для хранения текста
    @State private var text = ""
    // 2 - плейсхолдер, который видно при отсутствии основного текста
    private let placeholder = "Тут плейсхолдер, который занимает целых две строки текста и пропускает нажатия по себе"

    var body: some View {
        // 3 - вьюшка для ввода текста
        TextEditor(text: $text)
            .frame(height: 150)
            .padding(.horizontal, 8)
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(Color.black, lineWidth: 1)
            )
            .overlay(alignment: .topLeading) {
                // 4 - вьюшка для отображения плейсхолдера
                Text(placeholder)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .opacity(text.isEmpty ? 1 : 0)
                    .padding(12)
                    .allowsHitTesting(false) // 5 - пропускаем нажатия сквозь вьюшку с плейсхолдером
            }
            .padding()
    }
}

struct TextEditorPlaceholderExample_Previews: PreviewProvider {
    static var previews: some View {
        TextEditorPlaceholderExample()
    }
}
