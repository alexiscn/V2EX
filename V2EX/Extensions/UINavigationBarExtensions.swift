//
//  UINavigationBarExtensions.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/11/13.
//  Copyright © 2018 shuifeng.me. All rights reserved.
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

