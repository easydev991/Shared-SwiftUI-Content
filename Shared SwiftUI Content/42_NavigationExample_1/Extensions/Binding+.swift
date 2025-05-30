//
//  Binding+.swift
//  Shared SwiftUI Content
//
//  Created by Oleg991 on 25.11.2023.
//

import SwiftUI

extension Binding<Bool> {
    init<Wrapped: Sendable>(bindingOptional: Binding<Wrapped?>) {
        self.init(
            get: { bindingOptional.wrappedValue != nil },
            set: { newValue in
                guard newValue == false else { return }
                /// Обрабатываем только значение `false`, чтобы обнулить опционал,
                /// потому что не можем восстановить предыдущее состояние опционала для значения `true`
                bindingOptional.wrappedValue = nil
            }
        )
    }
}

extension Binding {
    func mappedToBool<Wrapped: Sendable>() -> Binding<Bool> where Value == Wrapped? {
        Binding<Bool>(bindingOptional: self)
    }
}
