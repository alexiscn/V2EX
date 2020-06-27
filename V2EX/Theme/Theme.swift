//
//  Theme.swift
//  V2EX
//
//  Created by xushuifeng on 2018/6/26.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import WXActionSheet

enum Theme: Int {
    case light = 0
    case dark = 1
    
    static var current: Theme = .light
    
    var statusBarStyle: UIStatusBarStyle {
        if #available(iOS 13, *) {
            return self == .light ? UIStatusBarStyle.darkContent: UIStatusBarStyle.lightContent
        } else {
            return self == .light ? UIStatusBarStyle.default : UIStatusBarStyle.lightContent
        }
    }
    
    var activityIndicatorViewStyle: UIActivityIndicatorView.Style {
        switch self {
        case .light:
            return .gray
        case .dark:
            return .white
        }
    }
    
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
            return UIColor(white: 248.0/255, alpha: 1.0)
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
            return UIColor(white: 222.0/255, alpha: 1.0)
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
    
    var navigationBarTextColor: UIColor {
        switch self {
        case .light:
            return .black
        case .dark:
            return .white
        }
    }
    
    var linkColor: UIColor {
        return UIColor(red: 20.0/255, green: 126.0/255, blue: 251.0/255, alpha: 1.0)
    }
    
    func webViewStyle() -> String {
        var style = loadStyle(name: "style")
        switch self {
        case .light:
            style += loadStyle(name: "light")
        case .dark:
            style += loadStyle(name: "dark")
        }
        return style
    }
    
    func loadStyle(name: String) -> String {
        if let path = Bundle.main.path(forResource: name, ofType: "css"),
            let style = try? String(contentsOf: URL(fileURLWithPath: path), encoding: .utf8) {
            return style
        }
        return ""
    }
}

class ThemeManager {
    
    static let shared = ThemeManager()
    
    private init() {
        configureWXActionSheet()
    }
    
    func switchTheme() {
        if Theme.current == .dark {
            Theme.current = .light
        } else {
            Theme.current = .dark
        }
        AppSettings.shared.theme = Theme.current.rawValue
        NotificationCenter.default.post(name: NSNotification.Name.V2.ThemeUpdated, object: nil)
        configureWXActionSheet()
    }
    
    private func configureWXActionSheet() {
        if Theme.current == .dark {
            WXActionSheet.Preferences.ButtonNormalBackgroundColor = UIColor(red: 118.0/255, green: 130.0/255, blue: 157.0/255, alpha: 1.0)
            WXActionSheet.Preferences.ButtonHighlightBackgroundColor = UIColor(red: 108.0/255, green: 118.0/255, blue: 149.0/255, alpha: 1.0)
            WXActionSheet.Preferences.SeparatorColor = Theme.current.cellBackgroundColor
            WXActionSheet.Preferences.ButtonTitleColor = .white
        } else {
            WXActionSheet.Preferences.ButtonNormalBackgroundColor = UIColor(white: 1, alpha: 0.8)
            WXActionSheet.Preferences.ButtonHighlightBackgroundColor = UIColor(white: 1, alpha: 0.5)
            WXActionSheet.Preferences.SeparatorColor = UIColor(white: 153.0/255, alpha: 1.0)
            WXActionSheet.Preferences.ButtonTitleColor = .black
        }
    }
    
    func observeThemeUpdated(closure: @escaping (Notification) -> Void) {
        let center = NotificationCenter.default
        center.addObserver(forName: NSNotification.Name.V2.ThemeUpdated, object: nil, queue: OperationQueue.main) { (notification) in
            closure(notification)
        }
    }
}
