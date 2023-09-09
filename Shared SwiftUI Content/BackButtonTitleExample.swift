//
//  BackButtonTitleExample.swift
//  Shared SwiftUI Content
//
//  Created by Олег Еременко on 09.09.2023.
//

import SwiftUI

struct BackButtonTitleExample: View {
    var body: some View {
        // Работать будет только 1 вариант единовременно, для примера сейчас активен вариант 1
        NavigationView {
            option1
//            option2
//            option3
        }
    }

    var option1: some View {
        NavigationLink(
            destination: secondScreen,
            label: {
                Text("Вариант 1").bold()
            }
        )
        .navigationTitle("First") // 1 - Если явно указать заголовок экрана, то у кнопки назад будет такое же название
    }

    var option2: some View {
        NavigationLink(
            destination: secondScreen,
            label: {
                Text("Вариант 2").bold()
            }
        )
        // 2 - Если не использовать модификатор navigationTitle, то у кнопки будет текст "Назад"
    }

    var option3: some View {
        NavigationLink(
            destination: secondScreen,
            label: {
                Text("Вариант 3").bold()
            }
        )
        .navigationTitle("") // 3 - Если в заголовок передать пустую строку, то у кнопки не будет текста
    }

    var secondScreen: some View {
        Text("Второй экран").bold()
    }
}

struct BackButtonTitleExample_Previews: PreviewProvider {
    static var previews: some View {
        BackButtonTitleExample()
    }
}
