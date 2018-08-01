//
//  Model.swift
//  V2SDK
//
//  Created by xu.shuifeng on 2018/6/22.
//

import Foundation
import SQLiteKit

public struct V2Tab {
    
    public let tab: String
    
    public let title: String
    
    public var subTabs: [V2Tab] = []
    
    public init(tab: String, title: String) {
        self.tab = tab
        self.title = title
        self.subTabs = []
    }
    
    public static func tabs() -> [V2Tab] {
        
        var techTab = V2Tab(tab: "tech", title: "技术")
        techTab.subTabs.append(V2Tab(tab: "programmer", title: "程序员"))
        techTab.subTabs.append(V2Tab(tab: "python", title: "Python"))
        techTab.subTabs.append(V2Tab(tab: "idev", title: "iDev"))
        techTab.subTabs.append(V2Tab(tab: "android", title: "Android"))
        techTab.subTabs.append(V2Tab(tab: "nodejs", title: "node.js"))
        techTab.subTabs.append(V2Tab(tab: "linux", title: "Linux"))
        techTab.subTabs.append(V2Tab(tab: "cloud", title: "云计算"))
        techTab.subTabs.append(V2Tab(tab: "bb", title: "宽带症候群"))
        
        var creativeTab = V2Tab(tab: "creative", title: "创意")
        creativeTab.subTabs.append(V2Tab(tab: "create", title: "分享创造"))
        creativeTab.subTabs.append(V2Tab(tab: "design", title: "设计"))
        creativeTab.subTabs.append(V2Tab(tab: "ideas", title: "奇思妙想"))

        var playTab = V2Tab(tab: "play", title: "好玩")
        playTab.subTabs.append(V2Tab(tab: "share", title: "分享发现"))
        playTab.subTabs.append(V2Tab(tab: "games", title: "电子游戏"))
        playTab.subTabs.append(V2Tab(tab: "movie", title: "电影"))
        playTab.subTabs.append(V2Tab(tab: "tv", title: "剧集"))
        playTab.subTabs.append(V2Tab(tab: "music", title: "音乐"))
        playTab.subTabs.append(V2Tab(tab: "travel", title: "旅游"))
        playTab.subTabs.append(V2Tab(tab: "android", title: "Android"))
        playTab.subTabs.append(V2Tab(tab: "watch", title: "午夜俱乐部"))
        
        var appleTab = V2Tab(tab: "apple", title: "Apple")
        appleTab.subTabs.append(V2Tab(tab: "macos", title: "macOS"))
        appleTab.subTabs.append(V2Tab(tab: "iphone", title: "iPhone"))
        appleTab.subTabs.append(V2Tab(tab: "ipad", title: "iPad"))
        appleTab.subTabs.append(V2Tab(tab: "mbp", title: "MBP"))
        appleTab.subTabs.append(V2Tab(tab: "imac", title: "iMac"))
        appleTab.subTabs.append(V2Tab(tab: "afterdark", title: " WATCH "))
        appleTab.subTabs.append(V2Tab(tab: "apple", title: "Apple"))
        
        var jobsTab = V2Tab(tab: "jobs", title: "酷工作")
        jobsTab.subTabs.append(V2Tab(tab: "jobs", title: "酷工作"))
        jobsTab.subTabs.append(V2Tab(tab: "cv", title: "求职"))
        jobsTab.subTabs.append(V2Tab(tab: "career", title: "职场话题"))
        jobsTab.subTabs.append(V2Tab(tab: "outsourcing", title: "外包"))
        
        var dealsTab = V2Tab(tab: "deals", title: "交易")
        dealsTab.subTabs.append(V2Tab(tab: "all4all", title: "二手交易"))
        dealsTab.subTabs.append(V2Tab(tab: "exchange", title: "物物交换"))
        dealsTab.subTabs.append(V2Tab(tab: "free", title: "免费赠送"))
        dealsTab.subTabs.append(V2Tab(tab: "dn", title: "域名"))
        dealsTab.subTabs.append(V2Tab(tab: "tuan", title: "团购"))
        dealsTab.subTabs.append(V2Tab(tab: "68631", title: "安全提示"))
        
        var cityTab = V2Tab(tab: "city", title: "城市")
        cityTab.subTabs.append(V2Tab(tab: "beijing", title: "北京"))
        cityTab.subTabs.append(V2Tab(tab: "shanghai", title: "上海"))
        cityTab.subTabs.append(V2Tab(tab: "shenzhen", title: "深圳"))
        cityTab.subTabs.append(V2Tab(tab: "guangzhou", title: "广州"))
        cityTab.subTabs.append(V2Tab(tab: "hangzhou", title: "杭州"))
        cityTab.subTabs.append(V2Tab(tab: "chengdu", title: "成都"))
        cityTab.subTabs.append(V2Tab(tab: "kunming", title: "昆明"))
        cityTab.subTabs.append(V2Tab(tab: "nyc", title: "纽约"))
        cityTab.subTabs.append(V2Tab(tab: "la", title: "洛杉矶"))
        
        let qnaTab = V2Tab(tab: "qna", title: "问与答")
        let hotTab = V2Tab(tab: "hot", title: "最热")
        
        var allTab = V2Tab(tab: "all", title: "全部")
        allTab.subTabs.append(V2Tab(tab: "share", title: "分享发现"))
        allTab.subTabs.append(V2Tab(tab: "create", title: "分享创造"))
        allTab.subTabs.append(V2Tab(tab: "qna", title: "问与答"))
        allTab.subTabs.append(V2Tab(tab: "jobs", title: "酷工作"))
        allTab.subTabs.append(V2Tab(tab: "programmer", title: "程序员"))
        allTab.subTabs.append(V2Tab(tab: "career", title: "职场话题"))
        allTab.subTabs.append(V2Tab(tab: "ideas", title: "奇思妙想"))
        allTab.subTabs.append(V2Tab(tab: "deals", title: "优惠信息"))
        
        return [techTab, creativeTab, playTab, appleTab, jobsTab, dealsTab, cityTab, qnaTab, hotTab, allTab]
    }
    
}


public struct Topic {
    
    public var _rowHeight: CGFloat = 0
    
    public var id: Int?
    
    public var title: String?
    
    public var url: URL?
    
    public var content: String?
    
    public var replies: Int = 0
    
    public var member: Member?
    
    public var lastReplyedUser: Member?
    
    public var node: Node?
    
    public var created: Int64?
    
    public var last_modified: Int64?
    
    init() {
        
    }
}

public struct Member {
    
    public var id: Int?
    
    public var username: String?
    
    public var avatar: URL?
    
    init() {
        
    }
}

public struct Node {
    
    public var id: Int = 0
    
    public var name: String?
    
    public var title: String?
    
    public var title_alternative: String?
    
    public var url: URL?
    
    public var topics: Int = 0
    
    init() {}
}

public struct TopicDetail {
    
    public var _rowHeight: CGFloat = 0
    
    public var title: String?
    
    public var author: String?
    
    public var authorAvatarURL: URL?
    
    public var contentHTML: String?
    
    public var small: String?
    
}

public struct Reply: SQLiteCodable {
    
    public static func attributes() -> [SQLiteAttribute] {
        return [
            SQLiteAttribute(name: "_rowHeight", attribute: .ignore)
        ]
    }
    
    enum CodingKeys: String, CodingKey {
        case thanks
        case timeAgo = "time_ago"
        case content
        case floor
        case userLinkURL = "user_link_url"
        case username
    }
    
    public var _rowHeight: CGFloat = 0
    
    public var thanks: Int = 0
    
    public var timeAgo: String?
    
    public var content: String?
    
    public var floor: String?
    
    public var userLinkURL: URL?
    
    public var username: String?
    
    public var avatarURL: URL?
    
    public init() {
        
    }
}
