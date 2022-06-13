import UIKit
import PlaygroundSupport

/*
 Abstract Factory 패턴은 concrete subclass를 정의하지 않고
 관련된 객체들의 모음을 생성합니다.
 
 아래 예시에서는 로그인 여부에 따라 달라지는 View 모음을 정의해봅시다.
 */

enum ButtonType {
    case label
    case button
}

// MARK: Factory
protocol LoginViewFactory {
    static func createView(viewType: ButtonType) -> LoginViewType?
}

struct NonLoginFactory: LoginViewFactory {
    static func createView(viewType: ButtonType) -> LoginViewType? {
        switch viewType {
        case .label:
            return NonLoginLabel()
        case .button:
            return NonLoginButton()
        }
    }
}

struct LoginFactory: LoginViewFactory {
    static func createView(viewType: ButtonType) -> LoginViewType? {
        switch viewType {
        case .label:
            return LoginLabel()
        case .button:
            return LoginButton()
        }
    }
}


// MARK: ViewController
class ViewController: UIViewController {
    var viewsFactory: LoginViewFactory.Type?
    var label: LoginViewType!
    var button: LoginViewType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isLogin = false // edit this!
            
        if isLogin {
            viewsFactory = LoginFactory.self
        } else {
            viewsFactory = NonLoginFactory.self
        }
        
        label = viewsFactory?.createView(viewType: .label)
        button = viewsFactory?.createView(viewType: .button)
        
        setupUI()
        setupEvent()
    }
    
    private func setupEvent() {
        label.completionHandler = {}
        button.completionHandler = {
            print("button touched")
        }
    }
    
    private func setupUI() {
        self.view.addSubview(label)
        self.view.addSubview(button)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            button.trailingAnchor.constraint(equalTo: label.trailingAnchor),
        ])
    }
}

// MARK: View
protocol LoginViewType: UIView {
    var completionHandler: (() -> Void)? { get set }
}

class NonLoginLabel: UILabel, LoginViewType {
    var completionHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.text = "NonLoginLabel"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class NonLoginButton: UIButton, LoginViewType {
    var completionHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTitle("NonLoginButton", for: .normal)
        self.setTitleColor(.red, for: .normal)
        self.addTarget(self, action: #selector(didSelectButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func didSelectButton() {
        print("non-loginButton")
        guard let completionHandler = completionHandler else {
            return
        }
        completionHandler()
    }
}

class LoginLabel: UILabel, LoginViewType {
    var completionHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.text = "LoginLabel"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LoginButton: UIButton, LoginViewType {
    var completionHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTitle("LoginButton", for: .normal)
        self.setTitleColor(.black, for: .normal)
        self.addTarget(self, action: #selector(didSelectButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func didSelectButton() {
        print("loginButton")
    }
}

PlaygroundPage.current.liveView = ViewController()
