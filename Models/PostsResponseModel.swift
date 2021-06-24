//
//  PostsResponseModel.swift
//  TattoodoAssignment (iOS)
//
//  Created by User on 24.06.2021.
//

import Foundation

struct PostsResponse: Decodable {
    let data: [PostList]
    let meta: ResponseMetadata
}

struct ResponseMetadata: Decodable {
    let pagination: PaginationMeta
}

struct PaginationMeta: Decodable {
    let total: Int
    let count: Int
    let perPage: Int
    let currentPage: Int
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case perPage = "per_page"
        case currentPage = "current_page"
        case totalPages = "total_pages"
        case total
        case count
    }
}
