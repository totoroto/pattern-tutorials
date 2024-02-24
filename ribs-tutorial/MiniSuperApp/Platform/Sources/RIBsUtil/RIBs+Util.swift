//
//  DismissButtonType.swift
//
//
//  Created by summer on 2/24/24.
//

import Foundation

public enum DismissButtonType {
    case back, close
    
    public var iconSystemName: String {
        switch self {
        case .back:
            return "chevron.backward"
        case .close:
            return "xmark"
        }
    }
}
