//
//  BorderVsStrokeBorder.swift
//  Shared SwiftUI Content
//
//  Created by Олег Еременко on 15.04.2023.
//

import SwiftUI

struct StrokeVsStrokeBorder: View {
    var body: some View {
        ScrollView {
            VStack {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.red, lineWidth: 4)
                    .frame(height: 100)
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(.blue, lineWidth: 4)
                    .frame(height: 100)
            }
            .padding(.horizontal)
        }
    }
}

struct StrokeVsStrokeBorder_Previews: PreviewProvider {
    static var previews: some View {
        StrokeVsStrokeBorder()
    }
}
