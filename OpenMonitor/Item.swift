//
//  Item.swift
//  OpenMonitor
//
//  Created by Juan Ruiz on 19/10/23.
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
