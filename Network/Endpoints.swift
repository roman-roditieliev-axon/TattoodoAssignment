//
//  Endpoints.swift
//  TattoodoAssignment (iOS)
//
//  Created by User on 24.06.2021.
//

import Foundation

enum PostsEndpoints: RequestType {
    case getPosts(page: Int)
    case getPostDetails(postId: Int)
}

extension PostsEndpoints {
    var api: String { "https://backend-api-sta.tattoodo.com/api/v2" }
    
    var baseURL: URL {
        guard let url = URL(string: api) else { fatalError("URL Error") }
        return url
    }
    
    var path: String {
        switch self {
        case .getPosts:
            return "/feeds"
        case .getPostDetails(let postId):
            return "/posts/\(postId)"
        }
    }
    
    var httpMethod: HTTPMethod { .get }
    
    var task: HTTPTask {
        switch self {
        case .getPostDetails: return .request
        case .getPosts(let page):
            return .requestWithParameters(bodyParameters: nil, bodyEncoding: ParameterEncoding.urlAndJsonEncoding, urlParameters: ["page": page])
        }
    }
}
