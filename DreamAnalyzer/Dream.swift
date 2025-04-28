//
//  Item.swift
//  DreamAnalyzer
//
//  Created by Timur on 4/25/25.
//

import Foundation
import SwiftData

@Model
final class Dream {
    var text: String       // The dream's text (e.g., "I was flying over mountains")
    var date: Date         // When the dream was recorded
    var analysis: String?  // ChatGPT analysis (optional until fetched)

    init(text: String, date: Date, analysis: String? = nil) {
        self.text = text
        self.date = date
        self.analysis = analysis
    }
}
