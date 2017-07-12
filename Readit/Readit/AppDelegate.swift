//
//  AppDelegate.swift
//  Readit
//
//  Created by kingcos on 08/07/2017.
//  Copyright © 2017 kingcos. All rights reserved.
//

import UIKit
import AVOSCloud

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setupLeanCloud()
        setupWindow()
        
        return true
    }
    
}

extension AppDelegate {
    func setupWindow() {
        
        window = UIWindow(frame: CGRect(x: 0.0, y: 0.0,
                                        width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        
        let tabBarController = UITabBarController()
        
        let rankController = UINavigationController(rootViewController: RankController())
        let searchController = UINavigationController(rootViewController: SearchController())
        let pushController = UINavigationController(rootViewController: PushController())
        let circleController = UINavigationController(rootViewController: CircleController())
        let moreController = UINavigationController(rootViewController: MoreController())
        
        tabBarController.viewControllers = [rankController, searchController, pushController, circleController, moreController]
        
        let rankTabBarItem = UITabBarItem(title: "排行榜", image: #imageLiteral(resourceName: "bio"), selectedImage: #imageLiteral(resourceName: "bio_red"))
        let searchTabBarItem = UITabBarItem(title: "发现", image: #imageLiteral(resourceName: "timer 2"), selectedImage: #imageLiteral(resourceName: "timer 2_red"))
        let pushTabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "pencil"), selectedImage: #imageLiteral(resourceName: "pencil_red"))
        let circleTabBarItem = UITabBarItem(title: "圈子", image: #imageLiteral(resourceName: "users two-2"), selectedImage: #imageLiteral(resourceName: "users two-2_red"))
        let moreTabBarItem = UITabBarItem(title: "更多", image: #imageLiteral(resourceName: "more"), selectedImage: #imageLiteral(resourceName: "more_red"))
        
        rankController.tabBarItem = rankTabBarItem
        searchController.tabBarItem = searchTabBarItem
        pushController.tabBarItem = pushTabBarItem
        circleController.tabBarItem = circleTabBarItem
        moreController.tabBarItem = moreTabBarItem
        
        rankController.tabBarController?.tabBar.tintColor = COLOR_MAIN_RED
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
    
    func setupLeanCloud() {
        AVOSCloud.setApplicationId("M4A5qpg7aploMttI5R1dYock-gzGzoHsz", clientKey: "1NovDStWvroPtwx4h1GqSLul")
    }
}
