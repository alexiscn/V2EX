//
//  UIViewExtensions.swift
//  V2EX
//
//  Created by alexiscn on 2018/8/13.
//  Copyright © 2018 alexiscn. All rights reserved.
//

import UIKit

extension UIView {
    
    /// Used to layout
    var keyWindowSafeAreaInsets: UIEdgeInsets {
        return UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero
    }
}
