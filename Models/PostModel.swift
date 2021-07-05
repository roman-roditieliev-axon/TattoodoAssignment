//
//  PostsFeed.swift
//  TattoodoAssignment (iOS)
//
//  Created by User on 24.06.2021.
//

import Foundation

struct PostList: Decodable, Equatable {
    let data: Post
    
    static func == (lhs: PostList, rhs: PostList) -> Bool {
        return true
    }
}

struct Post: Decodable, Equatable {
    let id: Int
    let description: String
    let image: Image
    
    static func == (lhs: Post, rhs: Post) -> Bool {
        return true
    }
}

struct Image: Decodable {
    let url: String
    let width: Int
    let height: Int
}

