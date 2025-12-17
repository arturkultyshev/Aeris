//
//  AirQualityModels.swift
//  Aeris
//
//  Created by Артур Култышев on 07.12.2025.
//

import UIKit

enum AirQualityMetric: Int, CaseIterable {
    case pm25 = 0
    case pm10
    case co2
    case o3

    var title: String {
        switch self {
        case .pm25: return "PM2.5"
        case .pm10: return "PM10"
        case .co2:  return "CO2"
        case .o3:   return "O3"
        }
    }

    var unit: String {
        switch self {
        case .pm25, .pm10: return "µg/m³"
        case .co2: return "ppm"
        case .o3:  return "ppb"
        }
    }
}

struct City {
    let name: String       
    let state: String
    let country: String
    let imageName: String
    let subtitle: String
    let latitude: Double
    let longitude: Double

    var airQuality: AirQualityData?
}

struct AirQualityData {
    let pm25: Int
    let pm10: Int
    let co2: Int
    let o3: Int

    func value(for metric: AirQualityMetric) -> Int {
        switch metric {
        case .pm25: return pm25
        case .pm10: return pm10
        case .co2:  return co2
        case .o3:   return o3
        }
    }

    func category(for metric: AirQualityMetric) -> AirQualityCategory {
        AirQualityCategory(value: value(for: metric))
    }
}

struct AirQualityCategory {
    let title: String
    let color: UIColor
    let shortDescription: String
    let advice: String

    init(value: Int) {
        switch value {
        case 0...50:
            title = "Good"
            color = UIColor.systemGreen
            shortDescription = "Air quality is considered satisfactory."
            advice = "Air quality is acceptable for most people."
        case 51...100:
            title = "Moderate"
            color = UIColor.systemYellow
            shortDescription = "Acceptable air quality."
            advice = "Sensitive groups should limit prolonged outdoor activity."
        case 101...150:
            title = "Unhealthy for Sensitive"
            color = UIColor.systemOrange
            shortDescription = "Members of sensitive groups may experience effects."
            advice = "Children, elderly and people with respiratory disease should reduce outdoor activities."
        case 151...200:
            title = "Unhealthy"
            color = UIColor.systemRed
            shortDescription = "Everyone may begin to experience effects."
            advice = "Limit outdoor activities; consider wearing a mask."
        default:
            title = "Very Unhealthy"
            color = UIColor.systemPurple
            shortDescription = "Health warnings of emergency conditions."
            advice = "Avoid outdoor activities as much as possible."
        }
    }
}
