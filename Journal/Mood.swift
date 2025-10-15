//
//  Mood.swift
//  Journal
//
//  Created by Shanaz Yeo on 10/10/25.
//

import Foundation

enum Mood: String, CaseIterable {
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
