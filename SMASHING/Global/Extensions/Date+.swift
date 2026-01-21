import Foundation

enum DateUtils {
    private static let formats: [String] = [
        "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSSX",
        "yyyy-MM-dd'T'HH:mm:ssZZZZZ",
        "yyyy-MM-dd'T'HH:mm:ss"
    ]
    
    static let formatters: [DateFormatter] = formats.map { format in
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }
}

extension String {
    var toDateFromISO8601: Date? {
        for formatter in DateUtils.formatters {
            if let date = formatter.date(from: self) {
                return date
            }
        }
        return nil
    }
}

extension Date {
    func toRelativeString() -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .weekOfMonth, .day, .hour, .minute], from: self, to: now)
        
        if let year = components.year, year >= 1 { return "\(year)년 전" }
        if let month = components.month, month >= 1 { return "\(month)달 전" }
        if let week = components.weekOfMonth, week >= 1 { return "\(week)주일 전" }
        if let day = components.day, day >= 1 { return "\(day)일 전" }
        if let hour = components.hour, hour >= 1 { return "\(hour)시간 전" }
        if let minute = components.minute, minute >= 1 { return "\(minute)분 전" }
        
        return "방금 전"
    }
}
