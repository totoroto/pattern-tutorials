//
//  EnterAmountBuilder.swift
//  MiniSuperApp
//
//  Created by summer on 1/3/24.
//

import ModernRIBs
import CombineUtil
import FinanceEntity
import FinanceRepository
import CombineSchedulers
import Foundation

protocol EnterAmountDependency: Dependency {
    var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> { get }
    var superPayRepository: SuperPayRepository { get }
    var mainQueue: AnySchedulerOf<DispatchQueue> { get }
}

final class EnterAmountComponent: Component<EnterAmountDependency>, EnterAmountInteractorDependency {
    var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> { dependency.selectedPaymentMethod }
    var superPayRepository: SuperPayRepository { dependency.superPayRepository }
    var mainQueue: AnySchedulerOf<DispatchQueue> { dependency.mainQueue }
}

// MARK: - Builder

protocol EnterAmountBuildable: Buildable {
    func build(withListener listener: EnterAmountListener) -> EnterAmountRouting
}

final class EnterAmountBuilder: Builder<EnterAmountDependency>, EnterAmountBuildable {
    
    override init(dependency: EnterAmountDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: EnterAmountListener) -> EnterAmountRouting {
        let component = EnterAmountComponent(dependency: dependency)
        let viewController = EnterAmountViewController()
        let interactor = EnterAmountInteractor(presenter: viewController,
                                               dependency: component)
        interactor.listener = listener
        return EnterAmountRouter(interactor: interactor, viewController: viewController)
    }
}
