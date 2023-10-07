//
//  FillVSForegroundColorExample.swift
//  Shared SwiftUI Content
//
//  Created by Олег Еременко on 01.07.2023.
//

import SwiftUI

struct FillVSForegroundColorExample: View {
    var body: some View {
        VStack(spacing: 20) {
            Circle() // 1 - круг, залитый градиентом
                .fill(Gradient(colors: [.blue, .black]))
            Circle() // 2 - круг, залитый сплошным цветом
                .fill(.blue)
            Circle() // 3 - тоже круг, залитый сплошным цветом
                .foregroundColor(.blue)
        }
    }
}

#Preview {
    FillVSForegroundColorExample()
}
