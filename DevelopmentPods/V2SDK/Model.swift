//
//  Model.swift
//  V2SDK
//
//  Created by xu.shuifeng on 2018/6/22.
//

import Foundation

public enum V2Tabs: String {
    case hot
    case all
    case apple
}

//public struct NodeResonse: Codable {
//    
//    public let id: Int
//    public let name: String
//    public let url: URL
//    public let title: String
//    public let title_alternative: String
//    public let topics: Int
//    public let stars: Int
//    public let header: String?
//    public let footer: String?
//    public let created: Int64
//    public let avatar_mini: String
//    public let avatar_normal: String
//    public let avatar_large: String
//    
//}


public struct Topic {
    
    public var id: Int?
    
    public var title: String?
    
    public var url: URL?
    
    public var content: String?
    
    public var replies: Int = 0
    
    public var member: Member?
    
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

public struct Reply {
    
    public var id: Int = 0
    
    public var thanks: Int = 0
    
    public var content: String?
    
    public var content_rendered: String
    
    public var member: Member?
}
