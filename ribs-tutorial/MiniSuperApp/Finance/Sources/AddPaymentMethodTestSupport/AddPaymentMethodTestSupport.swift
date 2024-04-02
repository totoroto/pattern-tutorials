//
//  AddPaymentMethodTestSupport.swift
//
//
//  Created by summer on 4/2/24.
//

import Foundation
import AddPaymentMethod
import ModernRIBs
import RIBsTestSupport
import RIBsUtil

public final class AddPaymentMethodBuildableMock: AddPaymentMethodBuildable {
    
    public var buildCallCount = 0
    public var closeButtonType: DismissButtonType?
    public func build(withListener listener: AddPaymentMethodListener,
                      closeButtonType: DismissButtonType) -> ViewableRouting {
        buildCallCount += 1
        self.closeButtonType = closeButtonType
        return ViewableRoutingMock(interactable: Interactor(),
                                   viewControllable: ViewControllableMock())
    }
    
    public init() {}
}
