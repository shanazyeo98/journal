//
//  DayLogDataStore.swift
//  Journal
//
//  Created by Shanaz Yeo on 15/10/25.
//

import Foundation

class DayLogDataStore {
    static let shared = DayLogDataStore() // 1. singleton
    
    private var logs: [DayLog] = []
    
    private init() {
        self.logs = self.loadDayLogs()
    }

    private var fileURL: URL {
        let documentsPath = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]
        return documentsPath.appendingPathComponent("DayLogs.json")
    }
    
    func getDayLogs() -> [DayLog] {
        return logs
    }
    
    func getDayLog(at index: Int) -> DayLog? {
        if index >= logs.count || index < 0 {
            return nil
        }
        return logs[index]
    }
    
    func loadDayLogs() -> [DayLog] {
        guard let data = try? Data(contentsOf: fileURL),
              let DayLogs = try? JSONDecoder().decode([DayLog].self, from: data) else {
            return []
        }
        return DayLogs
    }

    func saveDayLogs() {
        // 2. try? without error handling
        guard let data = try? JSONEncoder().encode(self.logs) else { return }
        try? data.write(to: fileURL)
    }
    
    func addItem(_ log: DayLog) {
        self.logs.append(log)
        self.logs.sort(by: {$0.date < $1.date})
    }
    
    private func getIndex(_ log: DayLog) -> Int? {
        return self.logs.firstIndex(where: {$0.id == log.id})
    }
    
    func updateItem(_ log: DayLog) {
        let index = getIndex(log)
        guard let index else { return }
        self.logs[index] = log
    }
    
    func deleteItem(_ log: DayLog) {
        let index = getIndex(log)
        guard let index else { return }
        deleteItem(at: index)
    }
    
    func deleteItem(at index: Int) {
        self.logs.remove(at: index)
    }
}
