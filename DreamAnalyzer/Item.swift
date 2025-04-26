//
//  Item.swift
//  DreamAnalyzer
//
//  Created by Timur on 4/25/25.
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
