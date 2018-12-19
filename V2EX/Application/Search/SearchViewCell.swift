//
//  SearchViewCell.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/12/19.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class SearchViewCell: UITableViewCell {
    
    private let containerView: UIView
    
    private let titleLabel: UILabel
    
    private let contentLabel: UILabel
    
    private let usernameButton: UIButton
    
    private let timeLabel: UILabel
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        containerView = UIView()
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = Theme.current.titleColor
        
        contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.systemFont(ofSize: 13)
        contentLabel.textColor = Theme.current.subTitleColor
        
        usernameButton = UIButton(type: .system)
        usernameButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        usernameButton.setTitleColor(Theme.current.titleColor, for: .normal)
        
        timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 11)
        timeLabel.textColor = Theme.current.subTitleColor
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(contentLabel)
        
        containerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        containerView.addSubview(usernameButton)
        containerView.addSubview(timeLabel)
        
        usernameButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(usernameButton)
            make.trailing.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ hit: SearchHit) {
        
        let source = hit.source
        
        titleLabel.text = source.title
        contentLabel.text = source.content
        usernameButton.setTitle(source.member, for: .normal)
    }
}
