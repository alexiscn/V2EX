//
//  NotificationViewCell.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/12/11.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class NotificationViewCell: UITableViewCell, UITextViewDelegate, ListViewCell {
    
    private let avatarImageView: UIImageView
    private let usernameLabel: UILabel
    private let timeAgoLabel: UILabel
    private let commentTextView: UITextView
    private let topicButton: UIButton
    private var topicTitle: String?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        avatarImageView = UIImageView()
        avatarImageView.layer.cornerRadius = 10.0
        avatarImageView.clipsToBounds = true
        
        usernameLabel = UILabel()
        usernameLabel.textColor = Theme.current.titleColor
        
        timeAgoLabel = UILabel()
        timeAgoLabel.font = UIFont.systemFont(ofSize: 11)
        timeAgoLabel.textColor = Theme.current.subTitleColor
        
        commentTextView = UITextView()
        commentTextView.textContainerInset = UIEdgeInsets(top: -2, left: -5, bottom: 0, right: 0)
        commentTextView.backgroundColor = .clear
        commentTextView.dataDetectorTypes = .link
        commentTextView.isEditable = false
        commentTextView.isSelectable = true
        commentTextView.isScrollEnabled = false
        commentTextView.font = UIFont.systemFont(ofSize: 14)
        commentTextView.textColor = Theme.current.titleColor
        
        topicButton = UIButton(type: .system)
        topicButton.contentHorizontalAlignment = .left
        topicButton.titleLabel?.numberOfLines = 0
        topicButton.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        topicButton.setTitleColor(Theme.current.subTitleColor, for: .normal)
        topicButton.backgroundColor = Theme.current.cellHighlightColor
        topicButton.layer.cornerRadius = 6.0
        topicButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(timeAgoLabel)
        contentView.addSubview(commentTextView)
        contentView.addSubview(topicButton)
        
        commentTextView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.top.equalToSuperview().offset(56)
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.height.width.equalTo(32)
            make.leading.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(12)
        }
        
        let usernameLeading: CGFloat = AppSettings.shared.displayAvatar ? 54.0: 10.0
        usernameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(usernameLeading)
            make.top.equalToSuperview().offset(12)
        }
        
        timeAgoLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(usernameLeading)
            make.top.equalTo(usernameLabel.snp.bottom).offset(3)
        }
    
        let backgroundView = UIView()
        backgroundView.backgroundColor = Theme.current.cellHighlightColor
        selectedBackgroundView = backgroundView
        
        commentTextView.delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let title = topicTitle {
            let height = NotificationViewCell.heightForTopicButton(title)
            let width = UIScreen.main.bounds.width - 24.0
            topicButton.frame = CGRect(x: 12, y: frame.height - height - 5, width: width, height: height)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        presentSafariViewController(url: URL)
        return false
    }
    class func heightForNotification(_ notification: inout MessageNotification) -> CGFloat {
        
        if notification._rowHeight > 0.0 {
            return notification._rowHeight
        }
        
        let width = UIScreen.main.bounds.width - 24.0
        var height: CGFloat = 56.0
        
        if let comment = notification.comment {
            let maxSize = CGSize(width: width - 6.0, height: CGFloat.infinity)
            let rect = comment.boundingRectWithSize(maxSize, attributes: [.font: UIFont.systemFont(ofSize: 14) as Any])
            height += rect.height + 12.0
        }
        
        if let title = notification.title {
            height += heightForTopicButton(title)
        }
        
        notification._rowHeight = height
        return height
        
    }
    
    class func heightForTopicButton(_ title: String) -> CGFloat {
        let width = UIScreen.main.bounds.width - 24.0 - 24.0
        let maxSize = CGSize(width: width, height: CGFloat.infinity)
        let rect = title.boundingRectWithSize(maxSize, attributes: [.font: UIFont.systemFont(ofSize: 11) as Any])
        return rect.height + 24.0
    }
    
    func update(_ model: DataType) {
        guard let notification = model as? MessageNotification else { return }
        
        avatarImageView.kf.setImage(with: notification.avatarURL)
        usernameLabel.text = notification.username
        timeAgoLabel.text = notification.timeAgo
        commentTextView.text = notification.comment
        
        if let title = notification.title {
            topicButton.setTitle(title, for: .normal)
            topicTitle = title
        }
    }
}

