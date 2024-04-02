//
//  CardOnFileMock.swift
//
//
//  Created by summer on 4/2/24.
//

import Foundation
import FinanceEntity
@testable import TopupImp

final class CardOnFileBuildableMock: CardOnFileBuildable {
    var buildHandler: ((_ listener: CardOnFileListener) -> CardOnFileRouting)?
    
    var buildCallCount = 0
    var buildPaymentMethods: [PaymentMethod]?
    func build(withListener listener: TopupImp.CardOnFileListener,
               paymentMethods: [PaymentMethod]) -> TopupImp.CardOnFileRouting {
        buildCallCount += 1
        buildPaymentMethods = paymentMethods
        if let buildHandler = buildHandler {
            return buildHandler(listener)
        }
        fatalError()
    }
    
    public init() {}
}
