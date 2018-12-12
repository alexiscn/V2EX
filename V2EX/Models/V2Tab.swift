//
//  V2Tab.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/11/17.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation

struct V2Tab: Equatable {
    
    let key: String
    
    let title: String
    
    var nodes: [Node] = []
    
    init(key: String, title: String) {
        self.key = key
        self.title = title
        self.nodes = []
    }
    
    static var hotTab: V2Tab {
        return V2Tab(key: "hot", title: Strings.TabHot)
    }
    
    static var recentTab: V2Tab {
        return V2Tab(key: "recent", title: Strings.TabRecent)
    }
    
    static func tabs() -> [V2Tab] {
        
        var techTab = V2Tab(key: "tech", title: NSLocalizedString("Tab.Technology", value: "Technology", comment: "技术"))
        techTab.nodes.append(Node(name: "programmer", title: "程序员", letter: ""))
        techTab.nodes.append(Node(name: "python", title: "Python员", letter: ""))
        techTab.nodes.append(Node(name: "idev", title: "iDev", letter: ""))
        techTab.nodes.append(Node(name: "android", title: "Android", letter: ""))
        techTab.nodes.append(Node(name: "nodejs", title: "node.js", letter: ""))
        techTab.nodes.append(Node(name: "linux", title: "Linux", letter: ""))
        techTab.nodes.append(Node(name: "cloud", title: "云计算", letter: ""))
        techTab.nodes.append(Node(name: "bb", title: "宽带症候群", letter: ""))
        
        var creativeTab = V2Tab(key: "creative", title: Strings.TabCreative)
        creativeTab.nodes.append(Node(name: "create", title: "分享创造", letter: ""))
        creativeTab.nodes.append(Node(name: "design", title: "设计", letter: ""))
        creativeTab.nodes.append(Node(name: "ideas", title: "奇思妙想", letter: ""))
        
        var playTab = V2Tab(key: "play", title: Strings.TabPlay)
        playTab.nodes.append(Node(name: "share", title: "分享发现", letter: ""))
        playTab.nodes.append(Node(name: "games", title: "电子游戏", letter: ""))
        playTab.nodes.append(Node(name: "movie", title: "电影", letter: ""))
        playTab.nodes.append(Node(name: "tv", title: "剧集", letter: ""))
        playTab.nodes.append(Node(name: "music", title: "音乐", letter: ""))
        playTab.nodes.append(Node(name: "travel", title: "旅游", letter: ""))
        playTab.nodes.append(Node(name: "android", title: "Android", letter: ""))
        playTab.nodes.append(Node(name: "afterdark", title: "午夜俱乐部", letter: ""))
        
        var appleTab = V2Tab(key: "apple", title: Strings.TabApple)
        appleTab.nodes.append(Node(name: "macos", title: "macOS", letter: ""))
        appleTab.nodes.append(Node(name: "iphone", title: "iPhone", letter: ""))
        appleTab.nodes.append(Node(name: "ipad", title: "iPad", letter: ""))
        appleTab.nodes.append(Node(name: "mbp", title: "MBP", letter: ""))
        appleTab.nodes.append(Node(name: "imac", title: "iMac", letter: ""))
        appleTab.nodes.append(Node(name: "watch", title: " WATCH", letter: ""))
        appleTab.nodes.append(Node(name: "apple", title: "Apple", letter: ""))
        
        var jobsTab = V2Tab(key: "jobs", title: Strings.TabJobs)
        jobsTab.nodes.append(Node(name: "jobs", title: "酷工作", letter: ""))
        jobsTab.nodes.append(Node(name: "cv", title: "求职", letter: ""))
        jobsTab.nodes.append(Node(name: "career", title: "职场话题", letter: ""))
        jobsTab.nodes.append(Node(name: "outsourcing", title: "外包", letter: ""))
        
        var dealsTab = V2Tab(key: "deals", title: Strings.TabDeals)
        dealsTab.nodes.append(Node(name: "all4all", title: "二手交易", letter: ""))
        dealsTab.nodes.append(Node(name: "exchange", title: "物物交换", letter: ""))
        dealsTab.nodes.append(Node(name: "free", title: "免费赠送", letter: ""))
        dealsTab.nodes.append(Node(name: "dn", title: "域名", letter: ""))
        dealsTab.nodes.append(Node(name: "tuan", title: "团购", letter: ""))
        
        var cityTab = V2Tab(key: "city", title: Strings.TabCity)
        cityTab.nodes.append(Node(name: "beijing", title: "北京", letter: ""))
        cityTab.nodes.append(Node(name: "shanghai", title: "上海", letter: ""))
        cityTab.nodes.append(Node(name: "shenzhen", title: "深圳", letter: ""))
        cityTab.nodes.append(Node(name: "guangzhou", title: "广州", letter: ""))
        cityTab.nodes.append(Node(name: "hangzhou", title: "杭州", letter: ""))
        cityTab.nodes.append(Node(name: "chengdu", title: "成都", letter: ""))
        cityTab.nodes.append(Node(name: "kunming", title: "昆明", letter: ""))
        cityTab.nodes.append(Node(name: "nyc", title: "纽约", letter: ""))
        cityTab.nodes.append(Node(name: "la", title: "洛杉矶", letter: ""))
        
        let qnaTab = V2Tab(key: "qna", title: Strings.TabQNA)
        let hotTab = V2Tab(key: "hot", title: Strings.TabHot)
        
        var allTab = V2Tab(key: "all", title: Strings.TabAll)
        allTab.nodes.append(Node(name: "share", title: "分享发现", letter: ""))
        allTab.nodes.append(Node(name: "create", title: "分享创造", letter: ""))
        allTab.nodes.append(Node(name: "qna", title: "问与答", letter: ""))
        allTab.nodes.append(Node(name: "jobs", title: "酷工作", letter: ""))
        allTab.nodes.append(Node(name: "programmer", title: "程序员", letter: ""))
        allTab.nodes.append(Node(name: "career", title: "职场话题", letter: ""))
        allTab.nodes.append(Node(name: "ideas", title: "奇思妙想", letter: ""))
        allTab.nodes.append(Node(name: "deals", title: "优惠信息", letter: ""))
        
        let recentTab = V2Tab(key: "recent", title: Strings.TabRecent)
        
        return [hotTab, allTab, recentTab, techTab, creativeTab, playTab, appleTab, jobsTab, dealsTab, cityTab, qnaTab]
    }
    
    public static func == (lhs: V2Tab, rhs: V2Tab) -> Bool {
        return lhs.key == rhs.key
    }
}
