//
//  ScrollTabBar.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/7/31.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

protocol ScrollTabBarDataSource: class {
    func numberOfSectionsInScrollTabBar(_ tabBar: ScrollTabBar) -> Int
}

class ScrollTabBar: UIView {
    
    weak var dataSource: ScrollTabBarDataSource?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ScrollTabBarItem: UIView {
    
    let titleLabel: UILabel
    
    override init(frame: CGRect) {
        
        titleLabel = UILabel()
        
        super.init(frame: frame)
        
        addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
