import UIKit

/*
     - 어댑터 패턴:
     어댑터는 호환되지 않는 객체를 사용할 수 있도록 하는 구조 패턴.
     어댑터 패턴을 통해 래핑하면 내 코드와 3rd-party 클래스 또는 레거시 클래스 등
     클래스 간에 변환기 역할을 하는 중간 계층의 클래스를 만들 수 있습니다.
 */

class Round {
    private var radius: Double
    
    init(radius: Double) {
        self.radius = radius
    }
    
    func getRadius() -> Double {
        return radius
    }
    
    func fits(obj: RoundObject) -> Bool {
        return self.getRadius() >= obj.getRadius()
    }
}

class RoundObject {
    private var radius: Double
    
    init(radius: Double) {
        self.radius = radius
    }
    
    func getRadius() -> Double {
        return radius
    }
}

// 3rd-party or legacy
class SquareObject {
    private var width: Double
    
    init(width: Double) {
        self.width = width
    }
    
    func getWidth() -> Double {
        return width
    }
}

class SquareAdapter: RoundObject {
    private var obj: SquareObject?
    
    init(obj: SquareObject) {
        super.init(radius: 0)
        self.obj = obj
    }
    
    override func getRadius() -> Double {
        guard let obj = obj else { return 0 }
        return obj.getWidth() * sqrt(2) / 2
    }
}

let hole = Round(radius: 5)
let roundObject = RoundObject(radius: 5)
hole.fits(obj: roundObject) // true

let smallSquare = SquareObject(width: 5)
let largeSquare = SquareObject(width: 10)
//        hole.fits(obj: smallSquare) // incompatible error!!

let smallAdapter = SquareAdapter(obj: smallSquare)
let largeAdapter = SquareAdapter(obj: largeSquare)
hole.fits(obj: smallAdapter) // true
hole.fits(obj: largeAdapter) // false
