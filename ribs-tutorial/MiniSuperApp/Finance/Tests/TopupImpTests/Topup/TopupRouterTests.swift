//
//  TopupRouterTests.swift
//  MiniSuperApp
//
//  Created by summer on 3/27/24.
//

@testable import TopupImp
import RIBsTestSupport
import AddPaymentMethodTestSupport
import AddPaymentMethodImp
import ModernRIBs
import XCTest

final class TopupRouterTests: XCTestCase {

    private var sut: TopupRouter!
    private var interactor: TopupInteractableMock!
    private var viewController: ViewControllableMock!
    private var addPaymentMethodBuildable: AddPaymentMethodBuildableMock!
    private var enterAmountBuildable: EnterAmountBuildableMock!
    private var cardOnFileBuildable: CardOnFileBuildableMock!

    // TODO: declare other objects and mocks you need as private vars

    override func setUp() {
        super.setUp()
        
        interactor = TopupInteractableMock()
        viewController = ViewControllableMock()
        addPaymentMethodBuildable = AddPaymentMethodBuildableMock()
        enterAmountBuildable = EnterAmountBuildableMock()
        cardOnFileBuildable = CardOnFileBuildableMock()
        
        sut = TopupRouter(interactor: interactor,
                          viewController: viewController,
                          addPaymentMethodBuildable: addPaymentMethodBuildable,
                          enterAmountBuildable: enterAmountBuildable,
                          cardOnFileBuildable: cardOnFileBuildable)
    }

    // MARK: - Tests

    func testAttachAddPaymentMethod() {
        // given
        
        // when
        sut.attachAddPaymentMethod(closeButtonType: .close)
        
        // then
        XCTAssertEqual(addPaymentMethodBuildable.buildCallCount, 1)
        XCTAssertEqual(addPaymentMethodBuildable.closeButtonType, .close)
        XCTAssertEqual(viewController.presentCallCount, 1)
    }
    
    func testAttachEnterAmount() {
        // given
        let router = EnterAmountRoutingMock(interactable: Interactor(),
                                            viewControllable: ViewControllableMock())
        var assignedListener: EnterAmountListener?
        enterAmountBuildable.buildHandler = { listener in
            assignedListener = listener
            return router
        }
        // when
        sut.attachEnterAmount()
        
        // then
        XCTAssertEqual(enterAmountBuildable.buildCallCount, 1)
        XCTAssertTrue(assignedListener === interactor)
    }
    
    /// resetChildRouting 검증
    func testAttachEnterAmountOnNavigation() {
        // given
        let router = EnterAmountRoutingMock(interactable: Interactor(),
                                            viewControllable: ViewControllableMock())
        var assignedListener: EnterAmountListener?
        enterAmountBuildable.buildHandler = { listener in
            assignedListener = listener
            return router
        }
        // when
        sut.attachAddPaymentMethod(closeButtonType: .close)
        sut.attachEnterAmount()
        
        // then
        XCTAssertEqual(enterAmountBuildable.buildCallCount, 1)
        XCTAssertTrue(assignedListener === interactor)
        XCTAssertEqual(viewController.presentCallCount, 1)
        XCTAssertEqual(sut.children.count, 1)
    }
}
