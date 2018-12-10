//
//  Strings.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/12/10.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation

struct Strings { }

extension Strings {
    static let OK = NSLocalizedString("OK", comment: "OK Button")
    static let Cancel = NSLocalizedString("Cancel", comment: "Cancel Button")
    static let Done = NSLocalizedString("Done", comment: "Done Button")
    static let Report = NSLocalizedString("Report", comment: "Report Button")
}

// Tabs
extension Strings {
    static let TabTechnology = NSLocalizedString("Tab.Technology", value: "Technology", comment: "技术")
    static let TabCreative = NSLocalizedString("Tab.Creative", value: "Creative", comment: "创意")
    static let TabPlay = NSLocalizedString("Tab.Play", value: "Play", comment: "好玩")
    static let TabApple = NSLocalizedString("Tab.Apple", value: "Apple", comment: "Apple")
    static let TabJobs = NSLocalizedString("Tab.Jobs", value: "Jobs", comment: "酷工作")
    static let TabDeals = NSLocalizedString("Tab.Deals", value: "Deals", comment: "交易")
    static let TabCity = NSLocalizedString("Tab.City", value: "City", comment: "城市")
    static let TabQNA = NSLocalizedString("Tab.QNA", value: "Q & A", comment: "问与答")
    static let TabHot = NSLocalizedString("Tab.Hot", value: "Hot", comment: "最热")
    static let TabAll = NSLocalizedString("Tab.All", value: "All", comment: "全部")
    static let TabR2 = NSLocalizedString("Tab.R2", value: "R2", comment: "最近")
    static let TabRecent = NSLocalizedString("Tab.Recent", value: "Recent", comment: "最近")
}

// Login
extension Strings {
    static let LoginUsername = NSLocalizedString("Login.Username", value: "Username", comment: "")
    static let LoginUsernamePlaceholder = NSLocalizedString("Login.UsernamePlaceholder", value: "Username or email", comment: "")
    static let LoginPassword = NSLocalizedString("Login.Password", value: "Password", comment: "")
    static let LoginPasswordPlaceholder = NSLocalizedString("Login.PasswordPlaceholder", value: "Password", comment: "")
    static let Login = NSLocalizedString("Login.ButtonTitle", value: "Sign in", comment: "")
    static let SignInWithGoogle = NSLocalizedString("Login.SignInWithGoogle", value: "Sign in with Google", comment: "")
}

// Settings
extension Strings {
    static let SettinsAutoRefresh = NSLocalizedString("Settings.AutoRefresh", value: "Auto Refresh On Launch", comment: "")
    static let About = NSLocalizedString("About", comment: "About")
}

// Topic Detail
extension Strings {
    static let DetailOriginPoster = NSLocalizedString("Detail.OriginPoster", value: "OP", comment: "楼主")
    static let DetailOpenInSafari = NSLocalizedString("Detail.OpenInSafari", value: "Open In Safari", comment: "在Safari中打开")
    static let DetailCopyComments = NSLocalizedString("Detail.CopyComments", value: "Copy", comment: "复制评论")
}
