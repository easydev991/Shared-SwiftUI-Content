//
//  ContentView.swift
//  Shared SwiftUI Content
//
//  Created by Олег Еременко on 04.02.2023.
//

import SwiftUI

struct ContentView: View {
    let colors: [Color] = [
        .black, .blue, .brown, .gray,
        .green, .red, .cyan, .indigo, .yellow
    ]

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

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
