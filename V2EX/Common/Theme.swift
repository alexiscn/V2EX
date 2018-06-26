//
//  Theme.swift
//  V2EX
//
//  Created by xushuifeng on 2018/6/26.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

enum Theme {
    case light
    case dark
    
    var titleColor: UIColor {
        switch self {
        case .light:
            return .white
        case .dark:
            return .black
        }
    }
    
    var grayTextColor: UIColor {
        switch self {
        case .light:
            return UIColor(red: 153.0/255, green: 153.0/255, blue: 153.0/255, alpha: 1)
        case .dark:
            return .black
        }
    }
    
    static let current: Theme = .light
}

class ThemeManager {
    
    public class func setTheme(_ theme: Theme) {
        
    }
    
    
}
