//
//  AirQualityService.swift
//  Aeris
//
//  Created by Артур Култышев on 07.12.2025.
//

import Foundation

final class AirQualityService {
    
    static let shared = AirQualityService()
    
    /// Ключ берём из схемы / .env
    private let apiKey: String = ProcessInfo.processInfo.environment["API_KEY"] ?? ""
    
    /// Кэш: ключ -> данные по качеству воздуха
    private var cache: [String: AirQualityData] = [:]
    
    private init() {}
    
    // MARK: - Вспомогательное: ключ кэша
    
    /// Используем координаты, чтобы не зависеть от названия города
    private func cacheKey(for city: City) -> String {
        return "\(city.latitude)_\(city.longitude)"
    }
    
    // MARK: - Модели под OpenWeather
    
    private struct OpenWeatherResponse: Decodable {
        struct Item: Decodable {
            struct Main: Decodable {
                let aqi: Int
            }
            struct Components: Decodable {
                let pm2_5: Double
                let pm10: Double
                let co: Double
                let o3: Double
            }
            let main: Main
            let components: Components
        }
        let list: [Item]
    }
    
    // MARK: - Публичный метод
    
    func fetchAirQuality(for city: City,
                         completion: @escaping (Result<AirQualityData, Error>) -> Void) {
        // 1. Проверяем кэш
        let key = cacheKey(for: city)
        if let cached = cache[key] {
            DispatchQueue.main.async {
                completion(.success(cached))
            }
            return
        }
        
        // 2. Если в кэше нет — идём в сеть (OpenWeather)
        guard !apiKey.isEmpty else {
            DispatchQueue.main.async {
                let err = NSError(
                    domain: "Aeris",
                    code: -999,
                    userInfo: [NSLocalizedDescriptionKey: "API_KEY is missing"]
                )
                completion(.failure(err))
            }
            return
        }
        
        var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/air_pollution")!
        components.queryItems = [
            URLQueryItem(name: "lat", value: String(city.latitude)),
            URLQueryItem(name: "lon", value: String(city.longitude)),
            URLQueryItem(name: "appid", value: apiKey)
        ]
        
        guard let url = components.url else {
            DispatchQueue.main.async {
                let err = NSError(
                    domain: "Aeris",
                    code: -2,
                    userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]
                )
                completion(.failure(err))
            }
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(
                        NSError(
                            domain: "Aeris",
                            code: -1,
                            userInfo: [NSLocalizedDescriptionKey: "No data"]
                        )
                    ))
                }
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(OpenWeatherResponse.self, from: data)
                guard let first = decoded.list.first else {
                    DispatchQueue.main.async {
                        completion(.failure(
                            NSError(
                                domain: "Aeris",
                                code: -3,
                                userInfo: [NSLocalizedDescriptionKey: "Empty response"]
                            )
                        ))
                    }
                    return
                }
                
                // Конвертация в нашу модель
                let pm25 = Int(first.components.pm2_5.rounded())
                let pm10 = Int(first.components.pm10.rounded())
                let co   = Int(first.components.co.rounded())   // используем как "CO2"
                let o3   = Int(first.components.o3.rounded())
                
                let result = AirQualityData(pm25: pm25, pm10: pm10, co2: co, o3: o3)
                
                // 3. Сохраняем в кэш
                self.cache[key] = result
                
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
