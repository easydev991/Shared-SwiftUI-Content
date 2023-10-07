//
//  CustomSecureField.swift
//  Shared SwiftUI Content
//
//  Created by Олег Еременко on 04.02.2023.
//

import SwiftUI

struct CustomSecureField: View {
    @Binding private var text: String
    @State private var isSecured = true
    private var title: String

    init(_ title: String, text: Binding<String>) {
        self.title = title
        _text = text
    }

    var body: some View {
        ZStack(alignment: .trailing) {
            Group {
                if isSecured {
                    SecureField(title, text: $text)
                } else {
                    TextField(title, text: $text)
                }
            }
            .padding(.trailing, 32)

            Button {
                isSecured.toggle()
            } label: {
                Image(systemName: isSecured ? "eye.slash" : "eye")
                    .accentColor(.gray)
            }
        }
    }
}

#Preview {
    CustomSecureField("Password", text: .constant("password123"))
        .padding()
}
