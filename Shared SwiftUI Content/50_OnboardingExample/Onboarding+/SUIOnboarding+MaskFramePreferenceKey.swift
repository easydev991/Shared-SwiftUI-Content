import SwiftUI

extension SUIOnboarding {
    /// Хранит словарь с фреймами для выделяемых вьюшек онбординга
    struct MaskFramePreferenceKey: PreferenceKey {
        typealias Value = [ItemModel: CGRect]
        
        static var defaultValue: Value = [:]
        
        static func reduce(value: inout Value, nextValue: () -> Value) {
            value.merge(nextValue(), uniquingKeysWith: { $1 })
        }
    }
}
