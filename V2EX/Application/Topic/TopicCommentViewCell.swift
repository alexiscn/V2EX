//
//  TopicCommentViewCell.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/6/26.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import SnapKit
import V2SDK
import Kingfisher

class TopicCommentViewCell: UITableViewCell {

    private let avatarView: UIImageView
    
    private let floorLabel: UILabel
    
    private let usernameButton: UIButton
    
    private let timeAgoLabel: UILabel
    
    private let contentLabel: UILabel
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        avatarView = UIImageView()
        
        floorLabel = UILabel()
        floorLabel.font = UIFont.systemFont(ofSize: 11)
//        floorLabel.textColor =
        
        usernameButton = UIButton(type: .system)
        usernameButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        usernameButton.setTitleColor(UIColor(red: 108.0/255, green: 108.0/255, blue: 108.0/255, alpha: 1.0), for: .normal)
        
        timeAgoLabel = UILabel()
        timeAgoLabel.font = UIFont.systemFont(ofSize: 11)
        timeAgoLabel.textColor = UIColor(red: 204.0/255, green: 204.0/255, blue: 204.0/255, alpha: 1)
        
        contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(avatarView)
        contentView.addSubview(usernameButton)
        contentView.addSubview(timeAgoLabel)
        contentView.addSubview(floorLabel)
        contentView.addSubview(contentLabel)
        
        avatarView.snp.makeConstraints { make in
            make.height.width.equalTo(42)
            make.leading.top.equalToSuperview().offset(12)
        }
        
        usernameButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(64)
            make.top.equalToSuperview().offset(12)
        }
        
        timeAgoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(usernameButton)
            make.leading.equalTo(usernameButton.snp.trailing).offset(5)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.leading.equalToSuperview().offset(64)
            make.top.equalTo(usernameButton.snp.bottom)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(_ reply: Reply) {
        usernameButton.setTitle(reply.username, for: .normal)
        avatarView.kf.setImage(with: reply.avatarURL)
        contentLabel.text = reply.content
        timeAgoLabel.text = reply.timeAgo
    }

    class func heightForRowWithReply(_ reply: inout Reply) -> CGFloat {
        
        if reply._rowHeight > 0 {
            return reply._rowHeight
        }
        let width = UIScreen.main.bounds.width - 78
        if let title = reply.content {
            let maxSize = CGSize(width: width, height: CGFloat.infinity)
            let rect = title.boundingRectWithSize(maxSize, attributes: [.font: UIFont.systemFont(ofSize: 14) as Any])
            let height = 12 + 29 + rect.height + 9 // 12: top, 29: button height, 9: bottom
            reply._rowHeight = height
            return height
        }
        return 80
        
    }
}
