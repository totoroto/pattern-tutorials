//
//  ViewController.swift
//  Coordinator
//
//  Created by summer on 2022/12/11.
//

import UIKit

protocol MainViewControllerDelegate: AnyObject {
    func loggedOut()
}

class MainViewController: UIViewController {
    weak var delegate: MainViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .darkGray
        let item = UIBarButtonItem(title: "LogOut",
                                   style: .plain,
                                   target: self,
                                   action: #selector(didSelectLoggedOut))
        self.navigationItem.rightBarButtonItem = item
    }

    deinit {
        print("\(type(of: self)) deinit")
    }
    
    @objc
    func didSelectLoggedOut() {
        self.delegate?.loggedOut()
    }
}

