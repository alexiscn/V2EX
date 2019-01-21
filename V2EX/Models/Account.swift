//
//  Account.swift
//  V2EX
//
//  Created by xushuifeng on 2018/12/2.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import UIKit

struct Account {
    
    var username: String?
    
    var avatarURLString: String?
    
    var myNodes: String?
    
    var myTopics: String?
    
    var myFollowing: String?
    
    var balance: String?
    var golden: String?
    var silver: String?
    var bronze: String?
    
    var unread: Int = 0 
    
    init() { }
}


struct DailyMission {
    var message: String?
}

class Balance: DataType {
    
    var title: String?
    
    var total: String?
    
    var time: String?
    
    var desc: String?
    
    var value: String?
    
    init() {}
}

class MessageNotification: DataType {
    
    var _rowHeight: CGFloat = 0.0
    
    var username: String?
    
    var avatarURL: URL?
    
    var timeAgo: String?
    
    var comment: String?
    
    var title: String?
    
    var topicID: String?
    
    init() { }
}
