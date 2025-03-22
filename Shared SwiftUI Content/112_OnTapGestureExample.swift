import SwiftUI

/// Основная вьюха, которую можно нажать целиком
struct OnTapGestureExample: View {
    let imageUrl: URL?
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            DemoImageView(url: imageUrl, action: nil)
            VStack(alignment: .leading, spacing: 12) {
                Text(title).bold()
                Text(subtitle)
                    .lineLimit(3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.gray.opacity(0.2))
                .shadow(color: .green, radius: 10, x: 10, y: 10)
        )
        .padding(.horizontal)
        .contentShape(.rect)
        .onTapGesture(perform: action)
    }
}

extension OnTapGestureExample {
    /// Сабвьюха, которая может нажиматься, а может и нет,
    /// в зависимости от замыкания `action`
    struct DemoImageView: View {
        let url: URL?
        let action: (() -> Void)?
        
        var body: some View {
            imageView
                .allowsHitTesting(action != nil)
                .onTapGesture {
                    print("Нажали на картинку")
                    action?()
                }
        }
        
        private var imageView: some View {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 110, height: 100)
            .clipShape(.rect(cornerRadius: 12))
        }
    }
}

#Preview {
    OnTapGestureExample(
        imageUrl: URL(string: "https://quantis.com/wp-content/uploads/2025/01/rice-field.jpg"),
        title: "Ut enim ad minima veniam",
        subtitle: "Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur",
        action: {
            print("Нажали на вьюху")
        }
    )
}
