//
//  AddPaymentMethodInfo.swift
//  MiniSuperApp
//
//  Created by summer on 1/1/24.
//

import Foundation

public struct AddPaymentMethodInfo {
    public let number: String
    public let cvc: String
    public let expiration: String
    
    public init(number: String, cvc: String, expiration: String) {
        self.number = number
        self.cvc = cvc
        self.expiration = expiration
    }
}
