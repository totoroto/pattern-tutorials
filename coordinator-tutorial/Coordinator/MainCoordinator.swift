//
//  MainCoordinator.swift
//  Coordinator
//
//  Created by summer on 2022/12/11.
//

import UIKit

protocol MainCoordinatorDelegate {
    func loggedOut(_ coordinator: MainCoordinator)
}

class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private var navigationController: UINavigationController
    var delegate: MainCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let mainViewController = MainViewController()
        mainViewController.delegate = self
        self.navigationController.viewControllers = [mainViewController]
    }
}

extension MainCoordinator: MainViewControllerDelegate {
    func loggedOut() {
        self.delegate?.loggedOut(self)
    }
}

