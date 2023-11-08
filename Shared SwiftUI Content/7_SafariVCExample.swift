import SafariServices
import SwiftUI

struct SafariVCRepresentable: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context _: Context) -> SFSafariViewController {
        .init(url: url)
    }

    func updateUIViewController(_: SFSafariViewController, context _: Context) {}
}

#Preview {
    SafariVCRepresentable(url: .init(string: "https://gist.github.com/OlegEremenko991")!)
}
