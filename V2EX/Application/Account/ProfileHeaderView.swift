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
//    private let balanceButton: UIButton
    private let buttonsView: UIView

    override init(frame: CGRect) {
        
        avatarImageView = UIImageView()
        avatarImageView.layer.cornerRadius = 10.0
        avatarImageView.clipsToBounds = true
        
        usernameLabel = UILabel()
        usernameLabel.textColor = Theme.current.titleColor
        usernameLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    
//        balanceButton = UIButton(type: .system)
//        balanceButton.layer.cornerRadius = 15.0
//        balanceButton.layer.masksToBounds = true
//        balanceButton.backgroundColor = Theme.current.cellBackgroundColor
//        balanceButton.setTitleColor(Theme.current.titleColor, for: .normal)
//        balanceButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//        balanceButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        buttonsView = UIView()
        buttonsView.backgroundColor = Theme.current.cellBackgroundColor
        buttonsView.layer.cornerRadius = 10.0
        
        super.init(frame: frame)
        
        addSubview(avatarImageView)
        addSubview(usernameLabel)
//        addSubview(balanceButton)
        addSubview(buttonsView)
        
        avatarImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.height.width.equalTo(80)
            make.top.equalToSuperview().offset(10)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(15)
            make.top.equalTo(avatarImageView.snp.top).offset(10)
        }
        
//        balanceButton.snp.makeConstraints { make in
//            make.leading.equalTo(avatarImageView.snp.trailing).offset(10)
//            make.height.equalTo(30)
//            make.top.equalTo(usernameLabel.snp.bottom).offset(10)
//        }
    
        buttonsView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalTo(avatarImageView.snp.bottom).offset(10)
            make.height.equalTo(80)
        }
        
        let buttonItemWidth: CGFloat = (UIScreen.main.bounds.width - 30 - 2)/3.0
        
        let account = AppContext.current.account
        let nodeButton = ProfileButton(frame: .zero)
        nodeButton.tag = 1
        nodeButton.update(count: account?.myNodes, title: Strings.ProfileFavoritedNodes)
        buttonsView.addSubview(nodeButton)
        nodeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(buttonItemWidth)
            make.height.equalToSuperview()
        }
        
        let topicButton = ProfileButton(frame: .zero)
        topicButton.tag = 2
        topicButton.update(count: account?.myTopics, title: Strings.ProfileFavoritedTopics)
        buttonsView.addSubview(topicButton)
        topicButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(buttonItemWidth)
            make.height.equalToSuperview()
        }
        
        let separator1 = UIView()
        separator1.backgroundColor = Theme.current.titleColor
        buttonsView.addSubview(separator1)
        separator1.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(1)
            make.centerY.equalToSuperview()
            make.leading.equalTo(topicButton)
        }
        
        let followingButton = ProfileButton(frame: .zero)
        followingButton.tag = 3
        followingButton.update(count: account?.myFollowing, title: Strings.ProfileMyFollowing)
        buttonsView.addSubview(followingButton)
        followingButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(buttonItemWidth)
            make.height.equalToSuperview()
        }
        
        let separator2 = UIView()
        separator2.backgroundColor = Theme.current.titleColor
        buttonsView.addSubview(separator2)
        separator2.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(1)
            make.centerY.equalToSuperview()
            make.leading.equalTo(followingButton)
        }
        
//        let balanceValue = account?.balance ?? "0"
//        let balance = String(format: Strings.ProfileMyBalanceCount, balanceValue)
//        balanceButton.setTitle(balance, for: .normal)
//
//        balanceButton.addTarget(self, action: #selector(handleBalanceButtonTapped(_:)), for: .touchUpInside)
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
        actionButton.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        titleLabel = UILabel()
        titleLabel.textColor = Theme.current.titleColor
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        actionButton.addSubview(titleLabel)
        
        subTitleLabel = UILabel()
        subTitleLabel.font = UIFont.systemFont(ofSize: 13)
        subTitleLabel.textColor = Theme.current.subTitleColor
        actionButton.addSubview(subTitleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-7)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(17)
        }
    }
    
    func addTarget(_ target: Any?, action: Selector) {
        actionButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func update(count: String?, title: String?) {
        titleLabel.text = count
        subTitleLabel.text = title
    }
}
