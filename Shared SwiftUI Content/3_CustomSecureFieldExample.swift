import SwiftUI

struct CustomSecureFieldExample: View {
    @Binding private var text: String
    @State private var isSecured = true
    private var title: String

    init(_ title: String, text: Binding<String>) {
        self.title = title
        _text = text
    }

    var body: some View {
        ZStack(alignment: .trailing) {
            Group {
                if isSecured {
                    SecureField(title, text: $text)
                } else {
                    TextField(title, text: $text)
                }
            }
            .padding(.trailing, 32)

            Button {
                isSecured.toggle()
            } label: {
                Image(systemName: isSecured ? "eye.slash" : "eye")
                    .accentColor(.gray)
            }
        }
        .animation(.easeInOut(duration: 0.1), value: isSecured)
    }
}

#Preview {
    CustomSecureFieldExample("Password", text: .constant("password123"))
        .padding()
}
