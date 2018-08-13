//
//  UIViewExtensions.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/8/13.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

extension UIView {
    
    /// Used to layout
    var keyWindowSafeAreaInsets: UIEdgeInsets {
        return UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero
    }
}
