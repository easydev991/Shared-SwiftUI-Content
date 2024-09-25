import SwiftUI

struct LinkExample: View {
    private let linkUrl = URL(string: "https://boosty.to/oleg991")!
    private let linkTitle = "Открыть ссылку"
    
    var body: some View {
        VStack(spacing: 20) {
            Link(linkTitle, destination: linkUrl)
            Link(destination: linkUrl) {
                Text(linkTitle)
            }
            Button {
                UIApplication.shared.open(linkUrl)
            } label: {
                Text(linkTitle)
            }
            Text(linkTitle)
                .foregroundStyle(.blue)
                .onTapGesture {
                    UIApplication.shared.open(linkUrl)
                }
            Text(.init("[\(linkTitle)](\(linkUrl))"))
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.capsule)
    }
}

#Preview {
    LinkExample()
}
