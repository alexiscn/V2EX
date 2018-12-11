//
//  UIViewControllerExtensions.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/8/13.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var isXScreenLayout: Bool {
        return (UIScreen.main.bounds.width == 375 && UIScreen.main.bounds.height == 812)
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundColor(Theme.current.navigationBarBackgroundColor, textColor: Theme.current.navigationBarTextColor)
    }
    
}
