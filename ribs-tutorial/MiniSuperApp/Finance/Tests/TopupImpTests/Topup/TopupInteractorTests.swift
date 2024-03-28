//
//  TopupInteractorTests.swift
//  MiniSuperApp
//
//  Created by summer on 3/27/24.
//

@testable import TopupImp
import XCTest
import TopupTestSupport
import FinanceEntity
import FinanceRepositoryTestSupport

final class TopupInteractorTests: XCTestCase {

    private var sut: TopupInteractor!
    private var dependency: TopupDependencyMock!
    private var listener: TopupListenerMock!
    private var router: TopupRoutingMock!
    
    private var cardOnFileRepository: CardOnFileRepositoryMock {
        dependency.cardOnFileRepository as! CardOnFileRepositoryMock
    }

    // TODO: declare other objects and mocks you need as private vars

    override func setUp() {
        super.setUp()
        self.dependency = TopupDependencyMock()
        self.listener = TopupListenerMock()
        
        let interator = TopupInteractor(dependency: self.dependency)
        self.router = TopupRoutingMock(interactable: interator)
        
        interator.listener = self.listener
        interator.router = self.router
        self.sut = interator
    }

    // MARK: - Tests

    func testActivate() {
        // given
        let cards = [
            PaymentMethod(id: "0",
                          name: "Zero",
                          digits: "0000",
                          color: "",
                          isPrimary: false)
        ]
        cardOnFileRepository.cardOnFileSubject.send(cards)
 
        // when
        sut.activate()
        
        // then
        XCTAssertEqual(router.attachEnterAmountCallCount, 1)
        XCTAssertEqual(dependency.paymentMethodStream.value.name, "Zero")
    }
    
    func testActivateWithoutCard() {
        // given
        let cards: [PaymentMethod] = []
        cardOnFileRepository.cardOnFileSubject.send(cards)
 
        // when
        sut.activate()
        
        // then
        XCTAssertEqual(router.attachAddPaymentMethodCallCount, 1)
        XCTAssertEqual(router.attachAddPaymentMethodCloseButtonType, .close)
    }
    
    func testDidAddCardWithCard() {
        // given
        let cards = [
            PaymentMethod(id: "0",
                          name: "Zero",
                          digits: "0000",
                          color: "",
                          isPrimary: false)
        ]
        cardOnFileRepository.cardOnFileSubject.send(cards)
        
        let newCard = PaymentMethod(id: "1",
                                    name: "NewCard",
                                    digits: "0001",
                                    color: "",
                                    isPrimary: false)
        // when
        sut.activate()  // isEnterAmountRoot: true
        sut.addPaymentMethodDidAddCard(paymentMethod: newCard)
        
        // then
        XCTAssertEqual(router.popToRootCallCount, 1)
        XCTAssertEqual(dependency.paymentMethodStream.value.id, "1")
    }
    
    func testDidAddCardWithoutCard() {
        // given
        cardOnFileRepository.cardOnFileSubject.send([])
        
        let newCard = PaymentMethod(id: "1",
                                    name: "NewCard",
                                    digits: "0001",
                                    color: "",
                                    isPrimary: false)
        // when
        sut.activate()  // isEnterAmountRoot: true
        sut.addPaymentMethodDidAddCard(paymentMethod: newCard)
        
        // then
        XCTAssertEqual(router.attachEnterAmountCallCount, 1)
        XCTAssertEqual(dependency.paymentMethodStream.value.id, "1")
    }
    
    func testAddPaymentMethodDidTapCloseFromEnterAmount() {
        // given
        let cards = [
            PaymentMethod(id: "0",
                          name: "Zero",
                          digits: "0000",
                          color: "",
                          isPrimary: false)
        ]
        cardOnFileRepository.cardOnFileSubject.send(cards)
        
        // when
        sut.activate()
        sut.addPaymentMethodDidTapClose()
        
        // then
        XCTAssertEqual(router.detachAddPaymentMethodCallCount, 1)
    }
    
    func testAddPaymentMethodDidTapClose() {
        // given
        cardOnFileRepository.cardOnFileSubject.send([])
        
        // when
        sut.activate()
        sut.addPaymentMethodDidTapClose()
        
        // then
        XCTAssertEqual(router.detachAddPaymentMethodCallCount, 1)
        XCTAssertEqual(listener.topupDidCloseCallCOunt, 1)
    }
    
    func testDidSelectCard() {
        // given
        let cards = [
            PaymentMethod(id: "0",
                          name: "Zero",
                          digits: "0000",
                          color: "",
                          isPrimary: false),
            PaymentMethod(id: "1",
                          name: "One",
                          digits: "1111",
                          color: "",
                          isPrimary: false)
        ]
        cardOnFileRepository.cardOnFileSubject.send(cards)
        
        // when
        sut.cardOnFileDidSelect(at: 0)
        
        // then
        XCTAssertEqual(dependency.paymentMethodStream.value.id, "0")
        XCTAssertEqual(router.detachCardOnFileCallCount, 1)
    }
    
    func testDidSelectCardWithInvalidIndex() {
        // given
        let cards = [
            PaymentMethod(id: "0",
                          name: "Zero",
                          digits: "0000",
                          color: "",
                          isPrimary: false),
            PaymentMethod(id: "1",
                          name: "One",
                          digits: "1111",
                          color: "",
                          isPrimary: false)
        ]
        cardOnFileRepository.cardOnFileSubject.send(cards)
        
        // when
        sut.cardOnFileDidSelect(at: 2)
        
        // then
        XCTAssertEqual(dependency.paymentMethodStream.value.id, "")
        XCTAssertEqual(router.detachCardOnFileCallCount, 1)
    }
}
