import UIKit
import PlaygroundSupport

/*:
 The delegation pattern allows an object to use a helper object to perform a task,
 instead of doing the task itself.
 
 This allows for code reuse through object composition, instead of inheritance.
 */

protocol Printable {
    func printMenu()
}

class MenuView: UIView {
    var button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.green
        button.setTitle("BUTTON", for: .normal)
        return button
    }()
    var delegate: Printable?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(button)
        button.addTarget(self, action: #selector(printMenu), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func printMenu() {
        delegate?.printMenu()
    }
}

class StoreViewController: UIViewController, Printable {
    var menuView: MenuView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        menuView?.delegate = self
    }
    
    private func setupUI() {
        self.menuView = MenuView(frame: .zero)
        self.menuView?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.menuView!)
        
        NSLayoutConstraint.activate([
            menuView!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            menuView!.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            menuView!.heightAnchor.constraint(equalToConstant: 100),
            menuView!.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    // MARK: menuView delegate
    func printMenu() {
        print("hamburger")
    }
}

PlaygroundPage.current.liveView = StoreViewController()
PlaygroundPage.current.needsIndefiniteExecution = true
