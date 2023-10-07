//
//  DisableUserInteractionExample.swift
//  Shared SwiftUI Content
//
//  Created by Олег Еременко on 03.06.2023.
//

import SwiftUI

struct DisableUserInteractionExample: View {
    @State private var isButtonDisabled = false // 1 - свойство для модификатора `disabled`
    @State private var buttonAllowsHitTesting = true // 2 - свойство для модификатора `allowsHitTesting`

    var body: some View {
        VStack(spacing: 20) {
            Toggle(isOn: $isButtonDisabled) { // 3 - тоггл для управления модификатором `disabled`
                Text("disabled")
            }
            Toggle(isOn: $buttonAllowsHitTesting) { // 4 - тоггл для управления модификатором `allowsHitTesting`
                Text("allowsHitTesting")
            }
            Button("Tap me!") { // 5 - кнопка, которая выводит в консоль текст при успешном нажатии
                print("Tapped a button")
            }
            .buttonStyle(.borderedProminent)
            .disabled(isButtonDisabled) // 6 - отключает возможность нажимать на UI-элемент и меняет внешний вид для стандартных элементов (если передано значение `true`)
            .allowsHitTesting(buttonAllowsHitTesting) // 7 - отключает возможность нажимать на UI-элемент (если передано значение `true`)
        }
        .padding()
    }
}

#Preview {
    DisableUserInteractionExample()
}
