//
//  Reply.swift
//  V2EX
//
//  Created by alexiscn on 2018/11/17.
//  Copyright © 2018 alexiscn. All rights reserved.
//

import Foundation
import WCDBSwift

class Reply: TableCodable {
    
    enum CodingKeys: String, CodingTableKey {
        
        public typealias Root = Reply
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        case timeAgo = "time_ago"
        case content
        case contentHTML
        case floor
        case likesInfo
        case userLinkURL = "user_link_url"
        case username
        case avatarURL = "avatar_url"
    }
    
    var replyID: String? = nil
    
    var _rowHeight: CGFloat = 0
    
    var timeAgo: String? = nil
    
    var content: String? = nil
    
    var contentHTML: String? = nil
    
    var contentAttributedString: NSAttributedString? = nil
    
    // ♥ 8
    var likeCount: Int = 0
    
    var likesInfo: String? = nil
    
    var floor: String? = nil
    
    var userLinkURL: URL? = nil

    var username: String? = nil
    
    var avatarURL: URL? = nil
    
    var isTopicAuthor: Bool = false
    
    var mentions: [String] = []
    
    init() { }
}

struct CommentResponse {
    var success: Bool
    var problem: String?
}
