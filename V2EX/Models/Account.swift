//
//  Account.swift
//  V2EX
//
//  Created by xushuifeng on 2018/12/2.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation

struct Account {
    
    var username: String?
    
    var avatarURLString: String?
    
}

struct DailyMission {
    var message: String?
}

struct Balance {
    
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
