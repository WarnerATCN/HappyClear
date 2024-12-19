//
//  Backgroud.swift
//  HappyClear
//
//  Created by Warner Kuo on 2024/12/19.
//

import SwiftUI

struct BackgroudGrid: View {
    var length: Int = 6
    var body: some View {
        GeometryReader { geometery in
            let cellWidth = geometery.size.width / CGFloat(length)
            let cellHeigth = geometery.size.height / CGFloat(length)
            VStack(spacing: 0){
                ForEach(0 ..< Int(length)){ _ in
                    HStack(spacing: 0) {
                        ForEach(0 ..< Int(length)) { _ in
                            Rectangle()
                                .frame(width: cellWidth, height: cellHeigth)
                                .border(.white)
                                .foregroundStyle(.gray)
                                .cornerRadius(3)
                        }
                    }
                }
            }
        }
        
            
    }
}

#Preview {
    BackgroudGrid()
}
