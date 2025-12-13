//
//  SettingsManager.swift
//  Aeris
//
//  Created by Zhumatay Sayana on 07.12.2025.
//

import Foundation

final class SettingsManager {

    static let shared = SettingsManager()

    private let hasNotificationsKey = "hasNotifications"
    private let defaultMetricKey = "defaultMetric"


    var hasNotifications: Bool {
        get {
            UserDefaults.standard.bool(forKey: hasNotificationsKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: hasNotificationsKey)
        }
    }


    var defaultMetric: AirQualityMetric {
        get {
            let raw = UserDefaults.standard.integer(forKey: defaultMetricKey)
            return AirQualityMetric(rawValue: raw) ?? .pm25
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: defaultMetricKey)
        }
    }


    func clearCache() {
        URLCache.shared.removeAllCachedResponses()

        let fm = FileManager.default
        if let caches = fm.urls(for: .cachesDirectory, in: .userDomainMask).first {
            let items = (try? fm.contentsOfDirectory(at: caches, includingPropertiesForKeys: nil)) ?? []
            items.forEach { try? fm.removeItem(at: $0) }
        }
    }
}
