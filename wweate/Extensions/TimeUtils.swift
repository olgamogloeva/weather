//
//  TimeUtils.swift
//  wweate
//
//  Created by Olga Mogloeva on 24.03.2024.
//

import Foundation


enum TimeDateFormat: String {
    case dayWithShortMonthAndTime = "d LLL HH:mm"
    
    case hoursAndMinutes = "HH:mm"
}

 enum TimeUtils {
    static private var dateFormmatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .current
        return formatter
    }()
    
     static func prettyString(from date: Date, dateFormat: TimeDateFormat) -> String {
        dateFormmatter.dateFormat = dateFormat.rawValue
        return dateFormmatter.string(from: date)
    }
    
    static func timeIntervalSince1970ToString(int: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(int))
        return prettyString(from: date, dateFormat: .hoursAndMinutes)
    }
}
    
