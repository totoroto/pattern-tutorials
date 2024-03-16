//
//  Formatter.swift
//  MiniSuperApp
//
//  Created by summer on 3/15/24.
//

import Foundation

struct Formatter {
    static let balanceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}
