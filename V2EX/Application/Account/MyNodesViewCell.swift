//
//  MyNodesViewCell.swift
//  V2EX
//
//  Created by xushuifeng on 2018/12/22.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class MyNodesViewCell: UITableViewCell, ListViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ model: DataType) {
        guard let myNode = model as? MyNode else { return }
    }
}
