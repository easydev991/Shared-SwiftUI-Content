import SwiftUI

@main
struct Shared_SwiftUI_ContentApp: App {
    var body: some Scene {
        WindowGroup {
            VStack(spacing: 20) {
                MaskedFieldExample(mask: "(XXX) XXX-XX-XX")
                MaskedFieldExample(mask: "+X (XXX) XXX-XX-XX")
                MaskedFieldExample(mask: "+X XXX XXX-XX-XX")
            }
            .padding(.horizontal)
        }
    }
}
