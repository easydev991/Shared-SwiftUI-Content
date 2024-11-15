import SwiftUI

fileprivate struct Model: Identifiable {
    let id = UUID()
    let string: String
}

struct EqualHeightWidthStackExample: View {
    private let items = [
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt",
        "Duis aute irure dolor in reprehenderit in voluptate",
        "Ut enim ad minim veniam",
    ].map(Model.init)
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(items) { item in
                makeView(title: item.string)
            }
        }
        .fixedSize(horizontal: false, vertical: true) // 1
        .padding(.horizontal)
    }
    
    private func makeView(title: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: "house")
                .symbolVariant(.fill)
                .font(.title)
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading) // 2
        }
        .foregroundStyle(.primary)
        .padding(16)
        .frame(maxHeight: .infinity, alignment: .top) // 3
        .background(.green.opacity(0.5))
        .clipShape(.rect(cornerRadius: 16))
    }
}

#Preview {
    EqualHeightWidthStackExample()
}
