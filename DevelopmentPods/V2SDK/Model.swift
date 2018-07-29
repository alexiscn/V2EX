//
//  Model.swift
//  V2SDK
//
//  Created by xu.shuifeng on 2018/6/22.
//

import Foundation

public enum V2Tabs: String {
    case tech
    case creative
    case play
    case apple
    case jobs
    case deals
    case city
    case qna
    case hot
    case all
    case r2
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

public struct Reply {
    
    public var _rowHeight: CGFloat = 0
    
    public var id: Int = 0
    
    public var thanks: Int = 0
    
    public var timeAgo: String?
    
    public var content: String?
    
    //public var member: Member?
    
    public var userLinkURL: URL?
    
    public var username: String?
    
    public var avatarURL: URL?
    
    init() {
        
    }
}
