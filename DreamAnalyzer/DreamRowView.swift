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
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(dream.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption2)
                    .foregroundStyle(.blue)
                
                Spacer()
                
                if dream.analysis != nil {
                    Image(systemName: "sparkles")
                        .foregroundStyle(.yellow)
                }
            }
            
            Text(dream.text.prefix(60) + (dream.text.count > 60 ? "..." : ""))
                .font(.subheadline)
                .lineLimit(2)
        }
        .padding(.vertical, 8)
    }
}
