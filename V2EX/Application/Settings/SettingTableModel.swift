//
//  SettingTableModel.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/11/22.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation

class SettingTableSectionModel {
    
    var title: String?
    
    var items: [SettingTableModel]
    
    init(title: String?, items: [SettingTableModel]) {
        self.title = title
        self.items = items
    }
}

class SettingTableModel {
    
    var title: String
    
    var action: RelayCommand?
    
    init(title: String, action: RelayCommand?) {
        self.title = title
        self.action = action
    }
}
