//
//  PostDetailViewModel.swift
//  TattoodoAssignment (iOS)
//
//  Created by User on 27.06.2021.
//

import Foundation

protocol PostDetailPresenterProtocol: class {
    func getData()
}

class PostDetailViewModel: PostDetailPresenterProtocol {

    // MARK: - Properties
    private let networkManager: NetworkManager
    weak var delegate: PostDetailViewUpdater?
    
    private var isLoading: Bool = false {
        didSet {
            self.isLoadingData(isLoading: isLoading)
        }
    }
    
    // MARK: - Methods
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func getData() {
        isLoading = true
        networkManager.getPostById(postId: 0) { (result, error) in
            self.isLoading = false
        }
    }
    
    // MARK: - private funcs
    private func isLoadingData(isLoading: Bool) {
        self.delegate?.updateActivityIndicator(isLoading: isLoading)
    }
}
