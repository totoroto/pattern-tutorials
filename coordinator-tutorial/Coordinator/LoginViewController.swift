//
//  LoginViewController.swift
//  Coordinator
//
//  Created by summer on 2022/12/11.
//

import UIKit

protocol LoginViewControllerDelegate: AnyObject {
    func login()
}

class LoginViewController: UIViewController {
    weak var delegate: LoginViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        let item = UIBarButtonItem(title: "Login",
                                   style: .plain,
                                   target: self,
                                   action: #selector(didSelectBarButtonItem))
        self.navigationItem.rightBarButtonItem = item
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
    
    @objc
    func didSelectBarButtonItem() {
        self.delegate?.login()
    }

}
