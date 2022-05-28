import UIKit
import PlaygroundSupport

/*:
 The singleton pattern restricts a class to have only _one_ instance.
 
 The "singleton plus" pattern is also common, which provides a "shared" singleton instance, but it also allows other instances to be created too.
 
 ## Code Example
 */

class SingletonManager {
    static let shared = SingletonManager()
    
    func execute() {
        print("Hello World")
    }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SingletonManager.shared.execute()
    }
}

PlaygroundPage.current.liveView = ViewController()
