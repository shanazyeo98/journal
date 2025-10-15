//
//  DayLog.swift
//  Journal
//
//  Created by Shanaz Yeo on 10/10/25.
//

import Foundation
import UIKit

class DayLog {
    var date: Date
    var photo: UIImage?
    var coffeeDrank: Int
    var description: String?
    var mood: Mood
    
    init(date: Date = Date(), photo: UIImage? = nil, coffeeDrank: Int = 0, description: String? = nil, mood: Mood = .good) {
        self.date = date
        self.photo = photo
        self.coffeeDrank = coffeeDrank
        self.description = description
        self.mood = mood
    }
}

var dayLogData: [Date : DayLog] = [:]
