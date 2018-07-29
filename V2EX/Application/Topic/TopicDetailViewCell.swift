//
//  TopicDetailViewCell.swift
//  V2EX
//
//  Created by xushuifeng on 2018/7/29.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import SnapKit
import V2SDK

class TopicDetailViewCell: UITableViewCell {
 
    private let avatarView: UIImageView
    
    private let usernameButton: UIButton
    
    private let titleLabel: UILabel
    
    private let contentLabel: UILabel
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        avatarView = UIImageView()
        usernameButton = UIButton(type: .system)
        usernameButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        usernameButton.setTitleColor(UIColor(red: 108.0/255, green: 108.0/255, blue: 108.0/255, alpha: 1.0), for: .normal)
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        
        contentLabel = UILabel()
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.numberOfLines = 0
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(avatarView)
        contentView.addSubview(usernameButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        
        avatarView.snp.makeConstraints { make in
            make.height.width.equalTo(40)
            make.leading.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(12)
        }
        
        usernameButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(64)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.top.equalTo(avatarView.snp.bottom).offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(_ detail: TopicDetail) {
        avatarView.kf.setImage(with: detail.authorAvatarURL)
        usernameButton.setTitle(detail.author, for: .normal)
        titleLabel.text = detail.title
        contentLabel.text = detail.content
    }
    
    class func heightForRowWithDetail(_ detail: inout TopicDetail) -> CGFloat {
        
        if detail._rowHeight > 0 {
            return detail._rowHeight
        }
        var rowHeight: CGFloat = 64
     
        let width = UIScreen.main.bounds.width - 24
        if let title = detail.title {
            let maxSize = CGSize(width: width, height: CGFloat.infinity)
            let rect = title.boundingRectWithSize(maxSize, attributes: [.font: UIFont.systemFont(ofSize: 20) as Any])
            rowHeight += rect.height
        }
        
        rowHeight += 12
        
        if let content = detail.content {
            let maxSize = CGSize(width: width, height: CGFloat.infinity)
            let rect = content.boundingRectWithSize(maxSize, attributes: [.font: UIFont.systemFont(ofSize: 14) as Any])
            rowHeight += rect.height
        }
        rowHeight += 12
        
        detail._rowHeight = rowHeight
        return rowHeight
        
    }
}
