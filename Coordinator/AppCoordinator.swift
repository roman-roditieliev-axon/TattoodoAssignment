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
    
    lazy var rootViewController: UINavigationController = {
        return UINavigationController(rootViewController: UIViewController())
    }()


    // MARK: - Coordinator
    init(window: UIWindow?) {
        self.window = window
    }

    override func start() {
        guard let window = window else {
            return
        }

        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }

    override func finish() {

    }

}
