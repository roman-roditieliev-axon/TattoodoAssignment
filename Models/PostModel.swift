//
//  PostsFeed.swift
//  TattoodoAssignment (iOS)
//
//  Created by User on 24.06.2021.
//

import Foundation

struct Post: Decodable {
    let id: Int
    let description: String
    let image: Image
}

struct Image: Decodable {
    let url: String
    let width: Int
    let height: Int
}

