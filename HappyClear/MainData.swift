//
//  MainData.swift
//  HappyClear
//
//  Created by Warner Kuo on 2024/12/19.
//

import Foundation


class MainData: ObservableObject{
    var frameWidth: Int = 6
    var diffcult: Int = 4
    @Published var animals:[Animal]
    
    init(length: Int, diffcult: Int) {
        self.animals = []
        self.frameWidth = length
        self.diffcult = diffcult

        for xpos in (0 ..< Int(self.frameWidth)){
            for ypos in (0 ..< Int(self.frameWidth)){
                let ttype = Int.random(in: 1 ... diffcult)
//                print(ttype)
                self.animals.append(Animal(ttype: ttype, coordinates: Coordinates(x: xpos, y: ypos)))
            }
        }
        
    }
    
    func checkSameLine(){
        for animal in self.animals {
            print("checking x:\(animal.coordinates.x), y:\(animal.coordinates.y)")
            var (hNeighbours, vNeighbours) = getSameNeighbours(animal: animal)
            if hNeighbours.count > 1{
                print("hNeighbours:\(hNeighbours.count )")
                hNeighbours.append(animal)
                for item in hNeighbours {
                    if let idx = self.animals.firstIndex(where: {$0.id == item.id}){
                        self.animals.remove(at: idx)
                    }
                }
                break
            }
            else if vNeighbours.count > 1{
                print("vNeighbours:\(vNeighbours.count )")
                vNeighbours.append(animal)
                for item in vNeighbours {
                    if let idx = self.animals.firstIndex(where: {$0.id == item.id}){
                        self.animals.remove(at: idx)
                    }
                }
                break
            }
        }
    }
    func getSameNeighbours(animal: Animal) -> ([Animal], [Animal]){
        func findNeighbours(dx: Int, dy: Int) -> [Animal]{
            var localNeighbours: [Animal] = []
            for idx in 1 ..< self.frameWidth {
                let newX = animal.coordinates.x + idx * dx
                let newY = animal.coordinates.y + idx * dy
                if newX >= 0 && newX < frameWidth && newY >= 0 && newY < frameWidth{
                    if let neighbour = self.animals.first(where: {
                        $0.coordinates.x == newX &&
                        $0.coordinates.y == newY &&
                        $0.ttype == animal.ttype
                    }){
                        localNeighbours.append(neighbour)
                    }
                    else{
                        break
                    }
                }
                else{
                    break
                }
            }
            return localNeighbours
        }
                
        let hNeighbours = findNeighbours(dx: 1, dy:0) + findNeighbours(dx: -1, dy:0)
        let vNeighbours = findNeighbours(dx: 0, dy: 1) + findNeighbours(dx: 0, dy: -1)

        return (hNeighbours,vNeighbours)
    }
    func addNew(){
        self.animals.append(Animal(coordinates: Coordinates(x: 1, y: 1)))
    }
}
