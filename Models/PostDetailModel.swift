//
//  PostDetail.swift
//  TattoodoAssignment (iOS)
//
//  Created by User on 24.06.2021.
//

import Foundation

struct PostDetail: Decodable {
    let id: Int
    let artist: Artist
    let counts: Counts
}

struct Artist: Decodable {
    let id: Int
    let name: String
    let imageUrl: String
}

struct Counts: Decodable {
    let likes: Int
    let comments: Int
    let pins: Int
}
