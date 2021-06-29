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
            self.isLoadingData(isLoading: isLoading)
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
                self.networkManager.getPosts(page: self.page) { (posts, error) in
                    if let strPosts = posts?.data {
                        self.posts = oldPosts + strPosts
                        self.isLoading = false
                        self.page += 1
                        self.delegate?.reload(indexPaths: self.indexToInsert(postsCount: strPosts.count))
                    }
                }
            }
        }
    }
    
    // MARK: - private funcs
    private func isLoadingData(isLoading: Bool) {
        self.delegate?.updateActivityIndicator(isLoading: isLoading)
    }
    
    private func indexToInsert(postsCount: Int) -> [IndexPath] {
        let oldPostsCount = self.getNumberOfPosts() - postsCount
        guard postsCount > 0 else { return [] }
        return (oldPostsCount..<(oldPostsCount + postsCount)).map { IndexPath(row: $0, section: 0) }
    }
}
