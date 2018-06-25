//
//  Model.swift
//  V2SDK
//
//  Created by xu.shuifeng on 2018/6/22.
//

import Foundation

public typealias TopicList = [Topic]

public struct NodeResonse: Codable {
    
    public let id: Int
    public let name: String
    public let url: URL
    public let title: String
    public let title_alternative: String
    public let topics: Int
    public let stars: Int
    public let header: String?
    public let footer: String?
    public let created: Int64
    public let avatar_mini: String
    public let avatar_normal: String
    public let avatar_large: String
    
}


public struct Topic: Codable {
    
    public let id: Int
    
    public let title: String
    
    public let url: URL
    
    public let content: String
    
    public let replies: Int
    
    public let member: Member
    
    public let created: Int64
    
    public let last_modified: Int64
    
//    public let 
}

public struct Member: Codable {
    
    public let id: Int
    
    public let username: String
    
    public let avatar_mini: String
    
    public let avatar_normal: String
    
    public let avatar_large: String
}

public struct Node: Codable {
    
    public let id: Int
    
    public let name: String
    
    public let title: String
    
    public let title_alternative: String
    
    public let url: URL
    
    public let topics: Int
    
    public let avatar_mini: String
    
    public let avatar_normal: String
    
    public let avatar_large: String
}

public struct Reply: Codable {
    
    public let id: Int
    
    public let thanks: Int
    
    public let content: String
    
    public let content_rendered: String
    
    public let member: Member
    
    public let created: Int64
    
    public let last_modified: Int64
    
}
