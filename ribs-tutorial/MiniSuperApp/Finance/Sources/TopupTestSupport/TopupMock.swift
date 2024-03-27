//
//  TopupMock.swift
//
//
//  Created by summer on 3/28/24.
//

import Foundation
import Topup

public final class TopupListenerMock: TopupListener {
    
    public var topupDidCloseCallCOunt = 0
    public func topupDidClose() {
        topupDidCloseCallCOunt += 1
    }
    
    public var topupDidFinishCallCount = 0
    public func topupDidFinish() {
        topupDidFinishCallCount += 1
    }
    
    public init() {}
}
