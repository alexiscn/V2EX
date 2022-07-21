//
//  NotificationExtensions.swift
//  V2EX
//
//  Created by alexiscn on 2018/12/9.
//  Copyright © 2018 alexiscn. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    struct V2 {
        static let FullGestureEnableChanged = Notification.Name("me.shuifeng.v2ex.fullGestureChanged")
        static let ThemeUpdated = Notification.Name("me.shuifeng.v2ex.themeUpdated")
        static let LoginSuccess = Notification.Name("me.shuifeng.v2ex.loginSuccess")
        static let AccountUpdated = Notification.Name("me.shuifeng.v2ex.accountUpdated")
        static let DisplayAvatarChanged = Notification.Name("me.shuifeng.v2ex.displayAvatarChanged")
    }
    
}
