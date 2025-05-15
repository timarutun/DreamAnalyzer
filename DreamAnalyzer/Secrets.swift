//
//  Secrets.swift
//  DreamAnalyzer
//
//  Created by Timur on 5/14/25.
//

import Foundation

struct Secrets {
    static var openAIAPIKey: String {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let xml = FileManager.default.contents(atPath: path),
              let plist = try? PropertyListSerialization.propertyList(from: xml, format: nil) as? [String: Any],
              let apiKey = plist["OpenAI_API_Key"] as? String else {
            fatalError("Unable to load OpenAI API Key from Secrets.plist")
        }
        return apiKey
    }
}

