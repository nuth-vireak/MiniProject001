//
//  Article.swift
//  MiniProject001
//
//  Created by KAK-REAK on 19/9/24.
//

import Foundation

struct Article: Identifiable, Codable {
    let id: Int // Ensure this property exists and is correctly typed
    let title: String
    let content: String
    let imageUrl: String
    let author: String
    let publishedDate: String
    let views: Int
    let isPublished: Bool
}


struct ApiResponse: Codable {
    let message: String
    let payload: [Article]
    let status: String
    let timestamp: String
}
