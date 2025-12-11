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
        let urlString = "\(baseURL)?apikey=\(apiKey)&q=air&language=en&category=environment"

        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: -1)))
                return
            }
            do {
                let decoded = try JSONDecoder().decode(NewsResponse.self, from: data)
                completion(.success(decoded.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
}

