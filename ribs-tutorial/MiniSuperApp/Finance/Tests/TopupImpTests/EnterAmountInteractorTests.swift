//
//  EnterAmountInteractorTests.swift
//  MiniSuperApp
//
//  Created by summer on 3/26/24.
//

@testable import TopupImp
import XCTest

final class EnterAmountInteractorTests: XCTestCase {

    private var sut: EnterAmountInteractor!
    private var presenter: EnterAmountPresentableMock!
    private var dependency: EnterAmountDependencyMock!
    private var listener: EnterAmountListenerMock!

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
        
        // when
        
        // then
    }
}
