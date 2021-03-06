//
//  UserCommentViewCell.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/12/3.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class UserCommentViewCell: UITableViewCell, ListViewCell {
    
    var topicHandler: RelayCommand?
    
    private let containerView: UIView
    private let avatarImageView: UIImageView
    private let usernameLabel: UILabel
    private let timeAgoLabel: UILabel
    private let commentTextView: UITextView
    private let topicButton: UIButton
    private let lineView: UIView
    
    private var topicTitle: String?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        containerView = UIView()
        containerView.backgroundColor = Theme.current.cellBackgroundColor
        
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
        
        lineView = UIView()
        lineView.backgroundColor = Theme.current.cellHighlightColor
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(containerView)
        
        containerView.addSubview(avatarImageView)
        containerView.addSubview(usernameLabel)
        containerView.addSubview(timeAgoLabel)
        containerView.addSubview(commentTextView)
        containerView.addSubview(topicButton)
        containerView.addSubview(lineView)

        configureConstraints()

        let backgroundView = UIView()
        backgroundView.backgroundColor = Theme.current.cellHighlightColor
        selectedBackgroundView = backgroundView
        
        commentTextView.delegate = self
        topicButton.addTarget(self, action: #selector(handleTopicButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc private func handleTopicButtonTapped(_ sender: Any) {
        topicHandler?()
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
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        commentTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            commentTextView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            commentTextView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 56)
        ])
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 32),
            avatarImageView.heightAnchor.constraint(equalToConstant: 32),
            avatarImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            avatarImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12)
        ])
        
        let usernameLeading: CGFloat = AppSettings.shared.displayAvatar ? 54.0: 10.0
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            usernameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: usernameLeading),
            usernameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            usernameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12)
        ])
        
        timeAgoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeAgoLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            timeAgoLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 3),
            timeAgoLabel.trailingAnchor.constraint(equalTo: usernameLabel.trailingAnchor)
        ])
        
        lineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lineView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: LineHeight),
            lineView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let title = topicTitle {
            let height = UserCommentViewCell.heightForTopicButton(title)
            let width = UIScreen.main.bounds.width - 24.0
            topicButton.frame = CGRect(x: 12, y: frame.height - height - 20.0, width: width, height: height)
        }
    }
    
    func update(_ comment: UserProfileComment) {
        
        avatarImageView.kf.setImage(with: comment.avatarURL)
        avatarImageView.isHidden = !AppSettings.shared.displayAvatar
        usernameLabel.text = comment.username
        timeAgoLabel.text = comment.timeAgo
        
        commentTextView.text = comment.commentContent
        if let title = comment.originTopicTitle, let author = comment.originAuthor {
            let text = author + ":" + title
            topicButton.setTitle(text, for: .normal)
            topicTitle = text
        }
    }
    
    func update(_ model: DataType) {
        guard let comment = model as? UserProfileComment else { return }
        update(comment)
    }
}

// MARK: - Height Calculation
extension UserCommentViewCell {
    
    class func heightForComment(_ comment: inout UserProfileComment) -> CGFloat {
        
        if comment._rowHeight > 0.0 {
            return comment._rowHeight
        }
        
        let width = UIScreen.main.bounds.width - 24.0
        var height: CGFloat = 56.0
        
        if let commentContent = comment.commentContent {
            let maxSize = CGSize(width: width - 6.0, height: CGFloat.infinity)
            let rect = commentContent.boundingRectWithSize(maxSize, attributes: [.font: UIFont.systemFont(ofSize: 14) as Any])
            height += rect.height + 12.0
        }
        
        if let title = comment.originTopicTitle, let author = comment.originAuthor {
            let text = author + ":" + title
            height += heightForTopicButton(text)
            height += 12.0
        }
        
        comment._rowHeight = height
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
extension UserCommentViewCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        presentSafariViewController(url: URL)
        return false
    }
    
}
