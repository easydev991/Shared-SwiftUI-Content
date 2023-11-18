import SwiftUI

@main
struct Shared_SwiftUI_ContentApp: App {
    @State private var toastModel: ToastViewModifier.Model?
    
    var body: some Scene {
        WindowGroup {
            ToastViewExample() // <- внутри настраивается тост через обращение к @Environment(\.toastInfo)
                .environment(\.toastInfo) { model in
                    toastModel = model
                }
                .toast(item: $toastModel)
        }
    }
}
