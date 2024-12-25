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

func getReverseDirection(_ direction: Direction) -> Direction{
    switch direction{
    case .down :
        return .up
    case .up :
        return .down
    case .left:
        return .right
    case .right:
        return .left
    }
}

class Animal: Identifiable, ObservableObject{
    var id: UUID = UUID()
    @Published var coordinates: Coordinates
    var ttype = 1
    var willRemove = false
    
    init(coordinates: Coordinates, ttype: Int) {
//        self.id = UUID()
        self.ttype = ttype
        self.coordinates = coordinates
    }
    func clone() -> Animal{
        return Animal(coordinates: self.coordinates, ttype: self.ttype)
    }
}

struct AnimalView: View {
    
    let length:CGFloat = 6

    
    @ObservedObject var animal: Animal
    @ObservedObject var mainData: MainData
    
    @State private var scale: CGFloat = 0.1 // 初始缩放比例从 0.1 开始
    
    var body: some View {
        GeometryReader{ geometry in
            let currentWidth = min(geometry.size.width, geometry.size.height)
            let cellWidth = currentWidth / length
            
            ZStack {
                Image(String(animal.ttype))
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: cellWidth, height: cellWidth)
            .cornerRadius(10)
            .scaleEffect(scale)
            .offset(
                x: CGFloat(self.animal.coordinates.x) * cellWidth,
                y: CGFloat(self.animal.coordinates.y) * cellWidth
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
//            .transition(.scale)
            .animation(.spring(), value: self.animal.coordinates)
            .gesture(
                DragGesture().onEnded { trans in
                    let translation = trans.translation
                    let posx = Int(round(translation.width / length))
                    let posy = Int(round(translation.height / length))
//                    let orignalPos = self.animal.coordinates
                    
                    if max(abs(posx), abs(posy)) > 1{
                        var direction: Direction
                        if abs(posx) > abs(posy) {
                            // 横向还是纵向
                            print(posx)
                            direction = posx > 0 ? .right : .left
                        }
                        else{
                            print(posy)
                            direction = posy > 0 ? .down : .up

                        }
                        self.mainData.swapAniaml(animal: self.animal, direction: direction)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                            if !self.mainData.checkSameLine(){
                                // 没有进行任何消除行为，交换失败
                                self.mainData.swapAniaml(animal: self.animal, direction: getReverseDirection(direction))
                            }
                        }
                    }

                }
            )
        }
    }    
}

#Preview {
//    Animal(coordinates: Coordinates(x:1, y:1))
}
