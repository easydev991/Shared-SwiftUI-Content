//
//  TabViewFilledIconExample.swift
//  Shared SwiftUI Content
//
//  Created by Олег Еременко on 19.08.2023.
//

import SwiftUI

struct TabViewFilledIconExample: View {
    var body: some View {
        TabView {
            Color.green.opacity(0.5)
                .tabItem { // 1 - Первый "таб"
                    Image(systemName: "person")
                        .environment(\.symbolVariants, .none) // <- сбросили `symbolVariant`
                }
            Color.blue.opacity(0.5)
                .tabItem { // 2 - Второй "таб"
                    Image(systemName: "house")
                        .environment(\.symbolVariants, .none) // <- сбросили `symbolVariant`
                }
        }

    }
}

struct TabViewFilledIconExample_Previews: PreviewProvider {
    static var previews: some View {
        TabViewFilledIconExample()
    }
}
