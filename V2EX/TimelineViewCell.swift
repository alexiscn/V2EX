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
import V2SDK

class TimelineViewCell: UITableViewCell {
    
    private let avatarView: UIImageView
    
    private let titleLabel: UILabel
    
    private let nodeButton: UIButton
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        avatarView = UIImageView()
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.numberOfLines = 0
        
        nodeButton = UIButton(type: .system)
        nodeButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        nodeButton.setTitleColor(UIColor(red: 153.0/255, green: 153.0/255, blue: 153.0/255, alpha: 1.0), for: .normal)
        nodeButton.backgroundColor = UIColor(red: 245.0/255, green: 245.0/255, blue: 245.0/255, alpha: 1.0)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(avatarView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(nodeButton)
        
        avatarView.snp.makeConstraints { make in
            make.height.width.equalTo(40)
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(60)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        avatarView.image = nil
        titleLabel.text = nil
    }
    
    func update(_ topic: Topic) {
        
        avatarView.kf.setImage(with: topic.member?.avatar)
        titleLabel.text = topic.title
        nodeButton.setTitle(topic.node?.title, for: .normal)
        
        if let nodeTitle = topic.node?.title {
            let size = (nodeTitle as NSString).size(withAttributes: [.font: nodeButton.titleLabel?.font! as Any])
            nodeButton.frame.origin = CGPoint(x: 60, y: titleLabel.frame.maxY + 10)
            nodeButton.frame.size = CGSize(width: size.width + 10, height: size.height + 4)
        }
        
        
    }
    
}
