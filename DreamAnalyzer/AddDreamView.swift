//
//  AddDreamView.swift
//  DreamAnalyzer
//
//  Created by Timur on 4/27/25.
//

import SwiftUI
import SwiftData
import OpenAI

struct AddDreamView: View {
    // MARK: - Properties
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var dreamText: String = ""
    @State private var isAnalyzing: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    private let openAI = OpenAI(apiToken: "REDACTED")
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Dream Details").font(.headline)) {
                    TextEditor(text: $dreamText)
                        .frame(minHeight: 200)
                        .overlay(alignment: .topLeading) {
                            if dreamText.isEmpty {
                                Text("Describe your dream here...")
                                    .foregroundColor(.gray.opacity(0.5))
                                    .padding(.top, 8)
                                    .padding(.leading, 5)
                            }
                        }
                }
                
                Section {
                    Button(action: saveAndAnalyzeDream) {
                        HStack {
                            Spacer()
                            if isAnalyzing {
                                ProgressView()
                                    .padding(.trailing, 8)
                            }
                            Text(isAnalyzing ? "Analyzing..." : "Save & Analyze")
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
    private func saveAndAnalyzeDream() {
        guard !dreamText.isEmpty else { return }
        
        isAnalyzing = true
        
        Task {
            do {
                let analysis = try await analyzeWithChatGPT(dreamText)
                
                await MainActor.run {
                    let newDream = Dream(
                        text: dreamText,
                        date: Date(),
                        analysis: analysis
                    )
                    
                    modelContext.insert(newDream)
                    isAnalyzing = false
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    alertMessage = error.localizedDescription
                    showAlert = true
                    isAnalyzing = false
                }
            }
        }
    }
    
    private func analyzeWithChatGPT(_ dream: String) async throws -> String {
        let systemMessage = ChatQuery.ChatCompletionMessageParam(
            role: .system,
            content: """
            You're a dream interpretation expert. Analyze the dream in 2-3 sentences.
            Use psychological symbolism. Respond in language of dream.
            """
        )!
        
        let userMessage = ChatQuery.ChatCompletionMessageParam(
            role: .user,
            content: dream
        )!
        
        let query = ChatQuery(
            messages: [systemMessage, userMessage],
            model: .gpt3_5Turbo
        )
        
        let result = try await openAI.chats(query: query)
        return result.choices.first?.message.content ?? "Analysis error"
    }
}

// MARK: - Preview
#Preview {
    AddDreamView()
        .modelContainer(for: Dream.self)
}

