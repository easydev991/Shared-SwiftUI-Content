import SwiftUI

struct RefreshableExample: View {
    var body: some View {
        ViewWithTaskExample()
            .refreshable {
                print("обновляем!")
            }
    }
}

#Preview {
    RefreshableExample()
}
