//
//  ContentView.swift
//  DreamAnalyzer
//
//  Created by Timur on 4/25/25.
//

import SwiftUI
import SwiftData

struct DreamListView: View {
    // MARK: - Properties
    @Query private var dreams: [Dream] // Auto-fetched from SwiftData
    @Environment(\.modelContext) private var modelContext // For deletions
    
    @State private var isShowingAddView = false // Controls AddDreamView presentation
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            List {
                ForEach(dreams) { dream in
                    NavigationLink {
                        DreamDetailView(dream: dream) // Detail view
                    } label: {
                        DreamRowView(dream: dream) // Custom row UI
                    }
                }
                .onDelete(perform: deleteDream) // Swipe-to-delete
            }
            .navigationTitle("Dream Journal")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingAddView.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingAddView) {
                AddDreamView() // Modal sheet
            }
        }
    }
    
    // MARK: - Methods
    private func deleteDream(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(dreams[index]) // SwiftData deletion
        }
    }
}

// MARK: - Preview
#Preview {
    DreamListView()
        .modelContainer(for: Dream.self) // Preview container
}
