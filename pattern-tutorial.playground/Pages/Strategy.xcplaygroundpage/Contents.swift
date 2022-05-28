import UIKit
import PlaygroundSupport
/*:
 The strategy pattern defines a family of interchangeable objects.
 
 This pattern makes apps more flexible and adaptable to changes at
 runtime, instead of requiring compile-time changes.
 
 델리게이트 패턴은 런타임에서 보통 픽스되어있지만, 스트레티지 패턴은 런타임에서 쉽게 교환될 수 있다.
 */

protocol MoveStrategy {
    func execute(cost: Int)
}

struct CarStrategy: MoveStrategy {
    func execute(cost: Int) {
        print("rest : \(String(cost - 100))")
    }
}

struct BusStrategy: MoveStrategy {
    func execute(cost: Int) {
        print("rest: \(String(cost - 50))")
    }
}

struct WalkStrategy: MoveStrategy {
    func execute(cost: Int) {
        print("rest: \(String(cost))")
    }
}

struct MoveContext {
    var strategy: MoveStrategy?
    
    mutating func setStrategy(strategy: MoveStrategy) {
        self.strategy = strategy
    }
    
    func executeStrategy(cost: Int) {
        self.strategy?.execute(cost: cost)
    }
}

class NavigateViewController: UIViewController {
    var context: MoveContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = MoveContext()
        
        let budget = 200 // edit this
        let input = 0 // edit this
        
        switch input {
        case 0:
            context?.setStrategy(strategy: CarStrategy())
        case 1:
            context?.setStrategy(strategy: BusStrategy())
        default:
            context?.setStrategy(strategy: WalkStrategy())
        }
        
        context?.executeStrategy(cost: budget)
    }
}

PlaygroundPage.current.liveView = NavigateViewController()
