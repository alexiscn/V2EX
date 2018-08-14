//
//  NodeListSectionHeaderView.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/8/14.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class NodeListSectionHeaderView: UICollectionReusableView {
    
    private let titleLabel: UILabel
    
    override init(frame: CGRect) {
        
        titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 15, y: 10, width: frame.width - 30, height: 20)
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = .black
        
        super.init(frame: frame)
        
        addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ title: String) {
        titleLabel.text = title
    }
}
