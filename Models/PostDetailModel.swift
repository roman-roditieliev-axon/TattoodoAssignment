//
//  PostDetail.swift
//  TattoodoAssignment (iOS)
//
//  Created by User on 24.06.2021.
//

import Foundation

struct PostDetailData: Decodable {
    let data: PostDetail
}

struct PostDetail: Decodable {
    let id: Int
    let description: String
    let artist: Artist
    let counts: Counts
    let image: Image
    let shareUrl: String
    
    private enum CodingKeys : String, CodingKey {
        case shareUrl = "share_url", description, id, artist, counts, image
    }
}

struct Artist: Decodable {
    let id: Int
    let name: String
    let imageUrl: String

    private enum CodingKeys : String, CodingKey {
        case imageUrl = "image_url", name, id
    }
}

struct Counts: Decodable {
    let likes: Int
    let comments: Int
    let pins: Int
}
