//
//  DataManager.swift
//  Journal
//
//  Created by Shanaz Yeo on 14/10/25.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    
    private init() {} //prevent external instantiation
    
    var logs: [DayLog] = []
    
}
