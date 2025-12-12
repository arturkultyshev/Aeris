//
//  NewsResponse.swift
//  Aeris
//
//  Created by Zhumatay Sayana on 11.12.2025.
//

import Foundation

struct NewsResponse: Codable {
    let results: [NewsArticle]
}

struct NewsArticle: Codable {
    let title: String?
    let link: String?
    let pubDate: String?
    let description: String?
    let content: String?
    let image_url: String?
    let source_id: String?
}

