//
//  EnterAmountInteractorTests.swift
//  MiniSuperApp
//
//  Created by summer on 3/26/24.
//

@testable import TopupImp
import XCTest
import FinanceEntity
import FinanceRepositoryTestSupport

final class EnterAmountInteractorTests: XCTestCase {

    private var sut: EnterAmountInteractor!
    private var presenter: EnterAmountPresentableMock!
    private var dependency: EnterAmountDependencyMock!
    private var listener: EnterAmountListenerMock!
    private var repository: SuperPayRepositoryMock {
        dependency.superPayRepository as! SuperPayRepositoryMock
    }
    // TODO: declare other objects and mocks you need as private vars

    override func setUp() {
        super.setUp()
        self.presenter = EnterAmountPresentableMock()
        self.dependency = EnterAmountDependencyMock()
        self.listener = EnterAmountListenerMock()
        
        sut = EnterAmountInteractor(presenter: presenter,
                                    dependency: dependency)
        sut.listener = self.listener
        // TODO: instantiate objects and mocks
    }

    // MARK: - Tests

    func testActivate() {
        // given
        let paymentMethod = PaymentMethod(id: "id0",
                                          name: "name0",
                                          digits: "0000",
                                          color: "#FFFFFF",
                                          isPrimary: false)
        dependency.selectedPaymentMethodSubject.send(paymentMethod)
        
        // when
        sut.activate()
        
        // then
        XCTAssertEqual(presenter.updateSelectedPaymentMethodCallCount, 1)
        XCTAssertEqual(presenter.updateSelectedPaymentMethodViewModel?.name, "name0 0000")
        XCTAssertNotNil(presenter.updateSelectedPaymentMethodViewModel?.image)
    }
    
    func testTopupWithValidAmount() {
        // given
        let paymentMethod = PaymentMethod(id: "id0",
                                          name: "name0",
                                          digits: "0000",
                                          color: "#FFFFFF",
                                          isPrimary: false)
        dependency.selectedPaymentMethodSubject.send(paymentMethod)
        
        // when
        sut.didTapTopup(with: 1_000_000)
        
        // then
        XCTAssertEqual(presenter.startLoadingCallCount, 1)
        XCTAssertEqual(presenter.stopLoadingCallCount, 1)
        XCTAssertEqual(repository.topupCallCount, 1)
        XCTAssertEqual(repository.topupPaymentID, "id0")
        XCTAssertEqual(repository.topupAmount, 1_000_000)
        XCTAssertEqual(listener.enterAmountDidFinishTopupCallCount, 1)
    }
    
    func testTopupWithFailure() {
        // given
        let paymentMethod = PaymentMethod(id: "id0",
                                          name: "name0",
                                          digits: "0000",
                                          color: "#FFFFFF",
                                          isPrimary: false)
        dependency.selectedPaymentMethodSubject.send(paymentMethod)
        
        repository.shouldTopupSucceed = false
        // when
        sut.didTapTopup(with: 1_000_000)
        
        // then
        XCTAssertEqual(presenter.startLoadingCallCount, 1)
        XCTAssertEqual(presenter.stopLoadingCallCount, 1)
        XCTAssertEqual(listener.enterAmountDidFinishTopupCallCount, 0)
    }
    
    func testDidTapClose() {
        // given
        
        // when
        sut.didTapClose()
        
        // then
        XCTAssertEqual(listener.enterAmountDidTapCloseCallCount, 1)
    }
    
    func testDidTapPaymentMethod() {
        // given
        
        // when
        sut.didTapPaymentMethod()
        // then
        XCTAssertEqual(listener.enterAmountDidTapPaymentMethodCallCount, 1)
    }
}
