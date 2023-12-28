//
//  SuperPayDashboardBuilder.swift
//  MiniSuperApp
//
//  Created by summer on 12/26/23.
//

import Foundation
import ModernRIBs

protocol SuperPayDashboardDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
    var balance: ReadOnlyCurrentValuePublisher<Double> { get } // 부모로부터 받고싶은 디펜던시
}

final class SuperPayDashboardComponent: Component<SuperPayDashboardDependency>, SuperPayDashboardInteractorDependency {
    var balance: ReadOnlyCurrentValuePublisher<Double> { dependency.balance }
    var balanceFormatter: NumberFormatter { Formatter.balanceFormatter }

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol SuperPayDashboardBuildable: Buildable {
    func build(withListener listener: SuperPayDashboardListener) -> SuperPayDashboardRouting
}

final class SuperPayDashboardBuilder: Builder<SuperPayDashboardDependency>, SuperPayDashboardBuildable {

    override init(dependency: SuperPayDashboardDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SuperPayDashboardListener) -> SuperPayDashboardRouting {
        let component = SuperPayDashboardComponent(dependency: dependency)
        let viewController = SuperPayDashboardViewController()
        let interactor = SuperPayDashboardInteractor(presenter: viewController,
                                                     dependency: component) // 컴포넌트는 리블렛과 자식 리블렛에 필요한 객체를 담는 바구니
        interactor.listener = listener
        return SuperPayDashboardRouter(interactor: interactor, viewController: viewController)
    }
}
