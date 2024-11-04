import SwiftUI

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
            .foregroundColor(.primary)
            .padding(8)
            .background(chipBackgroundColor)
    }
    
    private var chipBackgroundColor: some View {
        Color.secondary.opacity(0.3)
            .clipShape(.rect(cornerRadius: 20))
    }
}

#Preview("15 чипсов") {
    ChipsCollectionView(items: .makeDemoList(count: 15), selection: .constant(nil))
}

#Preview("5 чипсов") {
    ChipsCollectionView(items: .makeDemoList(count: 5), selection: .constant(nil))
}

#Preview("4 чипса") {
    ChipsCollectionView(items: .makeDemoList(count: 4), selection: .constant(nil))
}
