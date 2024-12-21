//
//  Animal.swift
//  HappyClear
//
//  Created by Warner Kuo on 2024/12/19.
//

import SwiftUI

struct Coordinates: Equatable, Hashable{
    var x: Int
    var y: Int
}

struct Animal: View, Identifiable {
    var id: UUID = UUID()
    let length:CGFloat = 6
    var ttype = 1
    var coordinates: Coordinates
    
    @State private var scale: CGFloat = 0.1 // 初始缩放比例从 0.1 开始
    
    var body: some View {
        GeometryReader{ geometry in
            let currentWidth = min(geometry.size.width, geometry.size.height)
            let cellWidth = currentWidth / length
            
            ZStack {
                Image(String(ttype))
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: cellWidth, height: cellWidth)
            .cornerRadius(10)
            .scaleEffect(scale)
            .offset(
                x: CGFloat(self.coordinates.x) * cellWidth,
                y: CGFloat(self.coordinates.y) * cellWidth
            )
            .onAppear {
                withAnimation(.easeIn(duration: 0.3)) {
                    //
                    self.scale = 1
                }
            }
            .onDisappear {
                withAnimation(.easeOut(duration: 0.9)) {
                    self.scale = 0.1
                }
            }
            .transition(.scale)
            .animation(.spring(), value: self.coordinates)
        }
    }    
}

#Preview {
    Animal(coordinates: Coordinates(x:1, y:1))
}
