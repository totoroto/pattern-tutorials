//
//  AppRootComponent.swift
//  MiniSuperApp
//
//  Created by summer on 3/16/24.
//

import Foundation
import FinanceRepository
import FinanceHome
import AppHome
import ProfileHome
import ModernRIBs
import TransportHome
import TransportHomeImp
import Topup
import TopupImp
import AddPaymentMethod
import AddPaymentMethodImp

final class AppRootComponent: Component<AppRootDependency>, AppHomeDependency, FinanceHomeDependency, ProfileHomeDependency, TransportHomeDependency, TopupDependency, AddPaymentMethodDependency {
    var cardOnFileRepository: CardOnFileRepository
    var superPayRepository: SuperPayRepository
    lazy var topupBuildable: TopupBuildable = {
        TopupBuilder(dependency: self)
    }()
    var topupBaseViewController: ViewControllable { rootViewController.topViewControllable }
    private let rootViewController: ViewControllable
    
    lazy var transportHomeBuildable: TransportHomeBuildable = {
        TransportHomeBuilder(dependency: self)
    }()
    
    lazy var addPaymentMethodBuildable: AddPaymentMethodBuildable = {
        AddPaymentMethodBuilder(dependency: self)
    }()
    
    
    init(dependency: AppRootDependency,
         cardOnFileRepository: CardOnFileRepository,
         superPayRepository: SuperPayRepository,
         rootViewController: ViewControllable) {
        self.cardOnFileRepository = cardOnFileRepository
        self.superPayRepository = superPayRepository
        self.rootViewController = rootViewController
        super.init(dependency: dependency)
    }
    
    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}
