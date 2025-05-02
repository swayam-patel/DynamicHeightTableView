//
//  AppDelegate.swift
//  DynamicHeightTableView
//
//  Created by Swayam Patel on 12/04/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let navController = UINavigationController(rootViewController: ViewController())
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        return true
    }
}

