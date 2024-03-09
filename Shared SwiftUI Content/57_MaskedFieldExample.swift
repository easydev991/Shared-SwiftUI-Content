import SwiftUI
import Combine

struct MaskedFieldExample: View {
    @State private var phoneNumber: String = ""
    let mask: String
    
    var body: some View {
        TextField("+7", text: $phoneNumber)
            .keyboardType(.phonePad)
            .textFieldStyle(.roundedBorder)
            .onReceive(Just(phoneNumber)) { newValue in
                if !newValue.isEmpty {
                    phoneNumber = newValue.makeMaskedNumber(mask)
                }
            }
    }
}

extension String {
    /// Применяет маску к телефону, чтобы сформировать номер, начинающийся на "+7"
    ///
    /// В тестах форматирует некорректно, если передать строку, начинающуюся не с "7"
    /// - Parameter mask: Маска для форматирования строки
    /// - Returns: Отформатированный номер телефона с маской
    func makeMaskedNumber(_ mask: String) -> String {
        let cleanNumber = components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        var result = ""
        var startIndex = cleanNumber.startIndex
        for char in mask where startIndex < cleanNumber.endIndex {
            if char == "X" {
                result.append(cleanNumber[startIndex])
                startIndex = cleanNumber.index(after: startIndex)
            } else {
                result.append(char)
            }
        }
        if let plusIndex = result.firstIndex(of: "+") {
            let nextIndex = result.index(after: plusIndex)
            let nextNumber = result[nextIndex]
            if nextNumber != "7" {
                var array = Array(result)
                array[1] = "7"
                array.insert(nextNumber, at: 2)
                result = array.map { String($0) }.joined()
            }
        }
        return result
    }
}

#Preview {
    VStack(spacing: 20) {
        MaskedFieldExample(mask: "(XXX) XXX-XX-XX")
        MaskedFieldExample(mask: "+X (XXX) XXX-XX-XX")
        MaskedFieldExample(mask: "+X XXX XXX-XX-XX")
    }
    .padding(.horizontal)
}
