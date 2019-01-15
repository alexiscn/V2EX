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
    static var NoMoreData: String { return NSLocalizedString("NoMoreData", value: "No more data..", comment: "没有更多了") }
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
    
    static var LoginRequired: String { return NSLocalizedString("Login.Required", value: "Login required", comment: "请先登录") }
    static var LoginPrivacyPolity: String { return NSLocalizedString("Login.PrivacyPolicy", value: "Agreed user Privacy policy", comment: "已同意用户协议与隐私政策") }
}

// Search
extension Strings {
    static var SearchPlaceholder: String { return NSLocalizedString("Search.Placeholder", value: "Search topics", comment: "搜索主题") }
    static var SearchOptionsSumup: String { return NSLocalizedString("Search.OptionsSumup", value: "Sumup", comment: "权重") }
    static var SearchOptionCreatedTime: String { return NSLocalizedString("Search.OptionCreatedTime", value: "Time", comment: "时间") }
    static var SearchResultTips: String { return NSLocalizedString("Search.ResultTips", value: "Find %d results, took %d milliseconds", comment: "共计 %d 个结果，耗时 %d 毫秒") }
    static var SearchResultTopicInfo: String { return NSLocalizedString("Search.ResultTopicInfo", value: "Pub at %@ , %d comments", comment: "于 %@ 发表，共计 %d 个回复") }
}

// Topic Detail
extension Strings {
    static var DetailOriginPoster: String { return NSLocalizedString("Detail.OriginPoster", value: "Author", comment: "楼主") }
    static var DetailOpenInSafari: String { return NSLocalizedString("Detail.OpenInSafari", value: "Open In Safari", comment: "在Safari中打开") }
    static var DetailComment: String { return NSLocalizedString("Detail.Comment", value: "Comment", comment: "评论") }
    static var DetailCopyComments: String { return NSLocalizedString("Detail.CopyComments", value: "Copy", comment: "复制评论") }
    static var DetailViewAllComments: String { return NSLocalizedString("Detail.ViewAllComments", value: "View all comments", comment: "查看全部评论") }
    static var DetailViewAuthorOnly: String { return NSLocalizedString("Detail.ViewAuthorOnly", value: "View author only", comment: "只看楼主") }
    static var DetailViewConversation: String { return NSLocalizedString("Detail.ViewConversation", value: "View conversation", comment: "查看对话") }
    
    static var DetailCreateNewReply: String { return NSLocalizedString("Detail.CreateNewReply", value: "Add new comment", comment: "添加一条新回复") }
    static var DetailCommentSuccess: String { return NSLocalizedString("Detail.CommentSuccess", value: "Comment success", comment: "评论成功") }
    static var DetailAddToFavorites: String { return NSLocalizedString("Detail.AddToFavorites", value: "Add to favorites", comment: "收藏主题") }
    static var DetailFavoritedSuccess: String { return NSLocalizedString("Detail.FavoritedSuccess", value: "Added to favorites", comment: "收藏主题成功") }
    static var DetailRemoveFromFavorites: String { return NSLocalizedString("Detail.RemoveFromFavorites", value: "Remove from favorites", comment: "取消收藏") }
    static var DetailUnFavoritedSuccess: String { return NSLocalizedString("Detail.UnFavoritedSuccess", value: "Removed from favorites", comment: "取消收藏成功") }
}

// Topic
extension Strings {
    static var TopicCreateNewTopic: String { return NSLocalizedString("Topic.CreateNew", value: "Create Topic", comment: "创建新主题") }
    static var TopicTitlePlaceholder: String { return NSLocalizedString("Topic.TitlePlaceholder", value: "Topic title(0-120)", comment: "输入主题标题(0-120)") }
    
    static var TopicTitleTitle: String { return NSLocalizedString("Topic.TitleTitle", value: "Topic title", comment: "主题标题") }
    static var TopicTitleEmptyTips: String { return NSLocalizedString("Topic.TitleEmptyTips", value: "Please enter topic title", comment: "请输入主题标题") }
    
    static var TopicSelectNode: String { return NSLocalizedString("Topic.SelectNode", value: "Select Node", comment: "选择节点") }
    static var TopicNodeEmptyTips: String { return NSLocalizedString("Topic.NodeEmptyTips", value: "Please select topic node", comment: "请选择主题") }
    
    static var TopicBodyTitle: String { return NSLocalizedString("Topic.BodyTitle", value: "Content", comment: "正文") }
    static var TopicBodyPlaceholder: String { return NSLocalizedString("Topic.BodyPlaceholder", value: "Enter content. If title can describe what you want to say, content can be empty", comment: "请输入正文，如果标题能够表达完成内容，则正文可以为空") }
}

// Profile
extension Strings {
    static var ProfileHisTopics: String { return NSLocalizedString("Profile.HisTopics", value: "His topics", comment: "Ta创建的主题") }
    static var ProfileViewMore: String { return NSLocalizedString("Profile.ViewMore", value: "See all", comment: "查看更多") }
    static var ProfileMyTopics: String { return NSLocalizedString("Profile.MyTopics", value: "My topics", comment: "我创建主题") }
    static var ProfileHisComments: String { return NSLocalizedString("Profile.HisComments", value: "His comments", comment: "Ta的最近回复") }
    static var ProfileMyComments: String { return NSLocalizedString("Profile.MyComments", value: "My comments", comment: "我的最近回复") }
    static var ProfileFollow: String { return NSLocalizedString("Profile.Follow", value: "Follow", comment: "加入特别关注") }
    static var ProfileFollowSuccess: String { return NSLocalizedString("Profile.FollowSuccess", value: "Followed", comment: "已加入特别关注") }
    static var ProfileUnFollow: String { return NSLocalizedString("Profile.UnFollow", value: "UnFollow", comment: "取消关注") }
    static var ProfileUnFollowSuccess: String { return NSLocalizedString("Profile.UnFollowSuccess", value: "UnFollowed", comment: "已取消关注") }
    static var ProfileBlock: String { return NSLocalizedString("Profile.Block", value: "Block", comment: "拉黑") }
    static var ProfileBlockSuccess: String { return NSLocalizedString("Profile.BlockSuccess", value: "Blocked", comment: "已拉黑") }
    static var ProfileUnBlock: String { return NSLocalizedString("Profile.UnBlock", value: "UnBlock", comment: "取消拉黑") }
    static var ProfileUnBlockSuccess: String { return NSLocalizedString("Profile.UnBlockSuccess", value: "Removed from block list", comment: "已从黑名单移除") }
    static var ProfileBalance: String { return NSLocalizedString("Profile.Balance", value: "Balance", comment: "余额") }
    static var ProfileFavoritedNodes: String { return NSLocalizedString("Profile.FavoritedNodes", value: "Nodes" ,comment: "节点收藏") }
    static var ProfileFavoritedTopics: String { return NSLocalizedString("Profile.FavoritedTopics", value: "Topics" ,comment: "主题收藏") }
    static var ProfileMyFollowing: String { return NSLocalizedString("Profile.MyFollowing", value: "Following" ,comment: "特别关注") }
    static var ProfileMyBalanceCount: String { return NSLocalizedString("Profile.MyBalanaceCount", value: "Balance: %@", comment: "账户余额: %@") }
}

// Settings
extension Strings {
    static var Settings: String { return NSLocalizedString("Settings", comment: "设置") }
    static var SettingsAppLogo: String { return NSLocalizedString("Settings.AppLogo", value: "App Logo", comment: "应用图标") }
    static var SettingsViewOptions: String { return NSLocalizedString("Settings.ViewOptions", value: "View options", comment: "浏览偏好设置") }
    static var SettingsAutoRefresh: String { return NSLocalizedString("Settings.AutoRefresh", value: "Auto Refresh On Launch", comment: "自动刷新列表") }
    static var SettingsEnableFullGesture: String { return NSLocalizedString("Settings.EnableFullGesture", value: "Fullscreen gesture to back", comment: "全屏返回手势") }
    static var SettingsSourceCode: String { return NSLocalizedString("Settings.SourceCode", value: "Source code", comment: "项目源代码") }
    static var SettingsOpenSource: String { return NSLocalizedString("Settings.OpenSource", value: "Open Source Library", comment: "开源项目") }
    static var SettingsPrivacyPolicy: String { return NSLocalizedString("Settings.PrivacyPolicy", value: "Privacy policy", comment: "隐私政策") }
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
