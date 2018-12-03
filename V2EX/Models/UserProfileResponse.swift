//
//  UserProfileResponse.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/12/3.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import UIKit

struct UserInfo {
    
    var username: String?
    
    var avatarURL: URL?
    
    var createdInfo: String?

}

struct UserProfileResponse {
    
    var info: UserInfo? = nil
    
    var topics: [Topic] = []
    
    var comments: [UserProfileComment] = []
    
    init() {
        
    }
}

struct UserProfileComment {
    
    var _rowHeight: CGFloat = 0.0
    
    var timeAgo: String?
    
    var title: String?
    
    var topicURL: URL?
    
    var conent: String?
    
    var conentHTML: String?
    
    init() {}
}
