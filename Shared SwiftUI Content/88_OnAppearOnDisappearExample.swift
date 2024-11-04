//
//  CommonMistakesExample2.swift
//  Shared SwiftUI Content
//
//  Created by Oleg991 on 11.10.2024.
//

import SwiftUI
import UIKit

struct BackgroundViewController: UIViewControllerRepresentable {
    let viewWillAppear: () -> Void
    let viewWillDisappear: () -> Void

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = CustomViewController()
        viewController.viewWillAppearAction = viewWillAppear
        viewController.viewWillDisappearAction = viewWillDisappear
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    final class CustomViewController: UIViewController {
        var viewWillAppearAction: (() -> Void)?
        var viewWillDisappearAction: (() -> Void)?

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            viewWillAppearAction?()
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            viewWillDisappearAction?()
        }
    }
}

struct UIKitLifeCycleModifier: ViewModifier {
    let viewWillAppear: () -> Void
    let viewWillDisappear: () -> Void
    
    func body(content: Content) -> some View {
        content
            .background(
                BackgroundViewController(
                    viewWillAppear: viewWillAppear,
                    viewWillDisappear: viewWillDisappear
                )
            )
    }
}

struct LifeCycleExampleView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Контент первого экрана")
                    .onAppear { print("1 onAppear") }
                    .onDisappear { print("1 onDisappear") }
                    .modifier(
                        UIKitLifeCycleModifier(
                            viewWillAppear: { print("1 viewWillAppear") },
                            viewWillDisappear: { print("1 viewWillDisappear") }
                        )
                    )
                NavigationLink(destination: secondDemoView) {
                    Text("Открыть второй экран")
                }
            }
        }
        .font(.title)
    }
    
    private var secondDemoView: some View {
        Text("Контент второго экрана")
            .onAppear { print("2 onAppear") }
            .onDisappear { print("2 onDisappear") }
            .modifier(
                UIKitLifeCycleModifier(
                    viewWillAppear: { print("2 viewWillAppear") },
                    viewWillDisappear: { print("2 viewWillDisappear") }
                )
            )
    }
}

#Preview {
    LifeCycleExampleView()
}
