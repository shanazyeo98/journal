//
//  DayLog.swift
//  Journal
//
//  Created by Shanaz Yeo on 10/10/25.
//

import Foundation

nonisolated struct DayLog: Identifiable, Codable, Hashable {
    let id: UUID //required for diffable data source
    var date: Date
    var photo: Data?
    var coffeeDrank: Int
    var description: String?
    var mood: Mood
    
    init(id: UUID = UUID(), date: Date = Date(), photo: Data? = nil, coffeeDrank: Int = 0, description: String? = nil, mood: Mood = .good) {
        self.id = id
        self.date = date
        self.photo = photo
        self.coffeeDrank = coffeeDrank
        self.description = description
        self.mood = mood
    }
}

//nonisolated extension DayLog {
//    static func == (lhs: DayLog, rhs: DayLog) -> Bool {
//        lhs.id == rhs.id
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//}
