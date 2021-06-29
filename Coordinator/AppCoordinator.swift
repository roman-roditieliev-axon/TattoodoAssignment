//
//  AppCoordinator.swift
//  TattoodoAssignment (iOS)
//
//  Created by User on 24.06.2021.
//

import UIKit

class AppCoordinator: Coordinator {
        
    let window: UIWindow?
    lazy var rootViewController: PostsListViewController = {
        return PostsListViewController()
    }()
 
    // MARK: - Init
    
    init(window: UIWindow?) {
        self.window = window
    }

    // MARK: - Route

    override func start() {
        guard let window = window else { return }
        let rootNC = UINavigationController(rootViewController: rootViewController)
        window.rootViewController = rootNC
        window.makeKeyAndVisible()
    }

    override func finish() {

    }
}
