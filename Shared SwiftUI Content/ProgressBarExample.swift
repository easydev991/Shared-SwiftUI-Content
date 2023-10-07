//
//  ProgressBarExample.swift
//  Shared SwiftUI Content
//
//  Created by Олег Еременко on 08.07.2023.
//

import SwiftUI

struct ProgressBarExample: View {
    /// 1 - таймер, срабатывающий каждые 0.1 секунды
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    /// 2 - максимальное значение прогресса
    private let totalValue: Double = 20
    /// 3 - текущее значение прогресса
    @State private var currentValue: Double = 0

    var body: some View {
        VStack(spacing: 20) {
            ProgressView( // 4 - основная вьюшка, отображающая прогресс
                currentValue < totalValue ? "Ожидайте" : "Готово",
                value: currentValue,
                total: totalValue
            )
            .tint(.black) // 5 - так можно поменять цвет, по умолчанию он синий
            .onReceive(timer) { _ in // 6 - подписываемся на таймер
                if currentValue < totalValue {
                    currentValue += 1 // 7 - обновляем текущее значение прогресса
                }
            }
            Button("Начать сначала") { // 8 - кнопка для сброса текущего прогресса
                currentValue = 0
            }
            .opacity(currentValue < totalValue ? 0 : 1)
        }
        .padding(.horizontal)
    }
}

#Preview {
    ProgressBarExample()
}
