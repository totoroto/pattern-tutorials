//
//  CardOnFileRepository.swift
//  MiniSuperApp
//
//  Created by summer on 12/29/23.
//

import Combine
import Foundation
import FinanceEntity
import CombineUtil
import Network

/// 서버 API를 호출해서 유저의 카드목록을 가져옵니다.
public protocol CardOnFileRepository {
    var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { get }
    func addCard(info: AddPaymentMethodInfo) -> AnyPublisher<PaymentMethod, Error>
    func fetch()
}

public final class CardOnFileRepositoryImpl: CardOnFileRepository {
    private let network: Network
    private let baseURL: URL
    public var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { paymentMethodsSubject }
    
    private let paymentMethodsSubject = CurrentValuePublisher<[PaymentMethod]>([
//        PaymentMethod(id: "0", name: "우리은행", digits: "0123", color: "#f19a38ff", isPrimary: false),
//        PaymentMethod(id: "1", name: "신한카드", digits: "0987", color: "#3478f6ff", isPrimary: false),
//        PaymentMethod(id: "2", name: "현대카드", digits: "8121", color: "#78c5f5ff", isPrimary: false),
//        PaymentMethod(id: "3", name: "국민은행", digits: "2812", color: "#65c466ff", isPrimary: false),
//        PaymentMethod(id: "4", name: "카카오뱅크", digits: "8751", color: "#ffcc00ff", isPrimary: false)
    ])
    private var cancellable: Set<AnyCancellable>
    
    public init(network: Network, baseURL: URL) {
        self.network = network
        self.baseURL = baseURL
        self.cancellable = .init()
    }
    
    public func fetch() {
        let request = CardOnFileRequest(baseURL: baseURL)
        network.send(request).map(\.output.cards).sink { _ in }
        receiveValue: { [weak self] cards in
            self?.paymentMethodsSubject.send(cards)
        }.store(in: &cancellable)

    }
    
    public func addCard(info: AddPaymentMethodInfo) -> AnyPublisher<PaymentMethod, Error> {
        let request = AddCardRequest(baseURL: baseURL,
                                     info: info)
        return network.send(request)
            .map(\.output.card)
            .handleEvents(receiveSubscription: nil,
                          receiveOutput: { [weak self] method in
                guard let self else { return }
                self.paymentMethodsSubject.send(paymentMethodsSubject.value + [method])
            },
                          receiveCompletion: nil,
                          receiveCancel: nil,
                          receiveRequest: nil)
            .eraseToAnyPublisher()
        
//        let paymentMethod = PaymentMethod(id: "00", name: "New 카드", digits: "\(info.number.suffix(4))", color: "", isPrimary: false)
//        
//        var new = paymentMethodsSubject.value
//        new.append(paymentMethod)
//        paymentMethodsSubject.send(new)
//        
//        return Just(paymentMethod).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
