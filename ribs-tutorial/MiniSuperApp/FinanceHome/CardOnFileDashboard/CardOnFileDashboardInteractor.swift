//
//  CardOnFileDashboardInteractor.swift
//  MiniSuperApp
//
//  Created by summer on 12/28/23.
//

import Combine
import ModernRIBs

protocol CardOnFileDashboardRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CardOnFileDashboardPresentable: Presentable {
    var listener: CardOnFileDashboardPresentableListener? { get set }
    func update(with viewModels: [PaymentMethodViewModel])
}

protocol CardOnFileDashboardListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
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
        dependency.cardsOnFileRepository.cardOnFile.sink { model in
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
}
