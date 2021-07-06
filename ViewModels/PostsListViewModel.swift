//
//  PostsListViewModel.swift
//  TattoodoAssignment (iOS)
//
//  Created by User on 24.06.2021.
//

import Foundation

protocol PostsListPresenterProtocol: class {
    func getPostsHandlePagination()
    func getNumberOfPosts() -> Int
    func getPost(at indexPath: IndexPath) -> PostList
    func didScrollToBottom()
}

class PostsListViewModel: PostsListPresenterProtocol {
    
    private let networkManager: NetworkManager
    private var posts: [PostList] = []
    private var page = 1
    private let limit = 10
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
        getPostsHandlePagination()
    }
    
    func getPostsHandlePagination() {
        if !isLoading && (self.posts.count == (self.page-1)*limit || self.page == 1) {
            isLoading = true
            let oldPosts = self.posts
            self.downloadPosts { [weak self] data in
                self?.posts = oldPosts + data
                self?.isLoading = false
                self?.page += 1
                self?.delegate?.reload()
            }
        }
    }

    // MARK: - network requests

    private func downloadPosts(completion: @escaping ([PostList]) -> Void) {
        self.networkManager.getPosts(page: self.page) { (_ response: ResponseData<PostList>)  in
            switch response {
            case.success(let data):
                completion(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}
