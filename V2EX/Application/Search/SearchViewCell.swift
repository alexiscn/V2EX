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
        usernameButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        usernameButton.setTitleColor(Theme.current.titleColor, for: .normal)
        
        timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 13)
        timeLabel.textColor = Theme.current.subTitleColor
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(contentLabel)
        containerView.addSubview(usernameButton)
        containerView.addSubview(timeLabel)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = Theme.current.cellHighlightColor
        selectedBackgroundView = backgroundView
        
        configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -0.5)
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12)
        ])
        
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            contentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5)
        ])
        
        usernameButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            usernameButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            usernameButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            usernameButton.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 5)
        ])
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeLabel.centerYAnchor.constraint(equalTo: usernameButton.centerYAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: usernameButton.trailingAnchor, constant: 3)
        ])
    }
    
    func update(_ hit: SearchHit) {
        
        let source = hit.source
        
        titleLabel.text = source.title
        var content = source.content.replacingOccurrences(of: "\r\n", with: "")
        if content.count > 100 {
            content = content.subString(start: 0, length: 100).appending("......")
        }
        contentLabel.text = content
        usernameButton.setTitle(source.member, for: .normal)
        timeLabel.text = String(format: Strings.SearchResultTopicInfo, source.created.replacingOccurrences(of: "T", with: " "), source.replies)
    }
}

