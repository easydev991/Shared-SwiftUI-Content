import SwiftUI

struct PluralsLocalizationExample: View {
    // 1 - Список чисел для демо
    private let ages: [Int] = (0..<25).map { $0 }

    var body: some View {
        List(ages, id: \.self) { age in
            Text( // 2 - Текст с локализованной строкой внутри
                String.localizedStringWithFormat(
                    NSLocalizedString("ageInYears", comment: ""),
                    age
                )
            )
        }
    }
}

#Preview { PluralsLocalizationExample() }
