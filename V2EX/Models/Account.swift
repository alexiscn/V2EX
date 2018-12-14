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
    
}

struct DailyMission {
    var message: String?
}

struct Balance: DataType {
    
    var title: String?
    
    var total: String?
    
    var time: String?
    
    var desc: String?
    
    var value: String?
}

struct BalanceResponse {
    var page: Int = 0
    var balances: [Balance] = []
}

class NotificationResponse {
    var notifications: [MessageNotification] = []
    var page: Int = 1
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
