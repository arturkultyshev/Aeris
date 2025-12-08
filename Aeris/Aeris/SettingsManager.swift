//
//  SettingsManager.swift
//  Aeris
//
//  Created by Zhumatay Sayana on 07.12.2025.
//


import Foundation
enum Metric: String { case pm25 = "pm25", pm10 = "pm10", co2 = "co2", o3 = "o3" }

final class SettingsManager {
    static let shared = SettingsManager()
    private let hasNotificationsKey = "hasNotifications"
    private let defaultMetricKey = "defaultMetric"
    
    var hasNotifications: Bool {
        get { UserDefaults.standard.bool(forKey: hasNotificationsKey) }
        set { UserDefaults.standard.set(newValue, forKey: hasNotificationsKey) }
    }
    
    var defaultMetric: Metric {
        get {
            if let raw = UserDefaults.standard.string(forKey: defaultMetricKey),
               let m = Metric(rawValue: raw) { return m }
            return .pm25
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: defaultMetricKey)
        }
    }
    
    func clearCache() {
        //url cash clear exmaple
        URLCache.shared.removeAllCachedResponses()
        let fm = FileManager.default
        if let caches = fm.urls(for: .cachesDirectory, in: .userDomainMask).first {
            do {
                let items = try fm.contentsOfDirectory(at: caches, includingPropertiesForKeys: nil)
                for url in items {
                    try? fm.removeItem(at: url)
                }
            } catch { /* ignore */ }
        }
    }
}

