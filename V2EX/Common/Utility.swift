//
//  Utility.swift
//  V2EX
//
//  Created by alexiscn on 2018/11/19.
//  Copyright © 2018 alexiscn. All rights reserved.
//

import Foundation
import SafariServices

func presentSafariViewController(url: URL) {
    if url.absoluteString == "about:blank" {
        return
    }
    let controller = SFSafariViewController(url: url)
    controller.modalPresentationCapturesStatusBarAppearance = true
    controller.modalPresentationStyle = .overCurrentContext
    //UIApplication.shared.keyWindow?.rootViewController?.present(controller, animated: true, completion: nil)
    UIApplication.topViewController()?.present(controller, animated: true, completion: nil)
}

extension UIApplication {
    
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
}
