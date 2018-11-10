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
            return .black
        case .dark:
            return UIColor(white: 240.0/255, alpha: 1.0)
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .light:
            return .white
        case .dark:
            return UIColor(white: 46.0/255, alpha: 1.0)
        }
    }
    
    var grayTextColor: UIColor {
        switch self {
        case .light:
            return UIColor(red: 153.0/255, green: 153.0/255, blue: 153.0/255, alpha: 1)
        case .dark:
            return UIColor(white: 210.0/255, alpha: 1.0)
        }
    }
    
    static let current: Theme = .dark
}

class ThemeManager {
    
    static let shared = ThemeManager()
    
    public class func setTheme(_ theme: Theme) {
        
    }
    
    func webViewStyle() -> String {
        if let path = Bundle.main.path(forResource: "style", ofType: "css"),
            let style = try? String(contentsOf: URL(fileURLWithPath: path), encoding: .utf8) {
            return style
        }
        return ""
    }
    
}
