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
    
    private let contentLabel: UILabel
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        avatarView = UIImageView()
        
        floorLabel = UILabel()
        floorLabel.font = UIFont.systemFont(ofSize: 12)
//        floorLabel.textColor =
        
        usernameButton = UIButton(type: .system)
        usernameButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        
        contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.systemFont(ofSize: 15)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(avatarView)
        contentView.addSubview(usernameButton)
        contentView.addSubview(floorLabel)
        
        avatarView.snp.makeConstraints { make in
            make.height.width.equalTo(48)
            make.leading.top.equalToSuperview().offset(12)
        }
        
        usernameButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(72)
            make.top.equalToSuperview().offset(12)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalTo(usernameButton)
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
        usernameButton.setTitle(reply.member?.username, for: .normal)
        avatarView.kf.setImage(with: reply.member?.avatar)
        contentLabel.text = reply.content
    }

    class func heightForRowWithReply(_ reply: inout Reply) -> CGFloat {
        
        if reply._rowHeight > 0 {
            return reply._rowHeight
        }
        let width = UIScreen.main.bounds.width - 84
        if let title = reply.content {
            let maxSize = CGSize(width: width, height: CGFloat.infinity)
            let rect = title.boundingRectWithSize(maxSize, attributes: [.font: UIFont.systemFont(ofSize: 15) as Any])
            let height = 10 + rect.height + 10 + 30
            reply._rowHeight = height
            return height
        }
        return 80
        
    }
}
