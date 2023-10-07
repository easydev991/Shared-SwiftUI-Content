//
//  RoundedCornerShape.swift
//  Shared SwiftUI Content
//
//  Created by Олег Еременко on 07.05.2023.
//

import SwiftUI

/// Форма с возможностью настройки радиуса для разных углов
struct RoundedCornerShape: Shape { // 1
    let radius: CGFloat
    let corners: UIRectCorner

    func path(in rect: CGRect) -> Path { // 2
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    VStack(spacing: 20) {
        Rectangle()
            .foregroundColor(.blue)
            .clipShape( // 1
                RoundedCornerShape( // 2
                    radius: 50,
                    corners: [.bottomLeft, .topLeft]
                                  )
            )
        Rectangle()
            .foregroundColor(.black)
            .clipShape( // 1
                RoundedCornerShape( // 2
                    radius: 50,
                    corners: [.topRight, .bottomRight]
                                  )
            )
        Rectangle()
            .foregroundColor(.brown)
            .clipShape( // 1
                RoundedCornerShape( // 2
                    radius: 50,
                    corners: [.bottomLeft, .bottomRight, .topLeft]
                                  )
            )
    }
    .padding()
}
