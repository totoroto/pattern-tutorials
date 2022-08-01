import Foundation

/*
 MARK: 옵저버 패턴
 옵저버는 관찰 중(observing)인 객체에서 발생하는 이벤트를
 여러 객체에 알리기 위한 구독(subscription) 메커니즘을 정의할 수 있는 패턴.
 
 - Problem
 두 타입의 객체가 있습니다.
 Customer : 고객은 특정 제품에 관심이 있습니다. 매일 방문하여 제품 재고가 있는 지 확인할 수 있지만 대부분의 방문은 무의미합니다.
 Store : 재고가 있을 때마다 모든 고객에게 이메일을 보낼 수 있지만 이 제품에 관심이 없는 고객들에게 무의미합니다.
 Customer가 시간을 낭비하거나 Store가 자원을 낭비하는 상황입니다.
 
 - Solution
 다른 객체에 변경사항을 알리는 객체를 publisher,
 publisher의 변경 사항을 추적하려는 다른 모든 객체들을 subscriber라고 부릅니다.
 
 publisher에서 이벤트가 발생할 때마다 특정 notification method를 호출하여 subscriber 객체에 전달합니다.
 그래서 모든 subscriber가 동일한 인터페이스를 구현하고 publisher가 해당 인터페이스를 통해서만 subscriber와 통신하는 것이 중요합니다.
 이 인터페이스를 통해 subscriber들은 구체적인 클래스와 결합하지 않고도 publisher의 상태를 observing할 수 있습니다.
 */

protocol Observer: AnyObject {
    func update(num: Int)
}


class EventPublisher {
    private var observers: [Observer] = []
    var numOfProduct: Int = 0
    
    func subscribe(observer: Observer) {
        observers.append(observer)
    }
    
    func unsubscribe(observer: Observer) {
        guard let index = observers.firstIndex(where: { $0 === observer }) else { return }
        print("\nunsubscribe - \(observer)\n")
        observers.remove(at: index)
    }
    
    func notify(num: Int) {
        _ = observers.map({ observer in
            observer.update(num: num)
        })
    }
    
    func arriveProduct() {
        numOfProduct = Int(arc4random_uniform(10))
        print("arrived \(numOfProduct) number of product")
        
        notify(num: numOfProduct)
    }
}

class ObserverMax10: Observer {
    func update(num: Int) {
        if num > 5 {
            print("ObserverMax10 : \(num) arrived")
        }
    }
}

class ObserverMax2: Observer {
    func update(num: Int) {
        if 0 < num && num < 3 {
            print("ObserverMax2 : \(num) arrived")
        }
    }
}


let eventPublisher = EventPublisher()
let observerA = ObserverMax10()
let observerB = ObserverMax2()

eventPublisher.subscribe(observer: observerA)
eventPublisher.subscribe(observer: observerB)

eventPublisher.arriveProduct()
eventPublisher.unsubscribe(observer: observerB)
eventPublisher.arriveProduct()





