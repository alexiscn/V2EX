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
    static let OK = NSLocalizedString("OK", comment: "确定")
    static let Cancel = NSLocalizedString("Cancel", comment: "取消")
    static let Done = NSLocalizedString("Done", comment: "完成")
    static let Share = NSLocalizedString("Share", comment: "分享")
    static let Report = NSLocalizedString("Report", comment: "举报")
    static let NoMoreData = NSLocalizedString("NoMoreData", value: "No more data..", comment: "")
    static let Notifications = NSLocalizedString("Notifications", comment: "通知")
    static let CopyLink = NSLocalizedString("CopyLink", value: "Copy link", comment: "复制链接")
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
    static let TabRecent = NSLocalizedString("Tab.Recent", value: "Recent", comment: "最近")
    
    static let RelatedNodes = NSLocalizedString("Nodes.Related", value: "Similar", comment: "相关节点")
    static let AllNodes = NSLocalizedString("Nodes.All", value: "All Nodes", comment: "所有节点")
    static let NodesNavigations = NSLocalizedString("Nodes.Navigations", value: "Navigations", comment: "节点导航")
    static let TabRecentTips = NSLocalizedString("Tab.RecentTips", value: "Only Recent can load more", comment: "只有最近才能加载更多")
}

// Login
extension Strings {
    static let LoginUsername = NSLocalizedString("Login.Username", value: "Username", comment: "用户名")
    static let LoginUsernamePlaceholder = NSLocalizedString("Login.UsernamePlaceholder", value: "Username or email", comment: "用户名或邮箱")
    static let LoginPassword = NSLocalizedString("Login.Password", value: "Password", comment: "密码")
    static let LoginPasswordPlaceholder = NSLocalizedString("Login.PasswordPlaceholder", value: "Password", comment: "密码")
    static let LoginButtonTitle = NSLocalizedString("Login.ButtonTitle", value: "Sign in...", comment: "登录...")
    static let SignInWithGoogle = NSLocalizedString("Login.SignInWithGoogle", value: "Sign in with Google", comment: "谷歌登录")
    
    static let LoginUsernameAlerts = NSLocalizedString("Login.UsernameAlerts", value: "Please enter correct username", comment: "请输入用户名")
    static let LoginPasswordAlerts = NSLocalizedString("Login.PasswordAlerts", value: "Please enter correct password...", comment: "请输入密码")
    static let LoginCaptchaAlerts = NSLocalizedString("Login.CaptchaAlerts", value: "Please enter correct captcha...", comment: "请输入验证码")
    static let LoginRefreshCaptchaAlerts = NSLocalizedString("Login.RefreshCaptchaAlerts", value: "Please refresh captcha...", comment: "请重新获取验证码")
    
    static let AccountNamePlaceholder = NSLocalizedString("Account.NamePlaceholder", value: "sign in...", comment: "请先登录")
}

// Topic Detail
extension Strings {
    static let DetailOriginPoster = NSLocalizedString("Detail.OriginPoster", value: "OP", comment: "楼主")
    static let DetailOpenInSafari = NSLocalizedString("Detail.OpenInSafari", value: "Open In Safari", comment: "在Safari中打开")
    static let DetailComment = NSLocalizedString("Detail.Comment", value: "Comment", comment: "评论")
    static let DetailCopyComments = NSLocalizedString("Detail.CopyComments", value: "Copy", comment: "复制评论")
    static let DetailViewAllComments = NSLocalizedString("Detail.ViewAllComments", value: "View all comments", comment: "查看全部评论")
    static let DetailViewAuthorOnly = NSLocalizedString("Detail.ViewAuthorOnly", value: "View author only", comment: "只看楼主")
}

// Profile
extension Strings {
    static let ProfileHisTopics = NSLocalizedString("Profile.HisTopics", value: "His topics", comment: "Ta创建的主题")
    static let ProfileHisComments = NSLocalizedString("Profile.HisComments", value: "His comments", comment: "Ta的最近回复")
    static let ProfileFollow = NSLocalizedString("Profile.Follow", value: "Follow", comment: "加入特别关注")
    static let ProfileBlock = NSLocalizedString("Profile.Block", value: "Block", comment: "拉黑")
}

// Settings
extension Strings {
    static let Settings = NSLocalizedString("Settings", comment: "设置")
    static let SettingsViewOptions = NSLocalizedString("Settings.ViewOptions", value: "View options", comment: "浏览偏好设置")
    static let SettingsAutoRefresh = NSLocalizedString("Settings.AutoRefresh", value: "Auto Refresh On Launch", comment: "自动刷新列表")
    static let SettingsEnableFullGesture = NSLocalizedString("Settings.EnableFullGesture", value: "Fullscreen gesture to back", comment: "全屏返回手势")
    static let SettingsOpenSource = NSLocalizedString("Settings.OpenSource", value: "Open Source", comment: "开源项目")
    static let SettingsAbout = NSLocalizedString("About", comment: "关于")
    static let SettingsReleaseNotes = NSLocalizedString("Settings.ReleaseNotes", value: "Release notes", comment: "更新记录")
    static let SettingsAccount = NSLocalizedString("Settings.Account", value: "Account", comment: "账号")
    static let SettingsLogout = NSLocalizedString("Logout", comment: "退出登录")
    static let SettingsLogoutPrompt = NSLocalizedString("Settings.LogoutPrompt", value: "Are you sure to logout ?", comment: "确定退出当前账号吗？")
}

// Networking
extension Strings {
    static let ServerNeedsSignIn = NSLocalizedString("Server.NeedsSignIn", value: "Sign in required...", comment: "需要登录后才能查看")
    static let ServerNeedsTwoFactor = NSLocalizedString("Server.NeedsTwoFactor", value: "You have enabled two factor authentication", comment: "开启了两步验证")
    static let ServerParseHTMLError = NSLocalizedString("Server.ParseHTMLError", value: "We have problem parsing HTML, please try it later", comment: "服务器解析错误")
    static let ServerSignInError = NSLocalizedString("Server.SignInError", value: "Sign in error", comment: "登录失败")
    static let ServerNotFound = NSLocalizedString("Server.NotFound", value: "Opps... 404 Not Found", comment: "服务器暂时开小差了，请稍后再试")
}
