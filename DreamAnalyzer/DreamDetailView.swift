//
//  DreamDetailView.swift
//  DreamAnalyzer
//
//  Created by Timur on 4/27/25.
//

import SwiftUI

struct DreamDetailView: View {
    let dream: Dream 
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Recorded on \(dream.date.formatted())")
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                Text(dream.text)
                    .font(.body)
                
                if let analysis = dream.analysis {
                    Text("Analysis:")
                        .font(.headline)
                    Text(analysis)
                        .padding(.top, 4)
                }
            }
            .padding()
        }
        .navigationTitle("Dream Details")
    }
}

#Preview {
    DreamDetailView(dream: Dream(text: "I was flying over mountains", date: Date()))
}

