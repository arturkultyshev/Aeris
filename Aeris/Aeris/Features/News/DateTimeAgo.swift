//
//  DateTimeAgo.swift
//  Aeris
//
//  Created by Zhumatay Sayana on 13.12.2025.
//

import Foundation

extension String {

    func timeAgo() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "UTC") 

        guard let date = formatter.date(from: self) else { return "" }

        let hours = Int(Date().timeIntervalSince(date) / 3600)

        if hours < 1 {
            let minutes = Int(Date().timeIntervalSince(date) / 60)
            return "\(minutes)m ago"
        }

        return "\(hours)h ago"
    }
}


