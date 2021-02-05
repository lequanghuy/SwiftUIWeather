//
//  IntExtensions.swift
//  SwiftUIWeather
//
//  Created by Lê Huy on 23/01/2021.
//

import Foundation

extension Int {
    func timeStampToString(format: String, timezone: String?) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let formatter = DateFormatter()
        formatter.dateFormat = format
        if let safeTimezone = timezone {
            formatter.timeZone = TimeZone(identifier: safeTimezone)
        }
        return formatter.string(from: date)
    }
}
