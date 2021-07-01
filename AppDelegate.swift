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
    var appCoordinator: MainCoordinator!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        appCoordinator = MainCoordinator()
        appCoordinator.start()
        return true
    }
}
