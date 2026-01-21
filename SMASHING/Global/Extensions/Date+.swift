//
//  Date+.swift
//  SMASHING
//
//  Created by 이승준 on 1/21/26.
//

import Foundation

enum DateUtils {
    static let iso8601Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
}

extension String {
    var toDateFromISO8601: Date? {
        return DateUtils.iso8601Formatter.date(from: self)
    }
}

extension Date {
    func toRelativeString() -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .weekOfMonth, .day, .hour, .minute, .second], from: self, to: now)
        
        if let year = components.year, year >= 1 {
            return "\(year)년 전"
        }
        if let month = components.month, month >= 1 {
            return "\(month)달 전"
        }
        if let week = components.weekOfMonth, week >= 1 {
            return "\(week)주일 전"
        }
        if let day = components.day, day >= 1 {
            return "\(day)일 전"
        }
        if let hour = components.hour, hour >= 1 {
            return "\(hour)시간 전"
        }
        if let minute = components.minute, minute >= 1 {
            return "\(minute)분 전"
        }
        
        return "방금 전"
    }
}

