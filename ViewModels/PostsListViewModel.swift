//
//  PostsListViewModel.swift
//  TattoodoAssignment (iOS)
//
//  Created by User on 24.06.2021.
//

import Foundation

protocol PostsListPresenterProtocol: class {
    func getPosts()
    func getNumberOfPosts() -> Int
    func getPost(at indexPath: IndexPath) -> PostList
    func didScrollToBottom()
}

class PostsListViewModel: PostsListPresenterProtocol {
    
    private let networkManager: NetworkManager
    private var posts: [PostList] = []
    private var page = 1
    weak var delegate: MainViewUpdater?
    var isLoading = false {
        didSet {
            self.delegate?.updateActivityIndicator(isLoading: isLoading)
        }
    }

    // MARK: - Init
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    // MARK: - PostsListPresenterProtocol
    func getNumberOfPosts() -> Int {
        self.isLoading = false
        return self.posts.count
    }
    
    func getPost(at indexPath: IndexPath) -> PostList {
        return self.posts[indexPath.row]
    }
    
    func didScrollToBottom() {
        getPosts()
    }
    
    func getPosts() {
        if !isLoading {
            isLoading = true
            if self.posts.count == (self.page-1)*10  || self.page == 1 {
                let oldPosts = self.posts
                self.networkManager.getPosts(page: self.page) { [weak self] response in
                    switch response {
                    case.success(let data):
                        if let strPosts = data?.data {
                            self?.posts = oldPosts + strPosts
                            self?.isLoading = false
                            self?.page += 1
                            self?.delegate?.reload()
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
}
