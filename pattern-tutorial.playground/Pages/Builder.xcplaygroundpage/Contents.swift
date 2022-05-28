/*
 MARK: Builder Pattern - Creational Pattern
 The builder pattern allows complex objects to be created step-by-step
 instead of all-at-once via a large initializer.
 
 생성할 때 여러 파라미터를 가지거나 복잡한 생성 과정을 가진 객체의 경우
 객체 생성자에서 직접 객체를 생성하지 않고 빌더를 통해서 객체를 생성합니다.
 하단 코드의 Director는 Optional...필요에 따라 구현하면 될듯
 메소드 체이닝을 하면 보기 깔끔합니다.
 */

import UIKit
import PlaygroundSupport

//protocol Builder {
//    func reset()
//    func setWall(wall: Int)
//    func setRoom()
//    func setDoor(door: Int)
//    func build() -> Home?
//}

protocol ChainingAbleBuilder {
    func reset() -> Self
    func setWall(wall: Int) -> Self
    func setRoom() -> Self
    func setDoor(door: Int) -> Self
    func build() -> Home?
}

class Home {
    var wall: Int?
    var door: Int?
    var room: Int?
    var window: Int?
    
    init() { }
    
    func description() -> String {
        guard room != nil, door != nil, window != nil, window != nil else { return "" }
        return "\(room!) room Builder -> wall: \(wall!), door: \(door!) window: \(window!)"
    }
}

class OneRoomBuilder: ChainingAbleBuilder {
    var home: Home?
    
    init() {
        home = Home()
    }
    
    func reset() -> Self {
        home = nil
        home = Home()
        return self
    }
    
    func setWall(wall: Int) -> Self {
        home?.wall = wall
        home?.window = wall % 4
        return self
    }
    
    func setRoom() -> Self {
        home?.room = 1
        return self
    }
    
    func setDoor(door: Int) -> Self {
        home?.door = door
        return self
    }
    
    func build() -> Home? {
        return home
    }
}

class TwoRoomBuilder: ChainingAbleBuilder {
    var home: Home?
    
    init() {
        home = Home()
    }
    
    func reset() -> Self {
        home = Home()
        return self
    }
    
    func setWall(wall: Int) -> Self {
        home?.wall = wall
        home?.window = wall % 4
        return self
    }
    
    func setRoom() -> Self {
        home?.room = 2
        return self
    }
    
    func setDoor(door: Int) -> Self {
        home?.door = door
        return self
    }
    
    func build() -> Home? {
        return home
    }
}

// optional
class Director {
    var builder: ChainingAbleBuilder?
//    func changeBuilder(builder: Builder) {
//        self.builder = builder
//    }
    func changeBuilder(builder: ChainingAbleBuilder) {
        self.builder = builder
    }
    
    func make(type: Int) -> Home? {
        if type == 1 {
            // protocol Builder
            builder = OneRoomBuilder()
            builder?.setRoom()
            builder?.setDoor(door: 2)
            builder?.setWall(wall: 5)
            return builder?.build()
        } else if type == 2 {
            // protocol ChainingAbleBuilder
            return TwoRoomBuilder()
                .setRoom()
                .setDoor(door: 4)
                .setWall(wall: 10)
                .build()
        }
        return nil
    }
}

class ViewController: UIViewController {
    var director: Director?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create Director
        director = Director()
        
        // create one Room
        var result = director?.make(type: 1)
        print(result?.description() ?? "")
        
        // change Builder One to Two
        director?.changeBuilder(builder: TwoRoomBuilder())
        
        // create two Room
        result = director?.make(type: 2)
        print(result?.description() ?? "")
    }
    
}

PlaygroundPage.current.liveView = ViewController()
