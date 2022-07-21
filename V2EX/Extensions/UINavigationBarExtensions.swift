//
//  UINavigationBarExtensions.swift
//  V2EX
//
//  Created by alexiscn on 2018/11/13.
//  Copyright © 2018 alexiscn. All rights reserved.
//

import UIKit

extension UINavigationBar {
    
    func setBackgroundColor(_ backgroundColor: UIColor, textColor: UIColor) {
        self.isTranslucent = false
        self.backgroundColor = backgroundColor
        self.barTintColor = backgroundColor
        setBackgroundImage(UIImage(), for: .default)
        self.tintColor = textColor
        self.titleTextAttributes = [.foregroundColor: textColor]
    }
    
}


//extension UINavigationController {
//    open override var childForStatusBarStyle: UIViewController? {
//        return self.topViewController
//    }
//    
//    open override var childForStatusBarHidden: UIViewController? {
//        return self.topViewController
//    }
//}
