//
//  AppCoordinator.swift
//  TattoodoAssignment (iOS)
//
//  Created by User on 24.06.2021.
//

import UIKit

class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    let window: UIWindow?
    
    lazy var rootViewController: PostsListViewController = {
        return PostsListViewController()
    }()

    // MARK: - Coordinator
    init(window: UIWindow?) {
        self.window = window
    }

    override func start() {
        guard let window = window else { return }
        window.backgroundColor = .red
        let rootNC = UINavigationController(rootViewController: rootViewController)
        window.rootViewController = rootNC
        window.makeKeyAndVisible()
    }

    override func finish() {

    }
}
