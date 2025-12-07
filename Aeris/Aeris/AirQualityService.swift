//
//  AirQualityService.swift
//  Aeris
//
//  Created by Артур Култышев on 07.12.2025.
//

import Foundation

/// Сервис для работы с API AirVisual
final class AirQualityService {

    static let shared = AirQualityService()

    /// ВСТАВЬ СВОЙ КЛЮЧ СЮДА
    private let apiKey: String = ProcessInfo.processInfo.environment["API_KEY"] ?? ""

    private init() {}

    struct AirVisualResponse: Decodable {
        struct Data: Decodable {
            struct Current: Decodable {
                struct Pollution: Decodable {
                    let aqius: Int   // US AQI
                }
                let pollution: Pollution
            }
            let current: Current
        }
        let data: Data
    }

    /// Загружаем данные по городу
    func fetchAirQuality(for city: City, completion: @escaping (Result<AirQualityData, Error>) -> Void) {
        var components = URLComponents(string: "https://api.airvisual.com/v2/city")!
        components.queryItems = [
            URLQueryItem(name: "city", value: city.apiCity),
            URLQueryItem(name: "state", value: city.state),
            URLQueryItem(name: "country", value: city.country),
            URLQueryItem(name: "key", value: apiKey)
        ]

        guard let url = components.url else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "Aeris", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode(AirVisualResponse.self, from: data)
                let aqi = decoded.data.current.pollution.aqius

                // Простая генерация “метрик” из AQI,
                // чтобы числа отличались (для учебного проекта ок).
                let pm25 = aqi
                let pm10 = Int(Double(aqi) * 1.2)
                let co2  = 400 + aqi * 2
                let o3   = 50 + aqi

                let result = AirQualityData(pm25: pm25, pm10: pm10, co2: co2, o3: o3)

                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }

        task.resume()
    }
}
