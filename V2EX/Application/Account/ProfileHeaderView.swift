//
//  ProfileHeaderView.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/12/10.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class ProfileHeaderView: UIView {

    let avatarImageView: UIImageView
    
    let usernameLabel: UILabel
    
    let infoLabel: UILabel
    
    override init(frame: CGRect) {
        
        avatarImageView = UIImageView()
        avatarImageView.layer.cornerRadius = 40.0
        avatarImageView.clipsToBounds = true
        
        usernameLabel = UILabel()
        usernameLabel.textColor = Theme.current.titleColor
        usernameLabel.font = AppContext.current.font.titleFont
        
        infoLabel = UILabel()
        infoLabel.textColor = Theme.current.subTitleColor
        infoLabel.font = AppContext.current.font.subTitleFont
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center
        
        super.init(frame: frame)
        
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        addSubview(infoLabel)
        
        avatarImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.width.equalTo(80)
            make.top.equalToSuperview()
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(avatarImageView.snp.bottom).offset(10)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().offset(-50)
            make.top.equalTo(usernameLabel.snp.bottom).offset(3)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        if let avatar = AppContext.current.account?.avatarURLString {
            avatarImageView.kf.setImage(with: URL(string: avatar))
        }
        usernameLabel.text = AppContext.current.account?.username
    }
    
    func update(info: UserInfo) {
//        avatarImageView.kf.setImage(with: info.avatarURL)
//        usernameLabel.text = info.username
//        infoLabel.text = info.createdInfo
    }

}
