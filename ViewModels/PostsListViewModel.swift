//
//  PostsListViewModel.swift
//  TattoodoAssignment (iOS)
//
//  Created by User on 24.06.2021.
//

import Foundation

struct PostsListViewModel {
    private let post: Post
    
    let imageUrl: URL?
    
    let artistName: String
        
    let description: String?
    
    // MARK: - Init
    
    init(post: Post) {
        self.post = post
        
        artistName = ""
        description = post.description
        
        if let imageUrl = URL(string:post.image.url) {
            self.imageUrl = imageUrl
        } else {
            self.imageUrl = nil
        }
    }
}
