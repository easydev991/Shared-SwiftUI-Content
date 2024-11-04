import Foundation

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
