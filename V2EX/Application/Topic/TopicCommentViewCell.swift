//
//  TopicCommentViewCell.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/6/26.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import SafariServices

class TopicCommentViewCell: UITableViewCell {

    var userTappedHandler: RelayCommand?
    
    private let containerView: UIView
    
    private let avatarButton: UIButton
    
    private let floorLabel: UILabel
    
    private let usernameButton: UIButton
    
    private let timeAgoLabel: UILabel
    
    private let likesLabel: UILabel
    
    private let ownerLabel: TagLabel
    
    private let contentTextView: UITextView
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        containerView = UIView()
        containerView.backgroundColor = Theme.current.cellBackgroundColor
        
        avatarButton = UIButton(type: .system)
        avatarButton.layer.cornerRadius = 5.0
        avatarButton.layer.masksToBounds = true
        
        floorLabel = UILabel()
        floorLabel.font = UIFont.systemFont(ofSize: 11)
        floorLabel.textColor = Theme.current.subTitleColor
        
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
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(containerView)
        containerView.addSubview(avatarButton)
        containerView.addSubview(usernameButton)
        containerView.addSubview(timeAgoLabel)
        containerView.addSubview(likesLabel)
        containerView.addSubview(ownerLabel)
        containerView.addSubview(floorLabel)
        containerView.addSubview(contentTextView)
        
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(0.5)
            make.bottom.equalToSuperview()
        }
        
        avatarButton.snp.makeConstraints { make in
            make.height.width.equalTo(32)
            make.leading.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(12)
        }
        
        let usernameLeading: CGFloat = AppSettings.shared.displayAvatar ? 54.0: 10.0
        usernameButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(usernameLeading)
            make.top.equalTo(avatarButton).offset(-5)
        }
        
        timeAgoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(usernameButton)
            make.leading.equalTo(usernameButton.snp.trailing).offset(5)
        }
        
        likesLabel.snp.makeConstraints { make in
            make.centerY.equalTo(usernameButton)
            make.leading.equalTo(timeAgoLabel.snp.trailing).offset(5)
        }
        
        ownerLabel.snp.makeConstraints { make in
            make.centerY.equalTo(usernameButton)
            make.leading.equalTo(likesLabel.snp.trailing).offset(5)
        }
        
        floorLabel.snp.makeConstraints { make in
            make.centerY.equalTo(usernameButton)
            make.trailing.equalToSuperview().offset(-12)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.leading.equalToSuperview().offset(usernameLeading)
            make.top.equalToSuperview().offset(38)
            make.bottom.equalToSuperview().offset(-9)
        }
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = Theme.current.cellHighlightColor
        selectedBackgroundView = backgroundView
        
        contentTextView.delegate = self
        
        avatarButton.addTarget(self, action: #selector(usernameButtonTapped(_:)), for: .touchUpInside)
        usernameButton.addTarget(self, action: #selector(usernameButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc private func usernameButtonTapped(_ sender: Any) {
        userTappedHandler?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(_ reply: Reply) {
        usernameButton.setTitle(reply.username, for: .normal)
        avatarButton.kf.setBackgroundImage(with: reply.avatarURL, for: .normal)
        avatarButton.isHidden = !AppSettings.shared.displayAvatar
        contentTextView.text = reply.content
        timeAgoLabel.text = reply.timeAgo
        likesLabel.text = reply.likesInfo
        if let floor = reply.floor {
            floorLabel.text = "\(floor)楼"
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

    class func heightForRowWithReply(_ reply: inout Reply) -> CGFloat {
        
        if reply._rowHeight > 0 {
            return reply._rowHeight
        }
        var width = UIScreen.main.bounds.width - 68
        if !AppSettings.shared.displayAvatar {
            width += 44
        }
        if let title = reply.content {
            let maxSize = CGSize(width: width, height: CGFloat.infinity)
            let rect = title.boundingRectWithSize(maxSize, attributes: [.font: UIFont.systemFont(ofSize: 14) as Any])
            let height = 38 + rect.height + 9 + 6 // 38: top, 9: bottom
            reply._rowHeight = height
            return height
        }
        return 80
        
    }
}

extension TopicCommentViewCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
//        if URL.absoluteString.hasPrefix("https://www.v2ex.com/t") || URL.absoluteString.hasPrefix("https://v2ex.com/t") {
//            
//            return false
//        }
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
