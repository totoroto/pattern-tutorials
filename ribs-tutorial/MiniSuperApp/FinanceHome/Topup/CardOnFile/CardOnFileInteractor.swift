//
//  CardOnFileInteractor.swift
//  MiniSuperApp
//
//  Created by summer on 1/7/24.
//

import ModernRIBs

protocol CardOnFileRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CardOnFilePresentable: Presentable {
    var listener: CardOnFilePresentableListener? { get set }
    func update(with viewModels: [PaymentMethodViewModel])
}

protocol CardOnFileListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func cardOnFileDidTapClose()
}

final class CardOnFileInteractor: PresentableInteractor<CardOnFilePresentable>, CardOnFileInteractable, CardOnFilePresentableListener {

    weak var router: CardOnFileRouting?
    weak var listener: CardOnFileListener?

    private let paymentMethods: [PaymentMethod]
    
    init(presenter: CardOnFilePresentable, paymentMethods: [PaymentMethod]) {
        self.paymentMethods = paymentMethods
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        presenter.update(with: paymentMethods.map(PaymentMethodViewModel.init))
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didTapClose() {
        listener?.cardOnFileDidTapClose()
    }
    
    func didSelectItem(at: Int) {
        
    }
}
