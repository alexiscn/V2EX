//
//  Reply.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/11/17.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import WCDBSwift

struct Reply: TableCodable {
    
    enum CodingKeys: String, CodingTableKey {
        
        public typealias Root = Reply
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        case timeAgo = "time_ago"
        case content
        case floor
        case userLinkURL = "user_link_url"
        case username
        case avatarURL = "avatar_url"
    }
    
    
    var _rowHeight: CGFloat = 0
    
    var timeAgo: String? = nil
    
    var content: String? = nil
    
    var floor: String? = nil
    
    var userLinkURL: URL? = nil

    var username: String? = nil
    
    var avatarURL: URL? = nil
    
    init() {
        
    }
}