//
//  TopupInteractorTests.swift
//  MiniSuperApp
//
//  Created by summer on 3/27/24.
//

@testable import TopupImp
import XCTest

final class TopupInteractorTests: XCTestCase {

    private var sut: TopupInteractor!
    private var dependency: TopupDependencyMock!

    // TODO: declare other objects and mocks you need as private vars

    override func setUp() {
        super.setUp()
        self.dependency = TopupDependencyMock()
        sut = TopupInteractor(dependency: self.dependency)
    }

    // MARK: - Tests

    func test_exampleObservable_callsRouterOrListener_exampleProtocol() {
        // This is an example of an interactor test case.
        // Test your interactor binds observables and sends messages to router or listener.
    }
}
