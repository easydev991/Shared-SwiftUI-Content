//
//  UIKitViewDidAppear.swift
//  Shared SwiftUI Content
//
//  Created by Олег Еременко on 04.02.2023.
//

import SwiftUI
import UIKit

// MARK: UIKitViewDidAppear

struct UIKitViewDidAppear: UIViewControllerRepresentable {
    let action: () -> Void

    func makeUIViewController(context _: Context) -> DummyViewController {
        .init(action: action)
    }

    func updateUIViewController(_: DummyViewController, context _: Context) {}
}

extension UIKitViewDidAppear {
    final class DummyViewController: UIViewController {
        private let action: () -> Void

        init(action: @escaping () -> Void) {
            self.action = action
            super.init(nibName: nil, bundle: nil)
        }

        @available(*, unavailable)
        required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func viewDidAppear(_: Bool) {
            action()
        }
    }
}

// MARK: Usage

extension View {
    func uiKitViewDidAppear(_ perform: @escaping () -> Void) -> some View {
        background(UIKitViewDidAppear(action: perform))
    }
}


public struct MainButtonStyle: PrimitiveButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        Button(configuration)
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
    }
}

extension PrimitiveButtonStyle where Self == MainButtonStyle {
    public static var main: Self { .init() }
}

struct ButtonStyles_Previews: PreviewProvider {
    static var previews: some View {
        Button("Action") {}
            .buttonStyle(.main)
    }
}
