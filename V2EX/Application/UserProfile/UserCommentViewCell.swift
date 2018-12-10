//
//  UserCommentViewCell.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/12/3.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class UserCommentViewCell: UITableViewCell {
    
    var topicHandler: RelayCommand?
    
    private let avatarImageView: UIImageView
    private let usernameLabel: UILabel
    private let timeAgoLabel: UILabel
    private let commentTextView: UITextView
    private let topicButton: UIButton
    private let lineView: UIView
    
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
        topicButton.backgroundColor = Theme.current.cellBackgroundColor
        topicButton.layer.cornerRadius = 6.0
        topicButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        lineView = UIView()
        lineView.backgroundColor = Theme.current.cellBackgroundColor
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(timeAgoLabel)
        contentView.addSubview(commentTextView)
        contentView.addSubview(topicButton)
        contentView.addSubview(lineView)
        
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
        
        lineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        
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
        usernameLabel.text = comment.username
        timeAgoLabel.text = comment.timeAgo
        
        commentTextView.text = comment.commentContent
        if let title = comment.originTopicTitle, let author = comment.originAuthor {
            let text = author + ":" + title
            topicButton.setTitle(text, for: .normal)
            topicTitle = text
        }
    }
    
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

extension UserCommentViewCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        presentSafariViewController(url: URL)
        return false
    }
    
}
