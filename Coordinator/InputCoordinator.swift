//
//  InputCoordinator.swift
//  TattoodoAssignment (iOS)
//
//  Created by User on 24.06.2021.
//

import UIKit

class InputCoordinator: Coordinator {
    
    private weak var sourceViewController: PostsListViewController?
    var postId: Int?
    
    // MARK: - Init
    
    init(sourceViewController: PostsListViewController) {
        self.sourceViewController = sourceViewController
    }
    
    // MARK: - Route

    override func start() {
        let detailsViewController = PostDetailViewController()
        if let postId = self.postId {
            detailsViewController.postId = postId
        }
        sourceViewController?.navigationController?.pushViewController(detailsViewController, animated: false)
    }
}
