//
//  PaymentMethod.swift
//  MiniSuperApp
//
//  Created by summer on 12/29/23.
//

import Foundation

struct PaymentMethod: Decodable {
    let id: String
    let name: String
    let digits: String
    let color: String
    let isPrimary: Bool
}
