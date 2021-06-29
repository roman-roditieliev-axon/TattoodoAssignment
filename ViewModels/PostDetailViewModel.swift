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
}

class PostDetailViewModel: PostDetailPresenterProtocol {

    // MARK: - Properties
    private let networkManager: NetworkManager
    weak var delegate: PostDetailViewUpdater?
    private var post: PostDetail?

    
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
    
    func getPost() -> PostDetail? {
        return self.post
    }
    
    func downloadPost(id: Int) {
        isLoading = true
        networkManager.getPostById(postId: id) { (result, error) in
            self.isLoading = false
            if let post = result?.data {
                self.post = post
                self.delegate?.showDetails(of: post)
            }
        }
    }
    
    // MARK: - private funcs
    private func isLoadingData(isLoading: Bool) {
        self.delegate?.updateActivityIndicator(isLoading: isLoading)
    }
}
