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
        containerView.backgroundColor = Theme.current.cellBackgroundColor
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = Theme.current.titleColor
        
        contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.systemFont(ofSize: 13)
        contentLabel.textColor = Theme.current.subTitleColor
        
        usernameButton = UIButton(type: .system)
        usernameButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
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
            make.bottom.equalToSuperview().offset(-0.5)
        }
        
        containerView.addSubview(usernameButton)
        containerView.addSubview(timeLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-12)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        
        usernameButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-5)
            make.top.equalTo(contentLabel.snp.bottom).offset(5)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(usernameButton)
            make.leading.equalTo(usernameButton.snp.trailing).offset(3)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ hit: SearchHit) {
        
        let source = hit.source
        
        titleLabel.text = source.title
        
        var content = source.content
        if content.count > 100 {
            content = content.subString(start: 0, length: 100).appending("......")
        }
        contentLabel.text = content
        usernameButton.setTitle(source.member, for: .normal)
        timeLabel.text = String(format: "于 %@ 发表，共计 %d 个回复", source.created, source.replies)
    }
}

