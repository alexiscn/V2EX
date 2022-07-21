//
//  NotificationViewCell.swift
//  V2EX
//
//  Created by alexiscn on 2018/12/11.
//  Copyright © 2018 alexiscn. All rights reserved.
//

import UIKit

class NotificationViewCell: UITableViewCell, ListViewCell {
    
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
        
        configureConstraints()
    
        let backgroundView = UIView()
        backgroundView.backgroundColor = Theme.current.cellHighlightColor
        selectedBackgroundView = backgroundView
        
        commentTextView.delegate = self
    }
    
    private func configureConstraints() {
        commentTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            commentTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            commentTextView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 56)
        ])
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 32),
            avatarImageView.heightAnchor.constraint(equalToConstant: 32),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12)
        ])
        
        let usernameLeading: CGFloat = AppSettings.shared.displayAvatar ? 54.0: 10.0
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: usernameLeading),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            usernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12)
        ])
        
        timeAgoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeAgoLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            timeAgoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            timeAgoLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 3)
        ])
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

// MARK: - Height Calculation
extension NotificationViewCell {
    
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
}

// MARK: - UITextViewDelegate
extension NotificationViewCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        presentSafariViewController(url: URL)
        return false
    }
}
