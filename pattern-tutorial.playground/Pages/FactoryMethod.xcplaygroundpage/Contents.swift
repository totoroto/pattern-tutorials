import UIKit
import PlaygroundSupport

/*
 Factory-Method는 직접 객체를 생성하지 않고
 서브클래스에서 팩토리 메소드를 override 해서 어떤 객체를 생성할 지 정할 수 있습니다.(캡슐화)
 */

protocol Coffee {
    var type: String { get set }
    func doWork()
}

struct Americano: Coffee {
    var type: String = "americano"
    
    func doWork() {
        print("Americano works")
    }
}

struct Latte: Coffee {
    var type: String = "latte"
    
    func doWork() {
        print("Latte works")
    }
}

protocol Creator {
    // MARK: factory method
    func createProduct(contentType: Int) -> Coffee?
//    func someOperation()
}

struct CoffeeCreatorFactory: Creator {
    func createProduct(contentType: Int) -> Coffee? {
        if contentType == 0 {
            return Americano()
        } else {
            return Latte()
        }
        // TODO: 다른 Coffee를 추가 하고싶으면 여기 Factory 수정
    }
}

class ViewController: UIViewController {
    var coffee: Coffee?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let factory = CoffeeCreatorFactory()
        let product = factory.createProduct(contentType: 0) // change
        product?.doWork()
    }
}

PlaygroundPage.current.liveView = ViewController()
