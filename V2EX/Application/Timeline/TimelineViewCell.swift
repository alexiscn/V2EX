//
//  TimelineViewCell.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/6/25.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

class TimelineViewCell: UITableViewCell {
    
    var nodeHandler: RelayCommand?
    
    var avatarHandler: RelayCommand?
    
    private let backgroundColorView: UIView
    
    private let containerView: UIView
    
    private let avatarButton: UIButton
    
    private let usernameLabel: UILabel
    
    private let titleLabel: UILabel
    
    private let timeLabel: UILabel
    
    private let nodeButton: UIButton
    
    private let commentImageView: UIImageView
    private let commentCountLabel: UILabel
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        containerView = UIView()
        containerView.backgroundColor = Theme.current.cellBackgroundColor
        
        avatarButton = UIButton()
        avatarButton.layer.cornerRadius = 5.0
        avatarButton.layer.masksToBounds = true
        
        usernameLabel = UILabel()
        usernameLabel.textColor = Theme.current.subTitleColor
        usernameLabel.font = AppContext.current.font.subTitleFont //UIFont.systemFont(ofSize: 12)
        
        titleLabel = UILabel()
        titleLabel.font = AppContext.current.font.titleFont
        titleLabel.numberOfLines = 0
        titleLabel.textColor = Theme.current.titleColor
        
        timeLabel = UILabel()
        timeLabel.font = AppContext.current.font.subTitleFont
        timeLabel.textColor = Theme.current.subTitleColor
        
        nodeButton = UIButton(type: .system)
        nodeButton.titleLabel?.font = AppContext.current.font.subTitleFont
        nodeButton.setTitleColor(Theme.current.titleColor, for: .normal)
        nodeButton.backgroundColor = Theme.current.backgroundColor
        nodeButton.contentEdgeInsets = UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5)
        
        commentImageView = UIImageView(image: UIImage(named: "comment"))
        
        commentCountLabel = UILabel()
        commentCountLabel.textColor = Theme.current.subTitleColor
        commentCountLabel.font = AppContext.current.font.subTitleFont
        
        backgroundColorView = UIView()
        backgroundColorView.backgroundColor = Theme.current.cellHighlightColor
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(containerView)
        
        containerView.addSubview(avatarButton)
        containerView.addSubview(usernameLabel)
        containerView.addSubview(timeLabel)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(nodeButton)
        containerView.addSubview(commentImageView)
        containerView.addSubview(commentCountLabel)
        
        selectedBackgroundView = backgroundColorView
        
        configureConstraints()
        
        nodeButton.addTarget(self, action: #selector(handleNodeButtonTapped(_:)), for: .touchUpInside)
        avatarButton.addTarget(self, action: #selector(handleAvatarTapped(_:)), for: .touchUpInside)
        
        ThemeManager.shared.observeThemeUpdated { [weak self] _ in
            self?.updateTheme()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        avatarButton.setImage(nil, for: .normal)
        usernameLabel.text = nil
        timeLabel.text = nil
        titleLabel.text = nil
    }
    
    func update(_ topic: Topic) {
        avatarButton.kf.setImage(with: topic.avatar, for: .normal)
        avatarButton.isHidden = !AppSettings.shared.displayAvatar
        usernameLabel.text = topic.username
        timeLabel.text = topic.lastUpdatedTime
        titleLabel.text = topic.title
        
        if topic.replies == 0 {
            commentImageView.isHidden = true
            commentCountLabel.isHidden = true
        } else {
            commentImageView.isHidden = false
            commentCountLabel.isHidden = false
            commentCountLabel.text = "\(topic.replies)"
        }
        if let title = topic.nodeTitle {
            nodeButton.isHidden = false
            nodeButton.setTitle(title, for: .normal)
        } else {
            nodeButton.isHidden = true
        }
    }
    
    func updateTheme() {
        backgroundColorView.backgroundColor = Theme.current.cellHighlightColor
        containerView.backgroundColor = Theme.current.cellBackgroundColor
        usernameLabel.textColor = Theme.current.subTitleColor
        titleLabel.textColor = Theme.current.titleColor
        timeLabel.textColor = Theme.current.subTitleColor
        nodeButton.setTitleColor(Theme.current.titleColor, for: .normal)
        nodeButton.backgroundColor = Theme.current.backgroundColor
        commentCountLabel.textColor = Theme.current.subTitleColor
    }
    
    class func heightForRowWithTopic(_ topic: inout Topic) -> CGFloat {
        if topic._rowHeight > 0 {
           return topic._rowHeight
        }
        var width = UIScreen.main.bounds.width - 70
        if !AppSettings.shared.displayAvatar {
            width += 50.0
        }
        if let title = topic.title {
            let maxSize = CGSize(width: width, height: CGFloat.infinity)
            let font = AppContext.current.font.titleFont
            let rect = title.boundingRectWithSize(maxSize, attributes: [.font: font as Any])
            let height = 10 + rect.height + 10 + 30
            topic._rowHeight = height
            return height
        }
        return 80
    }
    
}

// MARK: - Constraints
extension TimelineViewCell {
 
    private func configureConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3)
        ])
        
        avatarButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarButton.widthAnchor.constraint(equalToConstant: 40),
            avatarButton.heightAnchor.constraint(equalToConstant: 40),
            avatarButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            avatarButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10)
        ])
        
        let titleLeading: CGFloat = AppSettings.shared.displayAvatar ? 60: 10
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: titleLeading),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10)
        ])
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -3),
            timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10)
        ])
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            usernameLabel.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 5),
            usernameLabel.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor)
        ])
        
        commentImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentImageView.heightAnchor.constraint(equalToConstant: 12),
            commentImageView.widthAnchor.constraint(equalToConstant: 12),
            commentImageView.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
            commentImageView.leadingAnchor.constraint(equalTo: usernameLabel.trailingAnchor, constant: 10)
        ])
        
        commentCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentCountLabel.leadingAnchor.constraint(equalTo: commentImageView.trailingAnchor, constant: 5),
            commentCountLabel.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor)
        ])
        
        nodeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nodeButton.heightAnchor.constraint(equalToConstant: 18),
            nodeButton.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
            nodeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10)
        ])
    }
    
}

// MARK: - Events
extension TimelineViewCell {
    
    @objc private func handleAvatarTapped(_ sender: Any) {
        avatarHandler?()
    }
    
    @objc private func handleNodeButtonTapped(_ sender: Any) {
        nodeHandler?()
    }
}

extension TimelineViewCell: ListViewCell {
    func update(_ model: DataType) {
        guard let topic = model as? Topic else { return }
        update(topic)
    }
}
