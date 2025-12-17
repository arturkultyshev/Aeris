//
//  DateTimeAgo.swift
//  Aeris
//
//  Created by Zhumatay Sayana on 13.12.2025.
//

import Foundation

extension String {

    func timeAgo() -> String {
        let now = Date()
        
        let formats: [(format: String, locale: Locale?)] = [
            ("yyyy-MM-dd'T'HH:mm:ssXXXXX", Locale(identifier: "en_US_POSIX")),
            ("yyyy-MM-dd'T'HH:mm:ssZ",     Locale(identifier: "en_US_POSIX")),
            ("yyyy-MM-dd HH:mm:ss",        nil),
            ("d MMMM yyyy, HH:mm",         Locale(identifier: "ru_RU"))
        ]
        
        var parsedDate: Date? = nil
        
        for (fmt, locale) in formats {
            let formatter = DateFormatter()
            formatter.dateFormat = fmt
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            if let locale = locale {
                formatter.locale = locale
            }
            if let d = formatter.date(from: self) {
                parsedDate = d
                break
            }
        }
        
        guard let date = parsedDate else {
            return "" 
        }
        
        let seconds = Int(now.timeIntervalSince(date))
        let minutes = seconds / 60
        let hours   = seconds / 3600
        let days    = seconds / 86400
        
        switch seconds {
        case ..<60:
            return "just now"
        case ..<3600:
            return "\(minutes)m ago"
        case ..<86400:
            return "\(hours)h ago"
        default:
            return "\(days)d ago"
        }
    }
}



