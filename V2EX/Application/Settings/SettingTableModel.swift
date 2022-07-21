//
//  SettingTableModel.swift
//  V2EX
//
//  Created by alexiscn on 2018/11/22.
//  Copyright © 2018 alexiscn. All rights reserved.
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
