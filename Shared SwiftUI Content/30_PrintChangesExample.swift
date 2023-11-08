import SwiftUI

// https://developer.apple.com/documentation/swift-playgrounds/console-print-debugging#Understand-when-and-why-your-views-change

struct PrintChangesExample: View {
    @State private var text = ""
    @State private var isOn = false

    var body: some View {
        let _ = Self._printChanges() // выводится в консоли
        VStack {
            TextField("Some text", text: $text)
            Toggle("Some toggle", isOn: $isOn)
        }
        .padding()
    }
}

#Preview { PrintChangesExample() }
