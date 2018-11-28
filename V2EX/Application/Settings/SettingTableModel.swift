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

enum SettingType {
    case actionCommand(RelayCommand?)
    case switchButton(Bool)
}

class SettingTableModel {
    
    var title: String
    
    var type: SettingType
    
    init(title: String, type: SettingType) {
        self.title = title
        self.type = type
    }
}
