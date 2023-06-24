//
//  UIKitTextViewExample.swift
//  Shared SwiftUI Content
//
//  Created by Олег Еременко on 24.06.2023.
//

import SwiftUI

struct UIKitTextView: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.delegate = context.coordinator
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        .init(self)
    }

    final class Coordinator: NSObject, UITextViewDelegate {
        private let parent: UIKitTextView

        init(_ parent: UIKitTextView) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }
}
