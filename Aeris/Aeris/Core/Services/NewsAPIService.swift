//
//  NewsAPIService.swift
//  Aeris
//
//  Created by Zhumatay Sayana on 11.12.2025.
//

import Foundation

final class NewsAPIService {
    static let shared = NewsAPIService()
    
    private let baseURL = "https://newsdata.io/api/1/latest"
    private let apiKey = "pub_2a365b60aa8647f08c763c1649dabe63"
    
    func fetchNews(completion: @escaping (Result<[NewsArticle], Error>) -> Void) {

            var components = URLComponents(string: baseURL)
            components?.queryItems = [
                URLQueryItem(name: "apikey", value: apiKey),
                //URLQueryItem(name: "country", value: "kz"),
                URLQueryItem(name: "q", value: "air pollution"),
                URLQueryItem(name: "language", value: "en,ru,kz"),
            ]

            guard let url = components?.url else { return }

            URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data else { return }

                do {
                    let decoded = try JSONDecoder().decode(NewsResponse.self, from: data)
                    completion(.success(decoded.results))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    
}

