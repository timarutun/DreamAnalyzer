//
//  DreamAnalyzerApp.swift
//  DreamAnalyzer
//
//  Created by Timur on 4/25/25.
//

import SwiftUI
import SwiftData

@main
struct DreamAnalyzerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Dream.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            DreamListView()
        }
        .modelContainer(sharedModelContainer)
    }
}
