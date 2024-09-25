import SwiftUI

/// Модель для чипсины в коллекции
struct ChipItem: Identifiable, Hashable {
    let id: Int
    let description: String
}

extension [ChipItem] {
    static func makeDemoList(count: Int) -> [ChipItem] {
        (0..<count).map { i in
            return .init(
                id: i + 1,
                description: "Тут чипс № \(i + 1)"
            )
        }
    }
}

/// Модель для коллекции чипсов, создает словарь
/// для отображения коллекции в одну или две строки
struct ChipCollectionModel {
    /// Итоговый словарь, где ключ - порядковый номер строки, а значение - чипсы для этой строки
    let itemsDict: [Int: [ChipItem]]
    /// Количество строк в коллекции
    var rows: Int { itemsDict.keys.count }
    
    init(items: [ChipItem]) {
        guard !items.isEmpty else {
            itemsDict = [:]
            return
        }
        if items.count < 5 {
            itemsDict = [1: items]
        } else {
            let count = items.count
            let isEven = count % 2 == 0
            let midIndex = isEven ? count / 2 : (count + 1) / 2
            itemsDict = [
                1: Array(items[..<midIndex]),
                2: Array(items[midIndex...])
            ]
        }
    }
}

struct ChipsCollectionView: View {
    private let model: ChipCollectionModel
    @Binding private var selection: Int?
    
    /// Инициализатор
    /// - Parameters:
    ///   - items: Список чипсов для коллекции
    ///   - selection: Идентификатор выбранного чипса
    init(items: [ChipItem], selection: Binding<Int?>) {
        self.model = .init(items: items)
        self._selection = selection
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 4) {
                ForEach(0..<model.rows, id: \.self) { row in
                    if let items = model.itemsDict[row + 1] {
                        HStack(spacing: 4) {
                            ForEach(items) { item in
                                makeChipView(for: item)
                                    .onTapGesture { selection = item.id }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 4)
        }
    }
    
    private func makeChipView(for item: ChipItem) -> some View {
        Text(item.description)
            .foregroundStyle(.primary)
            .padding(8)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.secondary.opacity(0.3))
            }
    }
}

#if DEBUG
#Preview("15 чипсов") {
    ChipsCollectionView(items: .makeDemoList(count: 15), selection: .constant(nil))
}

#Preview("5 чипсов") {
    ChipsCollectionView(items: .makeDemoList(count: 5), selection: .constant(nil))
}

#Preview("4 чипса") {
    ChipsCollectionView(items: .makeDemoList(count: 4), selection: .constant(nil))
}
#endif
