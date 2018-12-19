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
    static var OK: String { return NSLocalizedString("OK", comment: "确定") }
    static var Cancel: String { return NSLocalizedString("Cancel", comment: "取消") }
    static var Done: String { return NSLocalizedString("Done", comment: "完成") }
    static var Share: String { return NSLocalizedString("Share", comment: "分享") }
    static var Report: String { return NSLocalizedString("Report", comment: "举报") }
    static var NoMoreData: String { return NSLocalizedString("NoMoreData", value: "No more data..", comment: "") }
    static var Notifications: String { return NSLocalizedString("Notifications", comment: "通知") }
    static var CopyLink: String { return NSLocalizedString("CopyLink", value: "Copy link", comment: "复制链接") }
}

// Tabs
extension Strings {
    static var TabTechnology: String { return NSLocalizedString("Tab.Technology", value: "Technology", comment: "技术") }
    static var TabCreative: String { return NSLocalizedString("Tab.Creative", value: "Creative", comment: "创意") }
    static var TabPlay: String { return NSLocalizedString("Tab.Play", value: "Play", comment: "好玩") }
    static var TabApple: String { return NSLocalizedString("Tab.Apple", value: "Apple", comment: "Apple") }
    static var TabJobs: String { return NSLocalizedString("Tab.Jobs", value: "Jobs", comment: "酷工作") }
    static var TabDeals: String { return NSLocalizedString("Tab.Deals", value: "Deals", comment: "交易") }
    static var TabCity: String { return NSLocalizedString("Tab.City", value: "City", comment: "城市") }
    static var TabQNA: String { return NSLocalizedString("Tab.QNA", value: "Q & A", comment: "问与答") }
    static var TabHot: String { return NSLocalizedString("Tab.Hot", value: "Hot", comment: "最热") }
    static var TabAll: String { return NSLocalizedString("Tab.All", value: "All", comment: "全部") }
    static var TabRecent: String { return NSLocalizedString("Tab.Recent", value: "Recent", comment: "最近") }
    
    static var RelatedNodes: String { return NSLocalizedString("Nodes.Related", value: "Similar", comment: "相关节点") }
    static var AllNodes: String { return NSLocalizedString("Nodes.All", value: "All Nodes", comment: "所有节点") }
    static var NodesNavigations: String { return NSLocalizedString("Nodes.Navigations", value: "Navigations", comment: "节点导航") }
    static var TabRecentTips: String { return NSLocalizedString("Tab.RecentTips", value: "Only Recent can load more", comment: "只有最近才能加载更多") }
}

// Login
extension Strings {
    static var LoginUsername: String { return NSLocalizedString("Login.Username", value: "Username", comment: "用户名") }
    static var LoginUsernamePlaceholder: String { return NSLocalizedString("Login.UsernamePlaceholder", value: "Username or email", comment: "用户名或邮箱") }
    static var LoginPassword: String { return NSLocalizedString("Login.Password", value: "Password", comment: "密码") }
    static var LoginPasswordPlaceholder: String { return NSLocalizedString("Login.PasswordPlaceholder", value: "Password", comment: "密码") }
    static var LoginButtonTitle: String { return NSLocalizedString("Login.ButtonTitle", value: "Sign in...", comment: "登录...") }
    static var SignInWithGoogle: String { return NSLocalizedString("Login.SignInWithGoogle", value: "Sign in with Google", comment: "谷歌登录") }
    
    static var LoginUsernameAlerts: String { return NSLocalizedString("Login.UsernameAlerts", value: "Please enter correct username", comment: "请输入用户名") }
    static var LoginPasswordAlerts: String { return NSLocalizedString("Login.PasswordAlerts", value: "Please enter correct password...", comment: "请输入密码") }
    static var LoginCaptchaAlerts: String { return NSLocalizedString("Login.CaptchaAlerts", value: "Please enter correct captcha...", comment: "请输入验证码") }
    static var LoginRefreshCaptchaAlerts: String { return NSLocalizedString("Login.RefreshCaptchaAlerts", value: "Please refresh captcha...", comment: "请重新获取验证码") }
    
    static var AccountNamePlaceholder: String { return NSLocalizedString("Account.NamePlaceholder", value: "sign in...", comment: "请先登录") }
}

// Search
extension Strings {
    static var SearchPlaceholder: String { return NSLocalizedString("Search.Placeholder", value: "Search topics", comment: "搜索主题") }
}

// Topic Detail
extension Strings {
    static var DetailOriginPoster: String { return NSLocalizedString("Detail.OriginPoster", value: "Author", comment: "楼主") }
    static var DetailOpenInSafari: String { return NSLocalizedString("Detail.OpenInSafari", value: "Open In Safari", comment: "在Safari中打开") }
    static var DetailComment: String { return NSLocalizedString("Detail.Comment", value: "Comment", comment: "评论") }
    static var DetailCopyComments: String { return NSLocalizedString("Detail.CopyComments", value: "Copy", comment: "复制评论") }
    static var DetailViewAllComments: String { return NSLocalizedString("Detail.ViewAllComments", value: "View all comments", comment: "查看全部评论") }
    static var DetailViewAuthorOnly: String { return NSLocalizedString("Detail.ViewAuthorOnly", value: "View author only", comment: "只看楼主") }
    
    static var DetailCreateNewReply: String { return NSLocalizedString("Detail.CreateNewReply", value: "Add new comment", comment: "添加一条新回复") }
    static var DetailCommentSuccess: String { return NSLocalizedString("Detail.CommentSuccess", value: "Comment success", comment: "评论成功") }
}

// Profile
extension Strings {
    static var ProfileHisTopics: String { return NSLocalizedString("Profile.HisTopics", value: "His topics", comment: "Ta创建的主题") }
    static var ProfileHisComments: String { return NSLocalizedString("Profile.HisComments", value: "His comments", comment: "Ta的最近回复") }
    static var ProfileFollow: String { return NSLocalizedString("Profile.Follow", value: "Follow", comment: "加入特别关注") }
    static var ProfileBlock: String { return NSLocalizedString("Profile.Block", value: "Block", comment: "拉黑") }
}

// Settings
extension Strings {
    static var Settings: String { return NSLocalizedString("Settings", comment: "设置") }
    static var SettingsViewOptions: String { return NSLocalizedString("Settings.ViewOptions", value: "View options", comment: "浏览偏好设置") }
    static var SettingsAutoRefresh: String { return NSLocalizedString("Settings.AutoRefresh", value: "Auto Refresh On Launch", comment: "自动刷新列表") }
    static var SettingsEnableFullGesture: String { return NSLocalizedString("Settings.EnableFullGesture", value: "Fullscreen gesture to back", comment: "全屏返回手势") }
    static var SettingsSourceCode: String { return NSLocalizedString("Settings.SourceCode", value: "Source code", comment: "项目源代码") }
    static var SettingsOpenSource: String { return NSLocalizedString("Settings.OpenSource", value: "Open Source", comment: "开源项目") }
    static var SettingsAbout: String { return NSLocalizedString("About", comment: "关于") }
    static var SettingsReleaseNotes: String { return NSLocalizedString("Settings.ReleaseNotes", value: "Release notes", comment: "更新记录") }
    static var SettingsAccount: String { return NSLocalizedString("Settings.Account", value: "Account", comment: "账号") }
    static var SettingsLogout: String { return NSLocalizedString("Logout", comment: "退出登录") }
    
    static var SettingsLogoutPrompt: String {
        return NSLocalizedString("Settings.LogoutPrompt", value: "Are you sure to logout ?", comment: "确定退出当前账号吗？")
    }
    
    static var LangFollowSystem: String { return NSLocalizedString("Lang.FollowSystem", value: "Follow system", comment: "跟随系统") }
    
    static var SettingsLanguage: String { return NSLocalizedString("Settings.Language", value: "Language", comment: "语言") }
}

// Networking
extension Strings {
    static var ServerNeedsSignIn: String { return NSLocalizedString("Server.NeedsSignIn", value: "Sign in required...", comment: "需要登录后才能查看") }
    static var ServerNeedsTwoFactor: String { return NSLocalizedString("Server.NeedsTwoFactor", value: "You have enabled two factor authentication", comment: "开启了两步验证") }
    static var ServerParseHTMLError: String { return NSLocalizedString("Server.ParseHTMLError", value: "We have problem parsing HTML, please try it later", comment: "服务器解析错误") }
    static var ServerSignInError: String { return NSLocalizedString("Server.SignInError", value: "Sign in error", comment: "登录失败") }
    static var ServerNotFound: String { return NSLocalizedString("Server.NotFound", value: "Opps... 404 Not Found", comment: "服务器暂时开小差了，请稍后再试") }
}
