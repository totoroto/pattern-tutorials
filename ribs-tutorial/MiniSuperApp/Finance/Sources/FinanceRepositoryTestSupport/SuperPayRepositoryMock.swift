//
//  SuperPayRepositoryMock.swift
//
//
//  Created by summer on 3/26/24.
//

import Foundation
import Combine
import CombineUtil
import FinanceRepository

public final class SuperPayRepositoryMock: SuperPayRepository {
    public var balanceSubject = CurrentValuePublisher<Double>(0)
    public var balance: ReadOnlyCurrentValuePublisher<Double> {
        balanceSubject
    }
    
    public var topupCallCount = 0
    public var topupAmount: Double?
    public var topupPaymentID: String?
    public var shouldTopupSucceed = true
    public func topup(amount: Double, paymentMethodID: String) -> AnyPublisher<Void, Error> {
        topupCallCount += 1
        topupAmount = amount
        topupPaymentID = paymentMethodID
        
        if shouldTopupSucceed {
            return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
        } else {
            return Fail(error: NSError(domain: "SuperPayRepositoryMock", code: 0)).eraseToAnyPublisher()
        }
    }
    
    public init() {}
}
