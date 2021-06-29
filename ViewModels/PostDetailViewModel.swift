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
    func downloadRelatedPosts(id: Int)
    func didScrollToBottom(id: Int)
}

class PostDetailViewModel: PostDetailPresenterProtocol {

    // MARK: - Properties
    private let networkManager: NetworkManager
    weak var delegate: PostDetailViewUpdater?
    private var post: PostDetail?
    private var relatedPosts: [Post] = []
    private var page = 1
    
    private var isLoading: Bool = false {
        didSet {
            self.isLoadingData(isLoading: isLoading)
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
        downloadRelatedPosts(id: id)
    }
    
    func downloadPost(id: Int) {
        networkManager.getPostById(postId: id) { (result, error) in
            if let post = result?.data {
                self.post = post
                self.delegate?.showDetails(of: post)
            }
        }
    }
    
    func downloadRelatedPosts(id: Int) {
        if !isLoading {
            isLoading = true
            if self.relatedPosts.count == (self.page-1)*10  || self.page == 1 {
                let oldPosts = self.relatedPosts
                self.networkManager.getRelatedPosts(page: self.page, postId: id) { (posts, error) in
                    if let strPosts = posts?.data {
                        self.relatedPosts = oldPosts + strPosts
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
        let oldPostsCount = self.getNumberOfRelatedPosts() - postsCount
        guard postsCount > 0 else { return [] }
        return (oldPostsCount..<(oldPostsCount + postsCount)).map { IndexPath(row: $0, section: 0) }
    }

}