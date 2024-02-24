//
//  SuperPayDashboardInteractor.swift
//  MiniSuperApp
//
//  Created by summer on 12/26/23.
//

import Combine
import Foundation
import ModernRIBs
import CombineUtil

protocol SuperPayDashboardRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SuperPayDashboardPresentable: Presentable {
    var listener: SuperPayDashboardPresentableListener? { get set }
    
    func updateBalance(_ balance: String)
}

protocol SuperPayDashboardListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func superPayDashboardDidTapTopUp()
}

protocol SuperPayDashboardInteractorDependency {
    // Interactor의 생성자에 balance를 넣어줘도 되지만, 생성자가 바뀌게 되면 수정해야하는 부분이 많아서 프로토콜로 선언해주면 편하다.
    var balance: ReadOnlyCurrentValuePublisher<Double> { get }
    var balanceFormatter: NumberFormatter { get } 
}

final class SuperPayDashboardInteractor: PresentableInteractor<SuperPayDashboardPresentable>, SuperPayDashboardInteractable, SuperPayDashboardPresentableListener {

    weak var router: SuperPayDashboardRouting?
    weak var listener: SuperPayDashboardListener?
    private let dependency: SuperPayDashboardInteractorDependency
    private var cancellables: Set<AnyCancellable>

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: SuperPayDashboardPresentable,
         dependency: SuperPayDashboardInteractorDependency) {
        self.dependency = dependency
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        dependency.balance
            .receive(on: DispatchQueue.main)
            .sink { [weak self] balance in
            self?.dependency.balanceFormatter.string(from: NSNumber(value: balance))
                .map({
                    self?.presenter.updateBalance(String($0))
                })
        }.store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func topupButtonDidTap() {
        listener?.superPayDashboardDidTapTopUp()
    }
}
