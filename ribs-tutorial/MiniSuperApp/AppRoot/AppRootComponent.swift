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

final class AppRootComponent: Component<AppRootDependency>, AppHomeDependency, FinanceHomeDependency, ProfileHomeDependency, TransportHomeDependency  {
    var cardOnFileRepository: CardOnFileRepository
    var superPayRepository: SuperPayRepository
    lazy var transportHomeBuildable: TransportHomeBuildable = {
        TransportHomeBuilder(dependency: self)
    }()
    
    init(dependency: AppRootDependency,
         cardOnFileRepository: CardOnFileRepository,
         superPayRepository: SuperPayRepository) {
        self.cardOnFileRepository = cardOnFileRepository
        self.superPayRepository = superPayRepository
        super.init(dependency: dependency)
    }
    
    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}
