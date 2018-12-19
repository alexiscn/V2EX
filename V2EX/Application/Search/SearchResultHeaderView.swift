//
//  SearchResultHeaderView.swift
//  V2EX
//
//  Created by xushuifeng on 2018/12/19.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class SearchResultHeaderView: UIView {
    
    private let titleLabel: UILabel
    
    override init(frame: CGRect) {
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.textColor = Theme.current.titleColor
        
        super.init(frame: frame)
        
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateText(_ text: String) {
        titleLabel.text = text
    }
}
