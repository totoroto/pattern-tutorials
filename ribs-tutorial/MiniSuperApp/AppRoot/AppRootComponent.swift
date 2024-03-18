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
import Network
import NetworkImp

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
         rootViewController: ViewControllable) {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [SuperAppURLProtocol.self]
        setupURLProtocol() // 커스텀하게 설정된 Response 리턴
        
        let network = NetworkImp(session: URLSession(configuration: config))
        self.cardOnFileRepository = CardOnFileRepositoryImpl(network: network,
                                                             baseURL: BaseURL().financeBaseURL)
        self.cardOnFileRepository.fetch() // 커스텀하게 설정된 Response 리턴
        self.superPayRepository = SuperPayRepositoryImpl(network: network,
                                                         baseURL: BaseURL().financeBaseURL)
        self.rootViewController = rootViewController
        super.init(dependency: dependency)
    }
    
    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}
