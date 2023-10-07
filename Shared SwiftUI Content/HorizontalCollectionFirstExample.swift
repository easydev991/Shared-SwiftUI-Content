//
//  HorizontalCollectionFirstExample.swift
//  Shared SwiftUI Content
//
//  Created by Олег Еременко on 15.07.2023.
//

import SwiftUI

// 1 - Вьюшка с коллекцией
struct HorizontalCollectionFirstExample: View {
    // 2 - Тексты для коллекции
    private let titles: [String] = [
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
        "Cras mollis leo in elit dapibus, vel feugiat arcu vulputate."
    ]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    ForEach(titles, id: \.self) {
                        CellView(title: $0) // 3 - ячейка коллекции
                            .frame(width: 280)
                    }
                }
                HStack(spacing: 16) {
                    ForEach(titles, id: \.self) {
                        CellView(title: $0) // 3 - ячейка коллекции
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: 280)
                    }
                }
            }
            .frame(maxHeight: .infinity) // 4 - высота контейнера для коллекций
            .padding(.horizontal, 20)
        }
        .background(Color.blue.opacity(0.3)) // 5 - цвет фона скролла
    }
}

extension HorizontalCollectionFirstExample {
    struct CellView: View {
        let title: String
        var body: some View {
            Text(title)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                )
        }
    }
}

#Preview {
    HorizontalCollectionFirstExample()
}
