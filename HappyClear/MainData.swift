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
//    @Published var animals:[Animal]
    @Published var animalDict: [Coordinates: Animal] = [:]
    
    init(length: Int, diffcult: Int) {
//        self.animals = []
        self.frameWidth = length
        self.diffcult = diffcult

        for xpos in (0 ..< Int(self.frameWidth)){
            for ypos in (0 ..< Int(self.frameWidth)){
                let ttype = Int.random(in: 1 ... diffcult)
//                print(ttype)
                let animal = Animal(ttype: ttype, coordinates: Coordinates(x: xpos, y: ypos))
//                self.animals.append(animal)
                animalDict[animal.coordinates] = animal
            }
        }
        
    }
    /**
     检查所有行列上每一张卡片附近是否有连续相同类型的卡片
     */
    func checkSameLine(){
        let direction: Direction = .down
//        sort(in: direction)
        var isCleared = false
//        for animal in self.animals {
        for (coor, animal) in self.animalDict.sorted(by: { $0.key.x < $1.key.x || ($0.key.x == $1.key.x && $0.key.y < $1.key.y) }){
            print("checking x:\(coor)")
            var (hNeighbours, vNeighbours) = getSameNeighbours(animal: animal)
            if hNeighbours.count > 1{
                print("hNeighbours:\(hNeighbours.count )")
                hNeighbours.append(animal)
                for item in hNeighbours {
                    print("移除了：\(item.coordinates)")
                    self.animalDict.removeValue(forKey: item.coordinates)
                    print("横向删除了一个卡片")
                    supply(coordinate: item.coordinates)
//                    if let idx = self.animals.firstIndex(where: {$0.id == item.id}){
//                        self.animals.remove(at: idx)
//                    }
                }
                isCleared.toggle()
                break
            }
            else if vNeighbours.count > 1{
                print("vNeighbours:\(vNeighbours.count )")
                vNeighbours.append(animal)
                for item in vNeighbours {
                    self.animalDict.removeValue(forKey: item.coordinates)
                    print("纵向删除了一个卡片")
                    supply(coordinate: item.coordinates)
//                    if let idx = self.animals.firstIndex(where: {$0.id == item.id}){
//                        self.animals.remove(at: idx)
//                    }
                }
                isCleared.toggle()
                break
            }
        }
        if isCleared{
            // 发生消除事件，进行移动操作
            move(in: direction)
            
            // 移动完后，重新看看有没有可以消除的卡片
            

        }
    }
    /**
        获取同一行列上连续相同类型的卡片。
     return 如果没获取到就返回空数组
     */
    func getSameNeighbours(animal: Animal) -> ([Animal], [Animal]){
        func findNeighbours(dx: Int, dy: Int) -> [Animal]{
            var localNeighbours: [Animal] = []
            for idx in 1 ..< self.frameWidth {
                let newX = animal.coordinates.x + idx * dx
                let newY = animal.coordinates.y + idx * dy
                if newX >= 0 && newX < frameWidth && newY >= 0 && newY < frameWidth{
                    if let targetAnimal = self.animalDict[Coordinates(x: newX, y: newY)], targetAnimal.ttype == animal.ttype{
//                    if let neighbour = self.animals.first(where: {
//                        $0.coordinates.x == newX &&
//                        $0.coordinates.y == newY &&
//                        $0.ttype == animal.ttype
//                    })
                    
                        localNeighbours.append(targetAnimal)
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
    /**
     对已删除的卡片补充新的卡片, 并放置到背景顶部
     如果当前位置已存在，则往上再移一格
     */
    func supply(coordinate: Coordinates){
        //对列进行补充
        let x = coordinate.x
        var y = -1
        while self.animalDict[Coordinates(x: x, y: y)] != nil {
            
            y -= 1
            print("当前位置有卡片，继续向上.\(y)")
        }
        let ttype = Int.random(in: 1 ... diffcult)
        self.animalDict[Coordinates(x: x, y: y)] = Animal(ttype: ttype, coordinates: Coordinates(x: x, y: y))
    }
    /**
        对已经删除的卡片进行补位
     */
    func move(in direction: Direction){
//        sort(in: direction)
        for (coor, animal) in self.animalDict.sorted(by: { $0.key.x < $1.key.x || ($0.key.x == $1.key.x && $0.key.y > $1.key.y) }){
//            print(coor)
            var hasSpace = haveSpace(animal: animal, direction: direction)
            var currentAnimal = animal
            while hasSpace{                
                var newAnimal = currentAnimal
                newAnimal.coordinates = Coordinates(x: currentAnimal.coordinates.x + travel(in: direction).x, y:currentAnimal.coordinates.y + travel(in: direction).y)
                print("开始移动:\(currentAnimal.coordinates),新位置：\(newAnimal.coordinates)")
                self.animalDict[newAnimal.coordinates] = newAnimal
                self.animalDict.removeValue(forKey: currentAnimal.coordinates)
                currentAnimal = newAnimal
//                guard let idx = self.animals.firstIndex(where: {$0.id == animal.id}) else {return}
//                self.animals[idx].coordinates.x += travel(in: direction).x
//                self.animals[idx].coordinates.y += travel(in: direction).y
                hasSpace = haveSpace(animal: currentAnimal, direction: direction)
            }
        }
    }
    func sort(in direction: Direction){
        
        // 先排序
//        self.animalDict.sort { data1, data2 in
//            switch direction{
//            case .up:
//                return data1.coordinates.y < data2.coordinates.y  // 上：y 越小越优先
//            case .down:
//                return data1.coordinates.y > data2.coordinates.y  // 下：y 越大越优先
//            case .left:
//                return data1.coordinates.x < data2.coordinates.x  // 左：x 越小越优先
//            case .right:
//                return data1.coordinates.x > data2.coordinates.x  // 右：x
//            }
//        }
    }
    func travel(in direction: Direction) -> (x: Int, y:Int){
        switch direction{
        case .up: return (0, -1)
        case .down: return (0,1)
        case .left: return(-1,0)
        case .right: return(1,0)
        }
    }

    func haveSpace(animal: Animal, direction: Direction) -> Bool{
//        let currentCard = self.Cards.first(where: {$0.id == id})!
        var position = animal.coordinates
        // 模拟位移
        position.x += (travel(in: direction).x)
        position.y += (travel(in: direction).y)
        if position.x < 0 {
            position.x = 0
        }
        if position.y < 0 {
            position.y = 0
        }
        
        if position.x >= 0 && position.x<frameWidth && position.y >= 0 && position.y < frameWidth{
            guard let target = self.animalDict[position] else{ return true}

//            if let card = self.animals.first(where: { card in
//                card.coordinates.x == position.x && card.coordinates.y == position.y
//            }){
//                return false
//            }
//            else{
//                // 没找到的话，就是可以位移，也无
//                return true
//            }
        }
        
        return false
    }
    
    func addNew(){
//        self.animals.append(Animal(coordinates: Coordinates(x: 1, y: 1)))
    }
}

enum Direction{
    case up
    case down
    case left
    case right
}
