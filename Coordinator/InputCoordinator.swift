//
//  InputCoordinator.swift
//  TattoodoAssignment (iOS)
//
//  Created by User on 24.06.2021.
//

import UIKit

class InputCoordinator: Coordinator {
    
    private weak var sourceViewController: PostsListViewController?
    
    // MARK: - Init
    
    init(sourceViewController: PostsListViewController) {
        self.sourceViewController = sourceViewController
    }
    
    // MARK: - Route

    func routeToDetails(postId: Int) {
        let detailsViewController = PostDetailViewController()
        detailsViewController.postId = postId
        sourceViewController?.navigationController?.pushViewController(detailsViewController, animated: false)
    }
}
