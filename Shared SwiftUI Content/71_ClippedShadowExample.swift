import SwiftUI

struct ClippedShadowExample: View {
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 16) {
                ForEach(1..<10, id: \.self) { item in
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.white)
                        .frame(width: 140, height: 140) // габариты ячейки по макету
                        .overlay { Text("Text # \(item)") }
                        .drawingGroup() // <- убирает тень у текста
                        .shadow(color: .blue, radius: 8)
                }
            }
            .padding(.horizontal) // отступы по макету
            .padding(.vertical, 20) // <- балансируем для теней
        }
        .padding(.vertical, -20) // <- балансируем для теней
        .frame(height: 140) // высота коллекции по макету
    }
}

#Preview {
    ClippedShadowExample()
}
