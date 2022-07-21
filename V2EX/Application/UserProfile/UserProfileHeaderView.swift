//
//  UserProfileHeaderView.swift
//  V2EX
//
//  Created by alexiscn on 2018/12/3.
//  Copyright © 2018 alexiscn. All rights reserved.
//

import UIKit

class UserProfileHeaderView: UIView {
    
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

        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 80),
            avatarImageView.heightAnchor.constraint(equalToConstant: 80),
            avatarImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            avatarImageView.topAnchor.constraint(equalTo: self.topAnchor)
        ])
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            usernameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 10)
        ])
        
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
            infoLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
            infoLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 3)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(info: UserInfo) {
        avatarImageView.kf.setImage(with: info.avatarURL)
        usernameLabel.text = info.username
        infoLabel.text = info.createdInfo
    }
}
