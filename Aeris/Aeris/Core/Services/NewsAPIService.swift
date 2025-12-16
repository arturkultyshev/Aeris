//
//  NewsAPIService.swift
//  Aeris
//
//  Created by Zhumatay Sayana on 11.12.2025.
//

import Foundation

final class NewsAPIService {
    static let shared = NewsAPIService()
    
    private let baseURL = URL(string: "https://air-api-8lb9.onrender.com/news/air-pollution")!
    
    func fetchNews(limit: Int = 20,
                   completion: @escaping (Result<[NewsArticle], Error>) -> Void) {
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "limit", value: String(limit))
        ]
        
        guard let url = components.url else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(NewsResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(response.results))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
