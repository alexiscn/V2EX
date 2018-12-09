//
//  MenuViewController.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/11/8.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import SnapKit
import FDFullscreenPopGesture

class MenuViewController: UIViewController {

    var selectionChangedHandler: ((_ tab: V2Tab) -> Void)?
    var currentTab: V2Tab?
    
    private var avatarButton: UIButton!
    private var userLabel: UILabel!
    private var tableView: UITableView!
    private var themeButton: UIButton!
    private var settingButton: UIButton!
    private var dataSource: [V2Tab] = V2Tab.tabs()
    private var isFirstViewDidAppear = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.current.backgroundColor
        setupAvatarButton()
        setupTableView()
        setupThemeButton()
        setupSettingButton()
        self.fd_prefersNavigationBarHidden = true
        setupAccount()
    }
    
    private func setupAccount() {
        if let account = AppContext.current.account, let avatar = account.avatarURLString {
            let url = URL(string: avatar)
            avatarButton.kf.setBackgroundImage(with: url, for: .normal)
            userLabel.text = account.username
        } else {
            avatarButton.setBackgroundImage(UIImage(), for: .normal)
            userLabel.text = NSLocalizedString("请先登录", comment: "")
        }
    }
    
    private func setupAvatarButton() {
        avatarButton = UIButton(type: .system)
        avatarButton.backgroundColor = Theme.current.subTitleColor
        avatarButton.layer.cornerRadius = 35
        avatarButton.layer.borderColor = UIColor.white.cgColor
        avatarButton.layer.borderWidth = 1.5
        avatarButton.clipsToBounds = true
        view.addSubview(avatarButton)
        avatarButton.snp.makeConstraints { make in
            make.height.width.equalTo(70)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(60)
        }
        
        userLabel = UILabel()
        userLabel.font = UIFont.systemFont(ofSize: 14.0)
        userLabel.textColor = Theme.current.titleColor
        userLabel.text = NSLocalizedString("请先登录", comment: "")
        userLabel.textAlignment = .center
        view.addSubview(userLabel)
        userLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(avatarButton.snp.bottom).offset(6)
        }
        
        avatarButton.addTarget(self, action: #selector(avatarButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .clear
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(MenuTableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.leading.equalToSuperview()
            make.top.equalTo(avatarButton.snp.bottom).offset(50)
            make.bottom.equalToSuperview().offset(-100)
        }
        tableView.reloadData()
    }
    
    private func setupThemeButton() {
        themeButton = UIButton(type: .system)
        themeButton.contentMode = .center
        themeButton.setImage(UIImage(named: "icon_light"), for: .normal)
        themeButton.tintColor = Theme.current.titleColor
        view.addSubview(themeButton)
        themeButton.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.leading.equalToSuperview().offset(30)
            make.bottom.equalToSuperview().offset(-30)
        }
        themeButton.addTarget(self, action: #selector(themeButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc private func avatarButtonTapped(_ sender: Any) {
        if AppContext.current.isLogined, let username = AppContext.current.account?.username {
            let userVC = UserProfileViewController(username: username)
            navigationController?.pushViewController(userVC, animated: true)
        } else {
            let loginVC = UIStoryboard.main.instantiateViewController(ofType: LoginViewController.self)
            present(loginVC, animated: true, completion: nil)
        }
    }
    
    @objc private func themeButtonTapped(_ sender: Any) {
        let feedback = UIImpactFeedbackGenerator(style: .medium)
        feedback.impactOccurred()
        Theme.current.switchTheme()
    }
    
    private func setupSettingButton() {
        settingButton = UIButton(type: .system)
        settingButton.tintColor = Theme.current.titleColor
        settingButton.setImage(UIImage(named: "icon_settings_24x24_"), for: .normal)
        view.addSubview(settingButton)
        
        settingButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalTo(themeButton)
            make.trailing.equalToSuperview().offset(-30)
        }
        settingButton.addTarget(self, action: #selector(settingButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc private func settingButtonTapped(_ sender: Any) {
        let settingsController = SettingsViewController()
        let nav = SettingsNavigationController(rootViewController: settingsController)
        present(nav, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isFirstViewDidAppear {
            isFirstViewDidAppear = true
            if let index = self.dataSource.firstIndex(where: { $0.title == currentTab?.title }) {
                tableView.selectRow(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .top)
            }
        }
        setupAccount()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(MenuTableViewCell.self), for: indexPath) as! MenuTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.titleLabel.textAlignment = .center
        let menu = dataSource[indexPath.row]
        cell.updateMenu(menu)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menu = dataSource[indexPath.row]
        selectionChangedHandler?(menu)
        currentTab = menu
    }
}
