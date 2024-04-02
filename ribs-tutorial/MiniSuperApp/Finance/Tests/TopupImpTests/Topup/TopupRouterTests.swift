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

    func test_routeToExample_invokesToExampleResult() {
        // This is an example of a router test case.
        // Test your router functions invokes the corresponding builder, attachesChild, presents VC, etc.
    }
}
