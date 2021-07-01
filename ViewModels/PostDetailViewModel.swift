//
//  PostDetailViewModel.swift
//  TattoodoAssignment (iOS)
//
//  Created by User on 27.06.2021.
//

import Foundation

protocol PostDetailPresenterProtocol: class {
    func downloadPost(id: Int)
    func getNumberOfPins() -> Int
    func getPost() -> PostDetail?
    func getPostsHandlePagination(id: Int)
    func didScrollToBottom(id: Int)
}

class PostDetailViewModel: PostDetailPresenterProtocol {

    // MARK: - Properties
    private let networkManager: NetworkManager
    weak var delegate: PostDetailViewUpdater?
    private var post: PostDetail?
    private var relatedPosts: [Post] = []
    private var page = 1
    private let limit = 40
    
    private var isLoading: Bool = false {
        didSet {
            self.delegate?.updateActivityIndicator(isLoading: isLoading)
        }
    }
    
    // MARK: - Methods
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func getNumberOfPins() -> Int {
        return self.post?.counts.pins ?? 0
    }
    
    func getNumberOfRelatedPosts() -> Int {
        return self.relatedPosts.count
    }
    
    func getPost() -> PostDetail? {
        return self.post
    }
    
    func getRelatedPosts() -> [Post] {
        return self.relatedPosts
    }
    
    func didScrollToBottom(id: Int) {
        getPostsHandlePagination(id: id)
    }
    
    func downloadPost(id: Int) {
        networkManager.getPostById(postId: id) { [weak self] response in
            switch response {
            case.success(let data):
                if let post = data?.data {
                    self?.post = post
                    self?.delegate?.showDetails(of: post)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getPostsHandlePagination(id: Int) {
        if !isLoading && (self.relatedPosts.count == (self.page-1)*limit || self.page == 1) {
            isLoading = true
            let oldPosts = self.relatedPosts
            self.downloadPosts(id: id) { [weak self] data in
                if let strPosts = data?.data {
                    self?.relatedPosts = oldPosts + strPosts
                    self?.isLoading = false
                    self?.page += 1
                    self?.delegate?.reload()
                }
            }
        }
    }
    
    private func downloadPosts(id: Int,completion: @escaping (RelatedPostsResponse?) -> Void) {
        self.networkManager.getRelatedPosts(page: self.page, postId: id)  { response in
            switch response {
            case.success(let data):
                completion(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}
