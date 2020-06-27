//
//  TopicCommentViewCell.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/6/26.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import Kingfisher
import SafariServices

class TopicCommentViewCell: UITableViewCell {

    var userTappedHandler: RelayCommand?
    
    var mentionHandler: RelayCommand?
    
    var topicLinkHandler: ((URL) -> Void)?
    
    var nodeLinkHandler: ((String) -> Void)?
    
    var mentionUserTappedHandler: ((_ username: String) -> Void)?
    
    private let containerView: UIView
    
    private let avatarButton: UIButton
    
    private let floorButton: UIButton
    
    private let usernameButton: UIButton
    
    private let timeAgoLabel: UILabel
    
    private let likesLabel: UILabel
    
    private let ownerLabel: TagLabel
    
    private let contentTextView: UITextView
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        containerView = UIView()
        containerView.backgroundColor = Theme.current.cellBackgroundColor
        
        avatarButton = UIButton(type: .system)
        avatarButton.layer.cornerRadius = 5.0
        avatarButton.layer.masksToBounds = true
        
        floorButton = UIButton(type: .system)
        floorButton.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        floorButton.setTitleColor(Theme.current.subTitleColor, for: .normal)
        floorButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 12)
        
        usernameButton = UIButton(type: .system)
        usernameButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        usernameButton.setTitleColor(Theme.current.titleColor, for: .normal)
        
        timeAgoLabel = UILabel()
        timeAgoLabel.font = UIFont.systemFont(ofSize: 11)
        timeAgoLabel.textColor = Theme.current.subTitleColor
        
        likesLabel = UILabel()
        likesLabel.font = UIFont.systemFont(ofSize: 11)
        likesLabel.textColor = Theme.current.subTitleColor
        
        ownerLabel = TagLabel()
        ownerLabel.backgroundColor = Theme.current.backgroundColor
        ownerLabel.textColor = Theme.current.titleColor
        ownerLabel.font = UIFont.systemFont(ofSize: 10)
        
        contentTextView = UITextView()
        contentTextView.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        contentTextView.backgroundColor = .clear
        contentTextView.dataDetectorTypes = .link
        contentTextView.isEditable = false
        contentTextView.isSelectable = true
        contentTextView.isScrollEnabled = false
        contentTextView.font = UIFont.systemFont(ofSize: 14)
        contentTextView.textColor = Theme.current.titleColor
        contentTextView.linkTextAttributes = [:]
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(containerView)
        containerView.addSubview(avatarButton)
        containerView.addSubview(usernameButton)
        containerView.addSubview(timeAgoLabel)
        containerView.addSubview(likesLabel)
        containerView.addSubview(ownerLabel)
        containerView.addSubview(floorButton)
        containerView.addSubview(contentTextView)
        
        configureConstraints()
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = Theme.current.cellHighlightColor
        selectedBackgroundView = backgroundView
        
        contentTextView.delegate = self
        
        avatarButton.addTarget(self, action: #selector(usernameButtonTapped(_:)), for: .touchUpInside)
        usernameButton.addTarget(self, action: #selector(usernameButtonTapped(_:)), for: .touchUpInside)
        floorButton.addTarget(self, action: #selector(floorButtonTapped(_:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.5)
        ])
        
        avatarButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarButton.widthAnchor.constraint(equalToConstant: 32),
            avatarButton.heightAnchor.constraint(equalToConstant: 32),
            avatarButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            avatarButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12)
        ])
        
        let usernameLeading: CGFloat = AppSettings.shared.displayAvatar ? 54.0: 10.0
        usernameButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            usernameButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: usernameLeading),
            usernameButton.topAnchor.constraint(equalTo: avatarButton.topAnchor, constant: -5)
        ])
        
        timeAgoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeAgoLabel.centerYAnchor.constraint(equalTo: usernameButton.centerYAnchor),
            timeAgoLabel.leadingAnchor.constraint(equalTo: usernameButton.trailingAnchor, constant: 5)
        ])
        
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            likesLabel.centerYAnchor.constraint(equalTo: usernameButton.centerYAnchor),
            likesLabel.leadingAnchor.constraint(equalTo: timeAgoLabel.trailingAnchor, constant: 5)
        ])
        
        ownerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ownerLabel.centerYAnchor.constraint(equalTo: usernameButton.centerYAnchor),
            ownerLabel.leadingAnchor.constraint(equalTo: likesLabel.trailingAnchor, constant: 5)
        ])
        
        floorButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            floorButton.centerYAnchor.constraint(equalTo: usernameButton.centerYAnchor),
            floorButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: usernameLeading),
            contentTextView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 38),
            contentTextView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            contentTextView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -9)
        ])
    }
    
    func update(_ reply: Reply) {
        usernameButton.setTitle(reply.username, for: .normal)
        avatarButton.kf.setBackgroundImage(with: reply.avatarURL, for: .normal)
        avatarButton.isHidden = !AppSettings.shared.displayAvatar
        contentTextView.attributedText = reply.contentAttributedString
        timeAgoLabel.text = reply.timeAgo
        likesLabel.text = "♥ \(reply.likeCount)"
        likesLabel.isHidden = reply.likeCount == 0
        if let floor = reply.floor {
            floorButton.setTitle("\(floor)楼", for: .normal)
        }
        if reply.isTopicAuthor {
            ownerLabel.isHidden = false
            ownerLabel.text = Strings.DetailOriginPoster
            ownerLabel.setNeedsLayout()
        } else {
            ownerLabel.isHidden = true
            ownerLabel.text = nil
        }
    }
}

// MARK: - Height Calculation
extension TopicCommentViewCell {
    
    class func heightForRowWithReply(_ reply: inout Reply) -> CGFloat {
        
        if reply._rowHeight > 0 {
            return reply._rowHeight
        }
        var width = UIScreen.main.bounds.width - 68
        if !AppSettings.shared.displayAvatar {
            width += 44
        }
        if let content = reply.contentAttributedString {
            let maxSize = CGSize(width: width, height: CGFloat.infinity)
            let rect = content.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
            let height = 38 + rect.height + 9 + 4 // 38: top, 9: bottom
            reply._rowHeight = height
            return height
        }
        return 80
        
    }
}

// MARK: - Events
extension TopicCommentViewCell {
    
    @objc private func floorButtonTapped(_ sender: Any) {
        mentionHandler?()
    }
    
    @objc private func usernameButtonTapped(_ sender: Any) {
        userTappedHandler?()
    }
}

// MARK: - UITextViewDelegate
extension TopicCommentViewCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.absoluteString.hasPrefix("https://www.v2ex.com/t") || URL.absoluteString.hasPrefix("https://v2ex.com/t") {
            topicLinkHandler?(URL)
            return false
        }
        if URL.absoluteString.hasPrefix("https://www.v2ex.com/go") || URL.absoluteString.hasPrefix("https://v2ex.com/go") {
            let nodename = URL.lastPathComponent
            nodeLinkHandler?(nodename)
            return false
        }
        let memberPrefix = "https://www.v2ex.com/member/"
        if URL.absoluteString.hasPrefix(memberPrefix) {
            let username = URL.absoluteString.replacingOccurrences(of: memberPrefix, with: "")
            mentionUserTappedHandler?(username)
            return false
        }
        presentSafariViewController(url: URL)
        return false
    }
    
}

class TagLabel: UILabel {
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: 5, dy: 2))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + 10, height: size.height + 4)
    }
}
