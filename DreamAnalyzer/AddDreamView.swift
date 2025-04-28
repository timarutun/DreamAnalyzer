//
//  AddDreamView.swift
//  DreamAnalyzer
//
//  Created by Timur on 4/27/25.
//

import SwiftUI
import SwiftData

struct AddDreamView: View {
    // MARK: - Properties
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var dreamText: String = ""
    @State private var isAnalyzing: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Dream Details")) {
                    TextEditor(text: $dreamText)
                        .frame(minHeight: 200)
                        .overlay(
                            dreamText.isEmpty ?
                            Text("Describe your dream here...")
                                .foregroundColor(.gray)
                                .padding(.leading, 5)
                                .padding(.top, 8)
                                .allowsHitTesting(false)
                            : nil,
                            alignment: .topLeading
                        )
                }
                
                Section {
                    Button(action: saveDream) {
                        HStack {
                            Spacer()
                            if isAnalyzing {
                                ProgressView()
                                    .padding(.trailing, 5)
                            }
                            Text(isAnalyzing ? "Analyzing..." : "Save Dream")
                            Spacer()
                        }
                    }
                    .disabled(dreamText.isEmpty || isAnalyzing)
                }
            }
            .navigationTitle("New Dream")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Error", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    // MARK: - Methods
    private func saveDream() {
        guard !dreamText.isEmpty else { return }
        
        isAnalyzing = true
        
        // ChatGPT API here
        // Simulating analysis after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let analysis = generateMockAnalysis(for: dreamText)
            let newDream = Dream(
                text: dreamText,
                date: Date(),
                analysis: analysis
            )
            
            modelContext.insert(newDream)
            isAnalyzing = false
            dismiss()
        }
    }
    
    private func generateMockAnalysis(for dream: String) -> String {
        let mockAnalyses = [
            "This dream suggests you're processing recent life changes. The symbols indicate transformation.",
            "Your subconscious seems to be working through unresolved conflicts. Pay attention to recurring themes.",
            "The imagery in this dream typically represents creative energy seeking expression.",
            "This appears to be an anxiety dream, possibly related to upcoming challenges.",
            "Your dream shows positive symbols suggesting personal growth and new opportunities."
        ]
        
        return mockAnalyses.randomElement() ?? "Dream analysis unavailable"
    }
}

// MARK: - Preview
#Preview {
    AddDreamView()
        .modelContainer(for: Dream.self)
}

