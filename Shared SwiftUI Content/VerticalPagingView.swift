//
//  VerticalPagingView.swift
//  Shared SwiftUI Content
//
//  Created by Олег Еременко on 04.05.2023.
//

import SwiftUI

struct EasyPagingView: View {
    var body: some View {
        _PagingView( // 1
            direction: .vertical, // 2
            views: [ // 3
                Rectangle().foregroundColor(.yellow),
                Rectangle().foregroundColor(.red),
                Rectangle().foregroundColor(.blue),
                Rectangle().foregroundColor(.green)
            ]
        )
        .ignoresSafeArea() // 4
    }
}

struct EasyPagingView_Previews: PreviewProvider {
    static var previews: some View {
        EasyPagingView()
    }
}


//private extension VerticalPagingView {
//    enum Direction: String, CaseIterable {
//        case back = "Назад"
//        case forward = "Вперед"
//    }
//
//    func canGo(_ direction: Direction) -> Bool {
//        switch direction {
//        case .back:
//            return pageIndex > 0
//        case .forward:
//            return pageIndex < 3
//        }
//    }
//
//    func go(_ direction: Direction) {
//        switch direction {
//        case .back:
//            if canGo(direction) {
//                pageIndex -= 1
//            }
//        case .forward:
//            if canGo(direction) {
//                pageIndex += 1
//            }
//        }
//    }
//}
//        .overlay {
//            HStack(spacing: 16) {
//                ForEach(Direction.allCases, id: \.self) { direction in
//                    Button(direction.rawValue) { go(direction) }
//                    .animation(.default, value: canGo(direction))
//                    .disabled(!canGo(direction))
//                }
//            }
//            .bold()
//            .buttonStyle(.borderedProminent)
//            .tint(.primary)
//        }
