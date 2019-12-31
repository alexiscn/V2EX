//
//  SettingTableModel.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/11/22.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation

class SettingTableSectionModel {
    
    private(set) var title: String?
    
    private(set) var items: [SettingTableModel]
    
    init(title: String?, items: [SettingTableModel]) {
        self.title = title
        self.items = items
    }
}

enum SettingValue {
    case actionCommand(RelayCommand?)
    case switchButton(Bool, Int)
}

class SettingTableModel {
    
    var title: String
    
    var value: SettingValue
    
    init(title: String, value: SettingValue) {
        self.title = title
        self.value = value
    }
}
