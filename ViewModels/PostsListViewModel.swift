//
//  PostsListViewModel.swift
//  TattoodoAssignment (iOS)
//
//  Created by User on 24.06.2021.
//

import Foundation

protocol PostsListPresenterProtocol: class {
    func getPosts()
    func numberOfPosts() -> Int
    func post(at indexPath: IndexPath) -> PostList
}

class PostsListViewModel:  PostsListPresenterProtocol {
 
    
    private let networkManager: NetworkManager
    private var posts: [PostList] = []
    weak var delegate: MainViewUpdater?

    // MARK: - Init
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func numberOfPosts() -> Int {
        return self.posts.count
    }
    
    func post(at indexPath: IndexPath) -> PostList {
        return self.posts[indexPath.row]
    }
    
    func getPosts() {
        self.networkManager.getPosts(page: 1) { (posts, error) in
            if let strPosts = posts?.data {
                self.posts = strPosts
                self.delegate?.reload()
            }
        }
    }
}
