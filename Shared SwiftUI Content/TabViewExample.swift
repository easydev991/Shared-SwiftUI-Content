import SwiftUI

struct HeightPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 100
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct TabViewExample: View {
    @State private var contentHeight: CGFloat = 350
    @State private var selectedIndex = 0
    @State private var itemsHeight = [Int: CGFloat]()
    let items = [
        "fsadfasdasdfasdfasdasdfasdfaasdfasdfasdfasdfasdfasdfsdfasdffasdfasdff",
        "dhfajklhdsfjklhasdlkjfasdfasdfasdfasdfasdfhasdf",
        "yuitasasdfasdfasdfugbfyuweasdfsdfasdfasd132123123123123123123123123123ffqydisaf"
    ]

    var body: some View {
        VStack(spacing: 8) {
            ScrollViewReader { scroll in
//                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(Array(zip(items.indices, items)), id: \.0) { index, item in
                            makeItem(index, item)
                                .frame(maxWidth: 300)
                                .onTapGesture {
                                    withAnimation {
                                        selectedIndex = index
                                        scroll.scrollTo(index)
                                    }
                                }
                        }
                    }
//                }
            }
            .frame(height: contentHeight)
            .background(.blue)
            HStack(spacing: 12) {
                ForEach(0..<items.count, id: \.self) { index in
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundColor(index == selectedIndex ? .black : .gray)
                }
            }
        }
//        .onPreferenceChange(HeightPreferenceKey.self) {
//            contentHeight = $0
//        }
    }

    func makeItem(_ index: Int, _ item: String) -> some View {
        Text(item)
            .padding()
            .background(Color.yellow.cornerRadius(12))
            .frame(maxWidth: 350)
            .overlay {
                GeometryReader { geo in
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(.green)
                        .onAppear {
                            if itemsHeight[index] == nil {
                                itemsHeight[index] = geo.size.height.rounded()
                            }
                        }
                        .frame(width: 80, height: 30)
                        .overlay {
                            Text("\(itemsHeight[index] ?? geo.size.height)")
                                .onTapGesture {
                                    withAnimation {
                                        if let height = itemsHeight[index] {
                                            contentHeight = height
                                        } else {
                                            itemsHeight[index] = geo.size.height
                                            contentHeight = geo.size.height
                                        }
                                    }
                                }
                        }
                        .preference(
                            key: HeightPreferenceKey.self,
                            value: geo.size.height
                        )
                }
            }
    }
}

struct TabViewExample_Previews: PreviewProvider {
    static var previews: some View {
        TabViewExample()
    }
}
