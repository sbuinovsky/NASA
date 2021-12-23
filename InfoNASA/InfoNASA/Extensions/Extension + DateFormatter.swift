//
//  Extension + DateFormatter.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 23.12.2021.
//

import Foundation

extension DateFormatter {
    static func stringFromDate(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    static func dateFromString(for string: String) -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: string) else { return Date.now }
        return date
    }
    
    static func getDateRange(forDays days: Int, to startDate: Date) -> [String: String] {
        
        let timeInterval = TimeInterval(-3600 * 24 * (days - 1))
        let endDate = Date(timeInterval: timeInterval, since: startDate)
        
        let stringStartDate = DateFormatter.stringFromDate(for: startDate)
        let stringEndDate = DateFormatter.stringFromDate(for: endDate)
        
        return [
            "start_date": stringStartDate,
            "end_date": stringEndDate
        ]
    }
}
