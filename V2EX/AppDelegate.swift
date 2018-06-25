//
//  AppDelegate.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/6/22.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import V2SDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    fileprivate var sliderMenuController: SlideMenuController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        V2SDK.setup()
        
        let timelineViewController = TimelineViewController()
        let mainViewController = UINavigationController(rootViewController: timelineViewController)
        let leftMenuController = HomeMenuViewController()
        let rightMenuController = TabMenuViewController()
        rightMenuController.didSelectTabHandler = { menu in
            timelineViewController.switchTo(menu)
            self.sliderMenuController?.closeRight()
        }
        
        SlideMenuOptions.rightViewWidth = 150
        
        sliderMenuController = SlideMenuController(mainViewController: mainViewController, leftMenuViewController: leftMenuController, rightMenuViewController: rightMenuController)
        window?.rootViewController = sliderMenuController
        window?.makeKeyAndVisible()
    
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

