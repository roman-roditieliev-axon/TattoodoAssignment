//
//  AppDelegate.swift
//  TattoodoAssignment (iOS)
//
//  Created by User on 24.06.2021.
//

import UIKit

@UIApplicationMain
class AppDelegate: NSObject, UIApplicationDelegate {
    
    var window: UIWindow?
    var networkManager = NetworkManager()

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        networkManager.getPostById(postId: 447698) { (post, error) in
            print("success")
        }

        networkManager.getPosts(page: 1) { posts, error in
            print("success")
        }
        return true
    }
}
