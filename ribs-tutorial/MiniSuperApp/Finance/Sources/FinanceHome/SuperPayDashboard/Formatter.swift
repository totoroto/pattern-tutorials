//
//  Formatter.swift
//  MiniSuperApp
//
//  Created by summer on 12/28/23.
//

import Foundation

struct Formatter {
    static let balanceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}
