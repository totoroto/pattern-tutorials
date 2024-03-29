//
//  TopupRouterTests.swift
//  MiniSuperApp
//
//  Created by summer on 3/27/24.
//

@testable import TopupImp
import XCTest

final class TopupRouterTests: XCTestCase {

    private var sut: TopupRouter!

    // TODO: declare other objects and mocks you need as private vars

    override func setUp() {
        super.setUp()

        sut = TopupRouter(interactor: <#T##TopupInteractable#>,
                          viewController: <#T##ViewControllable#>,
                          addPaymentMethodBuildable: <#T##AddPaymentMethodBuildable#>,
                          enterAmountBuildable: <#T##EnterAmountBuildable#>,
                          cardOnFileBuildable: <#T##CardOnFileBuildable#>)
    }

    // MARK: - Tests

    func test_routeToExample_invokesToExampleResult() {
        // This is an example of a router test case.
        // Test your router functions invokes the corresponding builder, attachesChild, presents VC, etc.
    }
}
