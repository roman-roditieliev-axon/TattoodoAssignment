//
//  PostsResponseModel.swift
//  TattoodoAssignment (iOS)
//
//  Created by User on 24.06.2021.
//

import Foundation

struct PostsResponse: Decodable {
    var data: [Post]
}
