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
    
    private let containerView: UIView
    
    private let avatarView: UIImageView
    
    private let usernameLabel: UILabel
    
    private let titleLabel: UILabel
    
    private let timeLabel: UILabel
    
    private let nodeButton: UIButton
    
    private let commentImageView: UIImageView
    private let commentCountLabel: UILabel
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        containerView = UIView()
        containerView.backgroundColor = Theme.current.cellBackgroundColor
        
        avatarView = UIImageView()
        avatarView.layer.cornerRadius = 5.0
        avatarView.layer.masksToBounds = true
        
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
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(containerView)
        
        containerView.addSubview(avatarView)
        containerView.addSubview(usernameLabel)
        containerView.addSubview(timeLabel)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(nodeButton)
        containerView.addSubview(commentImageView)
        containerView.addSubview(commentCountLabel)
    
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(3)
            make.bottom.equalToSuperview().offset(-3)
        }
        
        avatarView.snp.makeConstraints { make in
            make.height.width.equalTo(40)
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
        }
        
        let titleLeading: CGFloat = AppSettings.shared.displayAvatar ? 60: 10
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(titleLeading)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading).offset(-3)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.leading.equalTo(timeLabel.snp.trailing).offset(5)
            make.centerY.equalTo(nodeButton)
        }
        
        commentImageView.snp.makeConstraints { make in
            make.height.width.equalTo(12)
            make.centerY.equalTo(timeLabel)
            make.leading.equalTo(usernameLabel.snp.trailing).offset(10)
        }
        
        commentCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(commentImageView.snp.trailing).offset(5)
            make.centerY.equalTo(timeLabel)
        }
        
        nodeButton.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalTo(timeLabel)
        }
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = Theme.current.cellHighlightColor
        selectedBackgroundView = backgroundView
        
        nodeButton.addTarget(self, action: #selector(handleNodeButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc private func handleNodeButtonTapped(_ sender: Any) {
        nodeHandler?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        avatarView.image = nil
        usernameLabel.text = nil
        timeLabel.text = nil
        titleLabel.text = nil
        //nodeButton.setTitle(nil, for: .normal)
    }
    
    func update(_ topic: Topic) {
        
        avatarView.kf.setImage(with: topic.avatar)
        avatarView.isHidden = !AppSettings.shared.displayAvatar
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
