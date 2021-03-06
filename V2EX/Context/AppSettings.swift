//
//  AppSettings.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/11/19.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation

class AppSettings {

    fileprivate struct Keys {
        static let theme = "theme"
        static let displayAvatar = "displayAvatar"
        static let autoRefreshOnAppLaunch = "autoRefreshOnAppLaunch"
        static let enableFullScreenGesture = "enableFullScreenGesture"
        static let lastViewedTab = "lastViewedTab"
    }
    
    static var shared = AppSettings()

    var theme: Int {
        get { return UserDefaults.standard.value(forKey: Keys.theme) as? Int ?? 0 }
        set { UserDefaults.standard.set(newValue, forKey: Keys.theme) }
    }

    var displayAvatar: Bool {
        get { return UserDefaults.standard.value(forKey: Keys.displayAvatar) as? Bool ?? true }
        set { UserDefaults.standard.set(newValue, forKey: Keys.displayAvatar) }
    }

    var autoRefreshOnAppLaunch: Bool {
        get { return UserDefaults.standard.value(forKey: Keys.autoRefreshOnAppLaunch) as? Bool ?? true }
        set { UserDefaults.standard.set(newValue, forKey: Keys.autoRefreshOnAppLaunch) }
    }
    
    var enableFullScreenGesture: Bool {
        get { return UserDefaults.standard.value(forKey: Keys.enableFullScreenGesture) as? Bool ?? true }
        set { UserDefaults.standard.set(newValue, forKey: Keys.enableFullScreenGesture) }
    }

    var lastViewedTab: String? {
        get { return UserDefaults.standard.value(forKey: Keys.lastViewedTab) as? String }
        set { UserDefaults.standard.set(newValue, forKey: Keys.lastViewedTab) }
    }

    var lastViewedNode: String? = nil

    fileprivate init() {}
}
