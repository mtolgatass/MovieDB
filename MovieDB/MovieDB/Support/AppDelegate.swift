//
//  AppDelegate.swift
//  MovieDB
//
//  Created by Tolga Taş on 19.12.2020.
//

import UIKit
import TMDBSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        TMDBConfig.apikey = "xxx"
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white
        let navigationController = UINavigationController()
        let pageViewController = PageViewController()
        navigationController.viewControllers = [pageViewController]
        self.window!.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

