//
//  CityStore.swift
//  Aeris
//
//  Created by Артур Култышев on 12.12.2025.
//

import Foundation

/// Уведомление, что данные по городам обновились
extension Notification.Name {
    static let cityStoreDidUpdate = Notification.Name("cityStoreDidUpdate")
}

/// Общий стор с городами и их метриками
final class CityStore {

    static let shared = CityStore()

    /// Все города приложения (один источник правды)
    var cities: [City] = [

        City(
            name: "AKTAU",
            state: "Mangystau Region",
            country: "Kazakhstan",
            imageName: "aktau",
            subtitle: "",
            latitude: 43.6481,
            longitude: 51.1722,
            airQuality: nil
        ),

        City(
            name: "ALMATY",
            state: "Almaty",
            country: "Kazakhstan",
            imageName: "almaty",
            subtitle: "",
            latitude: 43.2389,
            longitude: 76.8897,
            airQuality: nil
        ),

        City(
            name: "AQTOBE",
            state: "Aktobe Region",
            country: "Kazakhstan",
            imageName: "aqtobe",
            subtitle: "",
            latitude: 50.2839,
            longitude: 57.1669,
            airQuality: nil
        ),

        City(
            name: "ASTANA",
            state: "Astana",
            country: "Kazakhstan",
            imageName: "astana",
            subtitle: "",
            latitude: 51.1799,
            longitude: 71.4467,
            airQuality: nil
        ),

        City(
            name: "ATYRAU",
            state: "Atyrau Region",
            country: "Kazakhstan",
            imageName: "atyrau",
            subtitle: "",
            latitude: 47.0945,
            longitude: 51.9235,
            airQuality: nil
        ),

        City(
            name: "BALHASH",
            state: "Karaganda Region",
            country: "Kazakhstan",
            imageName: "balhash",
            subtitle: "",
            latitude: 46.8481,
            longitude: 74.9950,
            airQuality: nil
        ),

        City(
            name: "EKIBASTUZ",
            state: "Pavlodar Region",
            country: "Kazakhstan",
            imageName: "ekibastuz",
            subtitle: "",
            latitude: 51.6667,
            longitude: 75.3667,
            airQuality: nil
        ),

        City(
            name: "KARAGANDA",
            state: "Karaganda Region",
            country: "Kazakhstan",
            imageName: "karaganda",
            subtitle: "",
            latitude: 49.8060,
            longitude: 73.0860,
            airQuality: nil
        ),

        City(
            name: "KENTAU",
            state: "Turkistan Region",
            country: "Kazakhstan",
            imageName: "kentau",
            subtitle: "",
            latitude: 43.5167,
            longitude: 68.5167,
            airQuality: nil
        ),

        City(
            name: "KOKSHETAU",
            state: "Akmola Region",
            country: "Kazakhstan",
            imageName: "kokshetau",
            subtitle: "",
            latitude: 53.2833,
            longitude: 69.4000,
            airQuality: nil
        ),

        City(
            name: "KOSTANAY",
            state: "Kostanay Region",
            country: "Kazakhstan",
            imageName: "kostanay",
            subtitle: "",
            latitude: 53.2144,
            longitude: 63.6246,
            airQuality: nil
        ),

        City(
            name: "KYZYLORDA",
            state: "Kyzylorda Region",
            country: "Kazakhstan",
            imageName: "kyzylorda",
            subtitle: "",
            latitude: 44.8526,
            longitude: 65.5092,
            airQuality: nil
        ),

        City(
            name: "PAVLODAR",
            state: "Pavlodar Region",
            country: "Kazakhstan",
            imageName: "pavlodar",
            subtitle: "",
            latitude: 52.2833,
            longitude: 76.9500,
            airQuality: nil
        ),

        City(
            name: "PETROPAVLSK",
            state: "North Kazakhstan Region",
            country: "Kazakhstan",
            imageName: "petropavlsk",
            subtitle: "",
            latitude: 54.8667,
            longitude: 69.1500,
            airQuality: nil
        ),

        City(
            name: "QASKELEN",
            state: "Almaty Region",
            country: "Kazakhstan",
            imageName: "qaskelen",
            subtitle: "",
            latitude: 43.2000,
            longitude: 76.6000,
            airQuality: nil
        ),

        City(
            name: "RUDNYY",
            state: "Kostanay Region",
            country: "Kazakhstan",
            imageName: "rudnyy",
            subtitle: "",
            latitude: 52.9667,
            longitude: 63.1333,
            airQuality: nil
        ),

        City(
            name: "SEMEY",
            state: "Abay Region",
            country: "Kazakhstan",
            imageName: "semey",
            subtitle: "",
            latitude: 50.4233,
            longitude: 80.2508,
            airQuality: nil
        ),

        City(
            name: "SHYMKENT",
            state: "Shymkent",
            country: "Kazakhstan",
            imageName: "shymkent",
            subtitle: "",
            latitude: 42.3155,
            longitude: 69.5869,
            airQuality: nil
        ),

        City(
            name: "TALDYKORGAN",
            state: "Jetisu Region",
            country: "Kazakhstan",
            imageName: "taldykorgan",
            subtitle: "",
            latitude: 45.0167,
            longitude: 78.3667,
            airQuality: nil
        ),

        City(
            name: "TARAZ",
            state: "Jambyl Region",
            country: "Kazakhstan",
            imageName: "taraz",
            subtitle: "",
            latitude: 42.9000,
            longitude: 71.3667,
            airQuality: nil
        ),

        City(
            name: "TURKESTAN",
            state: "Turkistan Region",
            country: "Kazakhstan",
            imageName: "turkestan",
            subtitle: "",
            latitude: 43.2973,
            longitude: 68.2518,
            airQuality: nil
        ),

        City(
            name: "URALSK",
            state: "West Kazakhstan Region",
            country: "Kazakhstan",
            imageName: "uralsk",
            subtitle: "",
            latitude: 51.2333,
            longitude: 51.3667,
            airQuality: nil
        ),

        City(
            name: "UST-KAMENOGORSK",
            state: "East Kazakhstan Region",
            country: "Kazakhstan",
            imageName: "ustk-kamenogorks",
            subtitle: "",
            latitude: 49.9481,
            longitude: 82.6279,
            airQuality: nil
        ),

        City(
            name: "ZHANAOZEN",
            state: "Mangystau Region",
            country: "Kazakhstan",
            imageName: "zhanaozen",
            subtitle: "",
            latitude: 43.3410,
            longitude: 52.8613,
            airQuality: nil
        ),

        City(
            name: "ZHEZQAZGAN",
            state: "Ulytau Region",
            country: "Kazakhstan",
            imageName: "zhezqazgan",
            subtitle: "",
            latitude: 47.8040,
            longitude: 67.7140,
            airQuality: nil
        )
    ]

    private init() {}

    /// Загрузить/обновить метрики для всех городов.
    /// Благодаря кэшу в AirQualityService сетевые запросы будут только один раз.
    func refreshAll() {
        for (index, city) in cities.enumerated() {
            AirQualityService.shared.fetchAirQuality(for: city) { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .success(let data):
                    self.cities[index].airQuality = data

                    // сообщаем всем контроллерам, что данные обновились
                    NotificationCenter.default.post(
                        name: .cityStoreDidUpdate,
                        object: nil
                    )

                case .failure:
                    // в учебном проекте можно просто игнорировать
                    break
                }
            }
        }
    }
}
