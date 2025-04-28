//
//  DreamRowView.swift
//  DreamAnalyzer
//
//  Created by Timur on 4/27/25.
//

import SwiftUI

struct DreamRowView: View {
    let dream: Dream
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(dream.text.prefix(50) + "...") // Truncated preview
                .font(.headline)
            Text(dream.date, format: .dateTime.day().month().year())
                .font(.caption)
                .foregroundStyle(.gray)
        }
        .padding(.vertical, 8)
    }
}
