//
//  Mood.swift
//  Journal
//
//  Created by Shanaz Yeo on 10/10/25.
//

import Foundation

nonisolated enum Mood: String, CaseIterable, Codable, Hashable {
    case good = "😊"
    case neutral = "😐"
    case bad = "😔"
    
    var description: String {
        switch self {
        case .good:
            return "Good day"
        case .neutral:
            return "Neutral day"
        case .bad:
            return "Bad day"
        }
    }
}
