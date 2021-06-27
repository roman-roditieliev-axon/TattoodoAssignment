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

    func routeToDetails() {
        let detailsViewController = PostDetailViewController()
        sourceViewController?.navigationController?.pushViewController(detailsViewController, animated: false)
    }
}
