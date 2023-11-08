import SwiftUI

struct MultipleSheetsView: View {
    /// 1 - Свойство для отслеживания текущего модального окна
    @State private var activeSheet: ActiveSheet?

    var body: some View {
        VStack(spacing: 20) {
            ForEach(ActiveSheet.allCases) { item in
                Button("Показать \(item.title)") {
                    // 2 - Задаем текущее модальное окно
                    activeSheet = item
                }
            }
        }
        // 3 - Показываем текущее модальное окно, и в зависимости от его вида - разный UI
        .sheet(item: $activeSheet) { item in
            switch item {
            case .first:
                Color.green
                    .opacity(0.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .overlay {
                        VStack(spacing: 16) {
                            Text(item.title)
                            Button("Понятно") {
                                // 4 - Обнуляем (и закрываем) текущее модальное окно
                                activeSheet = nil
                            }
                        }
                    }
            case .second:
                Button("Закрыть \(item.title)") {
                    // 4 - Обнуляем (и закрываем) текущее модальное окно
                    activeSheet = nil
                }
            case .third:
                VStack(spacing: 8) {
                    Image(systemName: "3.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100)
                    Button("Закрыть") {
                        // 4 - Обнуляем (и закрываем) текущее модальное окно
                        activeSheet = nil
                    }
                }
            }
        }
    }
}

extension MultipleSheetsView {
    /// 5 - Перечисление с нужными вариантами модальных окон
    enum ActiveSheet: String, Identifiable, CaseIterable {
        case first = "первое"
        case second = "второе"
        case third = "третье"

        var id: String { rawValue }

        var title: String {
            rawValue + " модальное окно"
        }
    }
}

#Preview { MultipleSheetsView() }
