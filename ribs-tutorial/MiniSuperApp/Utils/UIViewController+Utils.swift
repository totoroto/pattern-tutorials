//
//  UIViewController+Utils.swift
//  MiniSuperApp
//
//  Created by summer on 1/3/24.
//

import UIKit

extension UIViewController {
    func setupNavigationItem(target: Any?, action: Selector?) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark",
                                                                          withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)),
                                                           style: .plain,
                                                           target: target,
                                                           action: action)
    }
    
}
