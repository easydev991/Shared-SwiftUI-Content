import SwiftUI
import PFVInterface

struct DemoView: View {
    let number: Int
    var body: some View {
        Text("Вьюха из пакета (\(number))")
            .font(.title.bold())
    }
}

#Preview {
    DemoView(number: 1)
}
