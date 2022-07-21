//
//  UIViewControllerExtensions.swift
//  V2EX
//
//  Created by alexiscn on 2018/8/13.
//  Copyright © 2018 alexiscn. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func configureNavigationBar() {
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundColor(Theme.current.navigationBarBackgroundColor, textColor: Theme.current.navigationBarTextColor)
    }
    
}
