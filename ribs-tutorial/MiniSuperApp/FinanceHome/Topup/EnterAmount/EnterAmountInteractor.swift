//
//  EnterAmountInteractor.swift
//  MiniSuperApp
//
//  Created by summer on 1/3/24.
//

import Combine
import Foundation
import ModernRIBs

protocol EnterAmountRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol EnterAmountPresentable: Presentable {
    var listener: EnterAmountPresentableListener? { get set }
    
    func updateSelectedPaymentMethod(with viewModel: SelectedPaymentMethodViewModel)
    func startLoading()
    func stopLoading()
}

protocol EnterAmountListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func enterAmountDidTapClose()
    func enterAmountDidTapPaymentMethod()
    func enterAmountDidFinishTopup()
}

protocol EnterAmountInteractorDependency {
    var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> { get }
    var superPayRepository: SuperPayRepository { get }
}

final class EnterAmountInteractor: PresentableInteractor<EnterAmountPresentable>, EnterAmountInteractable, EnterAmountPresentableListener {
    
    weak var router: EnterAmountRouting?
    weak var listener: EnterAmountListener?
    private let dependency: EnterAmountInteractorDependency
    
    private var cancellables: Set<AnyCancellable>
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: EnterAmountPresentable,
         dependency: EnterAmountInteractorDependency) {
        self.dependency = dependency
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        
        dependency.selectedPaymentMethod.sink { [weak self] paymentMethod in
            self?.presenter.updateSelectedPaymentMethod(with: SelectedPaymentMethodViewModel(paymentMethod))
        }.store(in: &cancellables)
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didTapClose() {
        listener?.enterAmountDidTapClose()
    }
    
    func didTapPaymentMethod() {
        listener?.enterAmountDidTapPaymentMethod()
    }
    
    func didTapTopup(with amount: Double) {
        presenter.startLoading()
        
        dependency.superPayRepository.topup(amount: amount,
                                            paymentMethodID: dependency.selectedPaymentMethod.value.id)
        .receive(on: DispatchQueue.main)
        .sink { [weak self] _ in
            self?.presenter.stopLoading()
        }
        receiveValue: { [weak self] _ in
            // 충전이 완료됨을 부모 리블렛에게 알려줌
            self?.listener?.enterAmountDidFinishTopup()
        }.store(in: &cancellables)
    }
}
