//
//  V2Model.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/6/22.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import SQLiteKit

public struct V2Tab {
    
    public let key: String
    
    public let title: String
    
    public var subTabs: [V2Tab] = []
    
    public init(key: String, title: String) {
        self.key = key
        self.title = title
        self.subTabs = []
    }
    
    public static var hotTab: V2Tab {
        return V2Tab(key: "hot", title: "最热")
    }
    
    public static var allTab: V2Tab {
        return V2Tab(key: "all", title: "全部")
    }
    
    public static func tabs() -> [V2Tab] {
        
        var techTab = V2Tab(key: "tech", title: "技术")
        techTab.subTabs.append(V2Tab(key: "programmer", title: "程序员"))
        techTab.subTabs.append(V2Tab(key: "python", title: "Python"))
        techTab.subTabs.append(V2Tab(key: "idev", title: "iDev"))
        techTab.subTabs.append(V2Tab(key: "android", title: "Android"))
        techTab.subTabs.append(V2Tab(key: "nodejs", title: "node.js"))
        techTab.subTabs.append(V2Tab(key: "linux", title: "Linux"))
        techTab.subTabs.append(V2Tab(key: "cloud", title: "云计算"))
        techTab.subTabs.append(V2Tab(key: "bb", title: "宽带症候群"))
        
        var creativeTab = V2Tab(key: "creative", title: "创意")
        creativeTab.subTabs.append(V2Tab(key: "create", title: "分享创造"))
        creativeTab.subTabs.append(V2Tab(key: "design", title: "设计"))
        creativeTab.subTabs.append(V2Tab(key: "ideas", title: "奇思妙想"))
        
        var playTab = V2Tab(key: "play", title: "好玩")
        playTab.subTabs.append(V2Tab(key: "share", title: "分享发现"))
        playTab.subTabs.append(V2Tab(key: "games", title: "电子游戏"))
        playTab.subTabs.append(V2Tab(key: "movie", title: "电影"))
        playTab.subTabs.append(V2Tab(key: "tv", title: "剧集"))
        playTab.subTabs.append(V2Tab(key: "music", title: "音乐"))
        playTab.subTabs.append(V2Tab(key: "travel", title: "旅游"))
        playTab.subTabs.append(V2Tab(key: "android", title: "Android"))
        playTab.subTabs.append(V2Tab(key: "watch", title: "午夜俱乐部"))
        
        var appleTab = V2Tab(key: "apple", title: "Apple")
        appleTab.subTabs.append(V2Tab(key: "macos", title: "macOS"))
        appleTab.subTabs.append(V2Tab(key: "iphone", title: "iPhone"))
        appleTab.subTabs.append(V2Tab(key: "ipad", title: "iPad"))
        appleTab.subTabs.append(V2Tab(key: "mbp", title: "MBP"))
        appleTab.subTabs.append(V2Tab(key: "imac", title: "iMac"))
        appleTab.subTabs.append(V2Tab(key: "afterdark", title: " WATCH "))
        appleTab.subTabs.append(V2Tab(key: "apple", title: "Apple"))
        
        var jobsTab = V2Tab(key: "jobs", title: "酷工作")
        jobsTab.subTabs.append(V2Tab(key: "jobs", title: "酷工作"))
        jobsTab.subTabs.append(V2Tab(key: "cv", title: "求职"))
        jobsTab.subTabs.append(V2Tab(key: "career", title: "职场话题"))
        jobsTab.subTabs.append(V2Tab(key: "outsourcing", title: "外包"))
        
        var dealsTab = V2Tab(key: "deals", title: "交易")
        dealsTab.subTabs.append(V2Tab(key: "all4all", title: "二手交易"))
        dealsTab.subTabs.append(V2Tab(key: "exchange", title: "物物交换"))
        dealsTab.subTabs.append(V2Tab(key: "free", title: "免费赠送"))
        dealsTab.subTabs.append(V2Tab(key: "dn", title: "域名"))
        dealsTab.subTabs.append(V2Tab(key: "tuan", title: "团购"))
        dealsTab.subTabs.append(V2Tab(key: "68631", title: "安全提示"))
        
        var cityTab = V2Tab(key: "city", title: "城市")
        cityTab.subTabs.append(V2Tab(key: "beijing", title: "北京"))
        cityTab.subTabs.append(V2Tab(key: "shanghai", title: "上海"))
        cityTab.subTabs.append(V2Tab(key: "shenzhen", title: "深圳"))
        cityTab.subTabs.append(V2Tab(key: "guangzhou", title: "广州"))
        cityTab.subTabs.append(V2Tab(key: "hangzhou", title: "杭州"))
        cityTab.subTabs.append(V2Tab(key: "chengdu", title: "成都"))
        cityTab.subTabs.append(V2Tab(key: "kunming", title: "昆明"))
        cityTab.subTabs.append(V2Tab(key: "nyc", title: "纽约"))
        cityTab.subTabs.append(V2Tab(key: "la", title: "洛杉矶"))
        
        let qnaTab = V2Tab(key: "qna", title: "问与答")
        let hotTab = V2Tab(key: "hot", title: "最热")
        
        var allTab = V2Tab(key: "all", title: "全部")
        allTab.subTabs.append(V2Tab(key: "share", title: "分享发现"))
        allTab.subTabs.append(V2Tab(key: "create", title: "分享创造"))
        allTab.subTabs.append(V2Tab(key: "qna", title: "问与答"))
        allTab.subTabs.append(V2Tab(key: "jobs", title: "酷工作"))
        allTab.subTabs.append(V2Tab(key: "programmer", title: "程序员"))
        allTab.subTabs.append(V2Tab(key: "career", title: "职场话题"))
        allTab.subTabs.append(V2Tab(key: "ideas", title: "奇思妙想"))
        allTab.subTabs.append(V2Tab(key: "deals", title: "优惠信息"))
        
        return [techTab, creativeTab, playTab, appleTab, jobsTab, dealsTab, cityTab, qnaTab, hotTab, allTab]
    }
}


public struct Topic: SQLiteCodable {
    
    public enum CodingKeys: String, SQLiteCodingKey {
        public typealias root = Topic
        case title
        case url
        case replies
        case username
        case avatar
        case lastReplyedUserName = "last_reply_username"
        case nodeName = "node_name"
        case nodeTitle = "node_title"
        case tab
    }
    
    public static func attributes() -> [AttributeInfo] {
        return []
    }
    
    // this property is not stored in database
    public var _rowHeight: CGFloat = 0
    
    public var title: String? = nil
    
    public var url: URL? = nil
    
    public var replies: Int = 0
    
    public var username: String? = nil
    
    public var avatar: URL? = nil
    
    public var lastReplyedUserName: String? = nil
    
    public var nodeName: String? = nil
    
    public var nodeTitle: String? = nil
    
    public var tab: String = ""
    
    public var lastUpdatedTime: String? = nil
    
    public init() {
        
    }
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
    
    public enum CodingKeys: String, SQLiteCodingKey {
        public typealias root = Reply
        case timeAgo = "time_ago"
        case content
        case floor
        case userLinkURL = "user_link_url"
        case username
        case avatarURL = "avatar_url"
    }
    
    public static func attributes() -> [AttributeInfo] {
        return []
    }
    
    public var _rowHeight: CGFloat = 0
    
    public var timeAgo: String?
    
    public var content: String?
    
    public var floor: String?
    
    public var userLinkURL: URL?
    
    public var username: String?
    
    public var avatarURL: URL?
    
    public init() {
        
    }
}

public struct V2Node {
    public let title: String
    public let url: URL?
}

public struct V2NodeGroup {
    public let title: String
    public let nodes: [V2Node]
}
