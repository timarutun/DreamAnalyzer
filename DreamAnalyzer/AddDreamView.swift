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
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var dreamText: String = ""
    @State private var isAnalyzing: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    private let openAI = OpenAI(apiToken: Secrets.openAIAPIKey)
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Dream Details")) {
                    TextEditor(text: $dreamText)
                        .frame(minHeight: 200)
                        .overlay {
                            if dreamText.isEmpty {
                                Text("Describe your dream here...")
                                    .foregroundColor(.gray)
                                    .padding(.top, 8)
                                    .padding(.leading, 5)
                            }
                        }
                }
                
                Section {
                    Button(action: analyzeAndSave) {
                        HStack {
                            Spacer()
                            if isAnalyzing {
                                ProgressView()
                            }
                            Text(isAnalyzing ? "Analyzing..." : "Analyze Dream")
                            Spacer()
                        }
                    }
                    .disabled(dreamText.isEmpty || isAnalyzing)
                }
            }
            .navigationTitle("New Dream")
            .alert("Error", isPresented: $showAlert) {
                Button("OK") {}
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func analyzeAndSave() {
        guard !dreamText.isEmpty else { return }

        isAnalyzing = true

        Task {
            do {
                print("🔄 Sending request to OpenAI...")
                let analysis = try await analyzeWithChatGPT(dreamText)
                print("✅ Received analysis: \(analysis)")

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
                print("❌ Error during analysis: \(error.localizedDescription)")
                await MainActor.run {
                    alertMessage = "Analysis failed: \(error.localizedDescription)"
                    showAlert = true
                    isAnalyzing = false
                }
            }
        }
    }


    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func analyzeWithChatGPT(_ text: String) async throws -> String {
        let query = ChatQuery(
            messages: [
                .init(role: .system, content: """
                You're a dream interpreter. Respond in the same language as the user's message.
                Provide 2-3 sentence analysis focusing on psychological meaning.
                """)!,
                .init(role: .user, content: text)!
            ],
            model: .gpt3_5Turbo
        )
        
        do {
            print("🔍 Sending request to OpenAI...")
            let result = try await openAI.chats(query: query)

            if let firstChoice = result.choices.first,
               let content = firstChoice.message.content {
                print("📩 OpenAI response: \(content)")
                return content
            } else {
                print("⚠️ No valid content found in response: \(result)")
                return "No analysis available"
            }
        } catch {
            print("🚨 Error while getting response: \(error)")
            throw error
        }
    }

}

#Preview {
    AddDreamView()
        .modelContainer(for: Dream.self)
}
