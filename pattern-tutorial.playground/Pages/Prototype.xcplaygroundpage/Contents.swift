import Foundation
import UIKit

/*
 프로토 타입: 클래스에 의존하지 않고 기존 객체를 복사할 수 있는 생성 패턴.
 
 - Problem
 어떤 객체와 똑같은 객체를 복사하고 싶다면, 인스턴스 생성 후 필드를 모두 copy하는데
 private한 필드들은 copy되지 않을 수 있다.
 추가로 복사본을 만들려면 해당 객체의 클래스를 알아야하기 때문에 코드가 종속됩니다.
 
 - Solution
 프로토 타입 패턴은 복사 프로세스를 복사중인 실제 객체에 위임합니다.
 공통된 인터페이스를 선언하여 객체에 대한 복사(clone)를 지원하여 코드를 해당 객체의 클래스에 연결하지 않고
 객체를 복사할 수 있습니다.
 
 * clone 메소드 구현하기
 현재 클래스의 객체를 만들고 old 객체의 모든 필드값을 new 객체로 전달합니다.
 여기서 복제를 지원하는 객체를 prototype이라고 합니다.
 (객체에 필드가 복잡하고 가능한 구성이 여러개인 경우, 해당 필드를 복제하는 것이
 새 객체를 생성하는 것보다 나을 수 있습니다.)
 
 prototype 패턴은 세포 분열과 유사합니다.
 원본 세포는 프로토타입 역할을 하며 복사본을 만드는 데 적극적인 역할을 합니다.
 */

protocol Clonable {
    associatedtype Prototype
 
    init(source: Prototype)
    func clone() -> Prototype
}

class Shape: Clonable {
    private var width: CGFloat
    private var height: CGFloat
    
    init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }
    
    required init(source: Shape) {
        self.width = source.width
        self.height = source.height
    }
    
    func clone() -> Shape {
        return Shape(source: self)
    }
}

let origin = Shape(width: 5, height: 10)
let clone = origin.clone()
