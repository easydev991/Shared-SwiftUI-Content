//
//  TestTextsView.swift
//  Shared SwiftUI Content
//
//  Created by Олег Еременко on 03.05.2023.
//

import SwiftUI

struct TestTextsView: View {
    var body: some View {
        Color.blue
            .ignoresSafeArea()
            .overlay(
                VStack(spacing: 20) {
                    Text("Hello world")
                        .background(Color.red)
                    Text("Hello world")
                        .background(Color.red)
                    VStack(spacing: 20) {
                        Text("CustomView")
                        Text("CustomView2")
                        Text("CustomView3")
                    }
                    .background(Color.red)
                    Text("Hello world")
                        .background(Color.red)
                }
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
            )
    }
}

#Preview {
    TestTextsView()
}

class CustomView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    let labelA = UILabel()
    labelA.text = "CustomView"

    let labelB = UILabel()
    labelB.text = "CustomView2"

    let labelC = UILabel()
    labelC.text = "CustomView3"

    let stackView = UIStackView(arrangedSubviews: [
      labelA,
      labelB,
      labelC
    ])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.spacing = 20
    stackView.backgroundColor = .red
    addSubview(stackView)

    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      stackView.topAnchor.constraint(equalTo: topAnchor),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

struct CustomViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        CustomView()
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
