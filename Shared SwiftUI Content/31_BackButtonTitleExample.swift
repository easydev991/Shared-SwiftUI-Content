import SwiftUI

struct BackButtonTitleExample: View {
    var body: some View {
        // Работать будет только 1 вариант единовременно, для примера сейчас активен вариант 1
        NavigationView {
//            option1
//            option2
//            option3
//            option4
            option5
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
    
    var option4: some View {
        NavigationLink(
            destination: secondScreen,
            label: {
                Text("Вариант 4").bold()
            }
        )
        .navigationTitle("Длинный заголовок не умещается в кнопку назад") // 4 - Если в заголовок передать слишком длинную строку, то у кнопки будет стандартный текст "Назад"
    }
    
    var option5: some View {
        NavigationLink(
            destination: thirdScreen,
            label: {
                Text("Вариант 5").bold()
            }
        )
        .navigationTitle("Обычный заголовок")
    }

    var secondScreen: some View {
        Text("Второй экран").bold()
    }
    
    var thirdScreen: some View {
        Text("Следующий экран").bold()
        // 5 - Если в заголовок следующего экрана передать слишком длинную строку, то у кнопки не будет текста
            .navigationTitle("Слишком длинный заголовок")
            .navigationBarTitleDisplayMode(.inline) // чтобы заголовок уместился на экране
    }
}

#Preview { BackButtonTitleExample() }
