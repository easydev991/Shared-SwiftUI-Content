//
//  NavigationLink+.swift
//  Shared SwiftUI Content
//
//  Created by Oleg991 on 25.11.2023.
//

import SwiftUI

extension NavigationLink where Label == EmptyView {
    /// Инициализатор с пустым лейблом для удобства
    init(destination: Destination, isActive: Binding<Bool>) {
        self.init(
            destination: destination,
            isActive: isActive,
            label: EmptyView.init
        )
    }
}
