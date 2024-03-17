//
//  Array+Utils.swift
//  
//
//  Created by summer on 2/25/24.
//

import Foundation

extension Array {
  subscript(safe index: Int) -> Element? {
    return indices ~= index ? self[index] : nil
  }
}
