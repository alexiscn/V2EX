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
            return UIColor(red: 185.0/255, green: 200.0/255, blue: 243.0/255, alpha: 1.0)
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .light:
            return .white
        case .dark:
            return UIColor(red: 43.0/255, green: 57.0/255, blue: 83.0/255, alpha: 1.0)
        }
    }
    
    var subTitleColor: UIColor {
        switch self {
        case .light:
            return UIColor(red: 153.0/255, green: 153.0/255, blue: 153.0/255, alpha: 1)
        case .dark:
            return UIColor(red: 141.0/255, green: 155.0/255, blue: 193.0/255, alpha: 1)
        }
    }
    
    var cellHighlightColor: UIColor {
        switch self {
        case .light:
            return .white
        case .dark:
            return UIColor(red: 43.0/255, green: 57.0/255, blue: 83.0/255, alpha: 1.0)
        }
    }
    
    var cellBackgroundColor: UIColor {
        switch self {
        case .light:
            return .white
        case .dark:
            return UIColor(red: 52.0/255, green: 66.0/255, blue: 93.0/255, alpha: 1.0)
        }
    }
    
    var navigationBarBackgroundColor: UIColor {
        switch self {
        case .light:
            return UIColor(white: 248.0/255, alpha: 1.0)
        case .dark:
            return UIColor(red: 43.0/255, green: 57.0/255, blue: 83.0/255, alpha: 1.0)
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
