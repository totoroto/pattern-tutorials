//
//  TopupDependencyMock.swift
//
//
//  Created by summer on 3/27/24.
//

import Foundation
import FinanceRepository
import FinanceRepositoryTestSupport
import CombineUtil
import FinanceEntity
@testable import TopupImp

final class TopupDependencyMock: TopupInteractorDependency {
    var cardOnFileRepository: CardOnFileRepository = CardOnFileRepositoryMock()
    var paymentMethodStream: CurrentValuePublisher<PaymentMethod> = .init(
        PaymentMethod(id: "", name: "", digits: "", color: "", isPrimary: false)
    )
    
}
