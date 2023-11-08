import SwiftUI

struct TextWithLinkExample: View {
    private let textWithLink = "Ссылка на [telegram](https://t.me/easy_dev991)"
    
    var body: some View {
        Text(.init(textWithLink))
    }
}

#Preview { TextWithLinkExample() }
