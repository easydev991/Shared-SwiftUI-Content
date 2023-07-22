//
//  SwitchCaseAnimationExample.swift
//  Shared SwiftUI Content
//
//  Created by Олег Еременко on 22.07.2023.
//

import SwiftUI

// 1 - пример перечисления для проверки анимации
enum MyState { case square, circle }

struct SwitchCaseAnimationExample: View {
    // 2 - состояние для ZStack
    @State private var zStackState = MyState.circle
    // 3 - состояние для Group
    @State private var groupState = MyState.circle
    private let animation = Animation.linear(duration: 1)

    var body: some View {
        VStack(spacing: 20) {
            ZStack { view(for: zStackState).overlayWhiteBoldText("ZStack") }
                .animation(animation, value: zStackState)
            Group { view(for: groupState).overlayWhiteBoldText("Group")}
                .animation(animation, value: groupState)
            Button("Сменить состояние", action: changeStates)
        }
    }

    // 5 - Создаем вьюшку для обоих состояний
    @ViewBuilder
    private func view(for state: MyState) -> some View {
        switch state {
        case .square: Rectangle().frame(width: 150, height: 150)
        case .circle: Circle().frame(height: 150)
        }
    }

    // 6 - Меняем оба состояния
    private func changeStates() {
        zStackState = zStackState == .circle ? .square : .circle
        groupState = groupState == .circle ? .square : .circle
    }
}

// 7 - Модификатор для удобства добавления текста
struct WhiteBoldTextOverlayModifier: ViewModifier {
    let text: String
    func body(content: Content) -> some View {
        content.overlay { Text(text).bold().foregroundColor(.white) }
    }
}

extension View {
    func overlayWhiteBoldText(_ text: String) -> some View {
        modifier(WhiteBoldTextOverlayModifier(text: text))
    }
}

struct SwitchCaseAnimationExample_Previews: PreviewProvider {
    static var previews: some View {
        SwitchCaseAnimationExample()
    }
}
