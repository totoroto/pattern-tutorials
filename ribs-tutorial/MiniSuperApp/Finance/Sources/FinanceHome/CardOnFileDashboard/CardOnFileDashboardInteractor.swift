//
//  CardOnFileDashboardInteractor.swift
//  MiniSuperApp
//
//  Created by summer on 12/28/23.
//

import Combine
import ModernRIBs
import FinanceRepository
import Foundation

protocol CardOnFileDashboardRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CardOnFileDashboardPresentable: Presentable {
    var listener: CardOnFileDashboardPresentableListener? { get set }
    func update(with viewModels: [PaymentMethodViewModel])
}

protocol CardOnFileDashboardListener: AnyObject {
    // 부모에게 어떤 이벤트가 발생했다는 것을 알릴 수 있다
    func cardOnFileDashboardDidTapAddPaymentMethod()
}

protocol CardOnFileDashboardInteractorDependency {
    var cardsOnFileRepository: CardOnFileRepository { get }
}

final class CardOnFileDashboardInteractor: PresentableInteractor<CardOnFileDashboardPresentable>, CardOnFileDashboardInteractable, CardOnFileDashboardPresentableListener {

    weak var router: CardOnFileDashboardRouting?
    weak var listener: CardOnFileDashboardListener?
    
    private let dependency: CardOnFileDashboardInteractorDependency
    private var cancellables: Set<AnyCancellable>

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: CardOnFileDashboardPresentable,
         dependency: CardOnFileDashboardInteractorDependency) {
        self.dependency = dependency
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        dependency.cardsOnFileRepository.cardOnFile
            .receive(on: DispatchQueue.main)
            .sink { model in
            let viewModel = model.prefix(5).map(PaymentMethodViewModel.init)
            self.presenter.update(with: viewModel)
        }.store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
        
        // retain Cycle 생기지 않도록 Cancellable 삭제. 이러면 weak self 생략 가능
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    func didTapAddPaymentMethod() {
        // 부모인 Finance Home에서 리블렛을 띄우자. 리블렛간 통신은 interactor 끼리하는데
        // CardOnFileDashBoardListener: 부모 리블렛의 Interactor
        listener?.cardOnFileDashboardDidTapAddPaymentMethod()
    }
}
