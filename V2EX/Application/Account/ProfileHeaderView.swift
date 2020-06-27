//
//  ProfileHeaderView.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/12/10.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class ProfileHeaderView: UIView {

    var balanceActionHandler: RelayCommand?
    var myNodesActionHandler: RelayCommand?
    var myTopicsActionHandler: RelayCommand?
    var myFollowingActionHandler: RelayCommand?
    
    private let avatarImageView: UIImageView
    private let usernameLabel: UILabel
    private let balanceButton: UIButton
    private let buttonsView: UIView

    override init(frame: CGRect) {
        
        avatarImageView = UIImageView()
        avatarImageView.layer.cornerRadius = 10.0
        avatarImageView.clipsToBounds = true
        
        usernameLabel = UILabel()
        usernameLabel.textColor = Theme.current.titleColor
        usernameLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    
        balanceButton = UIButton(type: .system)
        balanceButton.layer.cornerRadius = 15.0
        balanceButton.layer.masksToBounds = true
        balanceButton.backgroundColor = Theme.current.cellBackgroundColor
        balanceButton.setTitleColor(Theme.current.titleColor, for: .normal)
        balanceButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        balanceButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        buttonsView = UIView()
        buttonsView.backgroundColor = Theme.current.cellBackgroundColor
        buttonsView.layer.cornerRadius = 10.0
        
        super.init(frame: frame)
        
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        addSubview(balanceButton)
        addSubview(buttonsView)
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            avatarImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            avatarImageView.widthAnchor.constraint(equalToConstant: 80),
            avatarImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 15),
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor, constant: 10),
            usernameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        balanceButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            balanceButton.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
            balanceButton.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 10),
            balanceButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonsView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            buttonsView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            buttonsView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 10),
            buttonsView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        let buttonItemWidth: CGFloat = (UIScreen.main.bounds.width - 30 - 2)/3.0
        
        let account = AppContext.current.account
        let nodeButton = ProfileButton(frame: .zero)
        nodeButton.tag = 1
        nodeButton.update(count: account?.myNodes, title: Strings.ProfileFavoritedNodes)
        buttonsView.addSubview(nodeButton)
        
        nodeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nodeButton.leadingAnchor.constraint(equalTo: buttonsView.leadingAnchor),
            nodeButton.centerYAnchor.constraint(equalTo: buttonsView.centerYAnchor),
            nodeButton.widthAnchor.constraint(equalToConstant: buttonItemWidth),
            nodeButton.heightAnchor.constraint(equalTo: buttonsView.heightAnchor)
        ])
        
        let topicButton = ProfileButton(frame: .zero)
        topicButton.tag = 2
        topicButton.update(count: account?.myTopics, title: Strings.ProfileFavoritedTopics)
        buttonsView.addSubview(topicButton)
        
        topicButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topicButton.centerXAnchor.constraint(equalTo: buttonsView.centerXAnchor),
            topicButton.centerYAnchor.constraint(equalTo: buttonsView.centerYAnchor),
            topicButton.widthAnchor.constraint(equalToConstant: buttonItemWidth),
            topicButton.heightAnchor.constraint(equalTo: buttonsView.heightAnchor)
        ])
        
        let separator1 = UIView()
        separator1.backgroundColor = Theme.current.titleColor
        buttonsView.addSubview(separator1)
        
        separator1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separator1.heightAnchor.constraint(equalToConstant: 50),
            separator1.widthAnchor.constraint(equalToConstant: 1),
            separator1.centerYAnchor.constraint(equalTo: buttonsView.centerYAnchor),
            separator1.leadingAnchor.constraint(equalTo: topicButton.leadingAnchor)
        ])
        
        let followingButton = ProfileButton(frame: .zero)
        followingButton.tag = 3
        followingButton.update(count: account?.myFollowing, title: Strings.ProfileMyFollowing)
        buttonsView.addSubview(followingButton)
        
        followingButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            followingButton.trailingAnchor.constraint(equalTo: buttonsView.trailingAnchor),
            followingButton.centerYAnchor.constraint(equalTo: buttonsView.centerYAnchor),
            followingButton.widthAnchor.constraint(equalToConstant: buttonItemWidth),
            followingButton.heightAnchor.constraint(equalTo: buttonsView.heightAnchor)
        ])
        
        let separator2 = UIView()
        separator2.backgroundColor = Theme.current.titleColor
        buttonsView.addSubview(separator2)
        
        separator2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separator2.heightAnchor.constraint(equalToConstant: 50),
            separator2.widthAnchor.constraint(equalToConstant: 1),
            separator2.centerYAnchor.constraint(equalTo: buttonsView.centerYAnchor),
            separator2.leadingAnchor.constraint(equalTo: followingButton.leadingAnchor)
        ])
        
        let balanceValue = account?.balance ?? "0"
        let balance = String(format: Strings.ProfileMyBalanceCount, balanceValue)
        balanceButton.setTitle(balance, for: .normal)

        balanceButton.addTarget(self, action: #selector(handleBalanceButtonTapped(_:)), for: .touchUpInside)
        nodeButton.addTarget(self, action: #selector(handleProfileButtonTapped(_:)))
        topicButton.addTarget(self, action: #selector(handleProfileButtonTapped(_:)))
        followingButton.addTarget(self, action: #selector(handleProfileButtonTapped(_:)))
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
    
    @objc private func handleProfileButtonTapped(_ sender: ProfileButton) {
        if sender.tag == 1 {
            myNodesActionHandler?()
        } else if sender.tag == 2 {
            myTopicsActionHandler?()
        } else if sender.tag == 3 {
            myFollowingActionHandler?()
        }
    }
    
    @objc private func handleBalanceButtonTapped(_ sender: Any) {
        balanceActionHandler?()
    }
}

class ProfileButton: UIView {
    
    private var titleLabel: UILabel!
    
    private var subTitleLabel: UILabel!
    
    private var actionButton: UIButton!
    
    override var tag: Int {
        didSet {
            actionButton.tag = tag
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        
        actionButton = UIButton(type: .system)
        addSubview(actionButton)
        
        titleLabel = UILabel()
        titleLabel.textColor = Theme.current.titleColor
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        actionButton.addSubview(titleLabel)
        
        subTitleLabel = UILabel()
        subTitleLabel.font = UIFont.systemFont(ofSize: 13)
        subTitleLabel.textColor = Theme.current.subTitleColor
        actionButton.addSubview(subTitleLabel)
        
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            actionButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            actionButton.topAnchor.constraint(equalTo: self.topAnchor),
            actionButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            actionButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -7)
        ])
        
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subTitleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            subTitleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 17)
        ])
    }
    
    func addTarget(_ target: Any?, action: Selector) {
        actionButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func update(count: String?, title: String?) {
        titleLabel.text = count
        subTitleLabel.text = title
    }
}
