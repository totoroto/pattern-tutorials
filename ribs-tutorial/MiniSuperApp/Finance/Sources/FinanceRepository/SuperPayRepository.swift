//
//  SuperPayRepository.swift
//  MiniSuperApp
//
//  Created by summer on 1/14/24.
//

import Combine
import Foundation
import CombineUtil

public protocol SuperPayRepository {
    var balance: ReadOnlyCurrentValuePublisher<Double> { get }
    func topup(amount: Double, paymentMethodID: String) -> AnyPublisher<Void, Error>
}

public final class SuperPayRepositoryImpl: SuperPayRepository {
    public var balance: ReadOnlyCurrentValuePublisher<Double> { balanceSubject }
    private let balanceSubject = CurrentValuePublisher<Double>(0)
    
    public func topup(amount: Double, paymentMethodID: String) -> AnyPublisher<Void, Error> {
        let request = TopupRequest(baseURL: baseURL, amount: amount, paymentMethodID: paymentMethodID)
        return network.send(request)
            .handleEvents(receiveSubscription: nil,
                          receiveOutput: { [weak self] _ in
                let newBalance = (self?.balanceSubject.value).map { $0 + amount }
                newBalance.map { self?.balanceSubject.send($0) }
            }, receiveCompletion: nil,
               receiveCancel: nil,
               receiveRequest: nil)
            .map({_ in })
            .eraseToAnyPublisher()
        
//        return Future<Void, Error> { [weak self] promise in
//            self?.bgQueue.async {
//                Thread.sleep(forTimeInterval: 2)
//                promise(.success(()))
//                
//                let newBalance = (self?.balanceSubject.value).map { $0 + amount }
//                newBalance.map { self?.balanceSubject.send($0) }
//            }
//        }.eraseToAnyPublisher()
    }
    
    // API 처럼 동작하도록 흉내
    private let bgQueue = DispatchQueue(label: "topup.repository.queue")
    
    public init() {}
}
