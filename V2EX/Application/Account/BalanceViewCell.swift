//
//  BalanceViewCell.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/12/12.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class BalanceViewCell: UITableViewCell {
    
    let titleLabel: UILabel
    
    let descLabel: UILabel
    
    let timeAgoLabel: UILabel
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        titleLabel = UILabel()
        titleLabel.textColor = Theme.current.titleColor
        
        descLabel = UILabel()
        descLabel.textColor = Theme.current.subTitleColor
        timeAgoLabel = UILabel()
        timeAgoLabel.textColor = Theme.current.subTitleColor
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(descLabel)
        contentView.addSubview(timeAgoLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ balance: Balance) {
        
    }
    
}
