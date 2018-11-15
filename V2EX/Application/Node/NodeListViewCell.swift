//
//  NodeListViewCell.swift
//  V2EX
//
//  Created by xushuifeng on 2018/8/14.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class NodeListViewCell: UICollectionViewCell {
    
    let titleLabel: UILabel
    
    override init(frame: CGRect) {
        
        titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        
        super.init(frame: frame)
        
        contentView.addSubview(titleLabel)
        titleLabel.frame = contentView.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ node: V2Node) {
        titleLabel.text = node.title
    }
}
