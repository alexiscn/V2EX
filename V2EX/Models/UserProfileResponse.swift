//
//  UserProfileResponse.swift
//  V2EX
//
//  Created by alexiscn on 2018/12/3.
//  Copyright © 2018 alexiscn. All rights reserved.
//

import Foundation
import UIKit

class UserInfo {
    
    var username: String?
    
    var avatarURL: URL?
    
    var createdInfo: String?
    
    var followURL: URL?
    var blockURL: URL?
    
    var hasFollowed: Bool = false
    var hasBlocked: Bool = false
    
    var website: String?
    var github: String?
    var psn: String?
    var bio: String?
    var twitter: String?
    var location: String?
    
    init() { }
}

struct UserProfileResponse {
    
    var info: UserInfo? = nil
    
    var topics: [Topic] = []
    
    var comments: [UserProfileComment] = []
    
    init() {
        
    }
}

class UserProfileComment: DataType {
    
    var _rowHeight: CGFloat = 0.0
    
    var username: String?
    
    var avatarURL: URL?
    
    var timeAgo: String?
    
    var originAuthor: String?
    
    var originNodename: String?
    
    var originNodeTitle: String?
    
    var originTopicTitle: String?
    
    var originTopicURL: URL?
    
    var commentContent: String?
    
    var commentContentHTML: String?
    
    init() {}
}
