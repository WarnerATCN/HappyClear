//
//  ContentView.swift
//  HappyClear
//
//  Created by Warner Kuo on 2024/12/19.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    let frameWidth:Int = 6
    let level: Int = 5
    @ObservedObject var mainData: MainData
    init() {
        self.mainData = MainData(length: frameWidth, diffcult: level)
    }
    
    var body: some View {
        GeometryReader{ geomertry in
            let currentWidth = min(geomertry.size.width, geomertry.size.height)
            VStack{
                ZStack{
                    BackgroudGrid(length: frameWidth)
                    ForEach(Array(self.mainData.animalDict.values)){ animal in
                        AnimalView(animal: animal, mainData: self.mainData)
                    }                    
                }
                .frame(width: currentWidth, height: currentWidth)
                Button (action:{
                    self.mainData.checkSameLine()
                }){
                    Text("Play")
                        .padding()
                        .border(.gray, width: 1)
                }
                
                Text("当前卡片数量：\(self.mainData.$animalDict.count)")
                    .fontWeight(.bold)
                    .font(.largeTitle)
            }
        }
        
    }

}

#Preview {
    ContentView()
}
