//
//  AppDelegate.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/6/22.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import V2SDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var tabViewController: UITabBarController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        V2SDK.setup()
        
        tabViewController = UITabBarController()
        
        
        let timelineViewController = TimelineViewController(tab: .hotTab)
        timelineViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tabbar-home"), tag: 0)
        
        let searchViewController = UIViewController()
        searchViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tabbar-search"), tag: 1)
        
        let profileViewController = UIViewController()
        profileViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tabbar-profile"), tag: 2)
        
        tabViewController.viewControllers = [timelineViewController, searchViewController, profileViewController]
        
        window?.rootViewController = tabViewController
        
        tabViewController.tabBar.tintColor = UIColor(red: 47.0/255, green: 51.0/255, blue: 60.0/255, alpha: 1.0)
        tabViewController.tabBar.items?.forEach({ item in
            item.title = ""
            item.imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: -9, right: 0)
        })
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

