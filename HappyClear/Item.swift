//
//  Item.swift
//  HappyClear
//
//  Created by Warner Kuo on 2024/12/19.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
