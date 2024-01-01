//
//  AdaptivePresentationControllerDelegate.swift
//  MiniSuperApp
//
//  Created by summer on 1/1/24.
//

import UIKit

protocol AdaptivePresentationControllerDelegate: AnyObject {
    func presentationControllerDidDismiss()
}

/*
    UIAdaptivePresentationControllerDelegate를 대신해서 받아오는 객체.
    FinanceHomeInteractor가 `UIKit`을 모르기 때문에 어댑터로 감싸서 받아오는 역할
*/
final class AdaptivePresentationControllerDelegateProxy: NSObject, UIAdaptivePresentationControllerDelegate {
    weak var delegate: AdaptivePresentationControllerDelegate?
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        delegate?.presentationControllerDidDismiss()
    }
}
