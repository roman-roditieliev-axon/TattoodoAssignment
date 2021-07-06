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

    // MARK: - PostDetailPresenterProtocol

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
    
    func getPostsHandlePagination(id: Int) {
        if !isLoading && (self.relatedPosts.count == (self.page-1)*limit || self.page == 1) {
            isLoading = true
            let oldPosts = self.relatedPosts
            self.downloadRelatedPosts(id: id) { [weak self] data in
                self?.relatedPosts = oldPosts + data
                self?.isLoading = false
                self?.page += 1
                self?.delegate?.reload()
            }
        }
    }

    func downloadPost(id: Int) {
        networkManager.getPostById(postId: id) { [weak self] response in
            switch response {
            case.success(let data):
                if let post = data?.data {
                    self?.post = post
                    self?.delegate?.reload()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    private func downloadRelatedPosts(id: Int,completion: @escaping ([Post]) -> Void) {
        self.networkManager.getRelatedPosts(page: self.page, postId: id)  { (_ response: ResponseData<Post>) in
            switch response {
            case.success(let data):
                completion(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}
