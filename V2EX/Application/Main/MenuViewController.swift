//
//  MenuViewController.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/11/8.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import FDFullscreenPopGesture

class MenuViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserLoginSuccess(_:)), name: NSNotification.Name.V2.LoginSuccess, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var selectionChangedHandler: ((_ tab: V2Tab) -> Void)?
    var currentTab: V2Tab?
    
    private var avatarButton: UIButton!
    private var userLabel: UILabel!
    private var tableView: UITableView!
    private var themeButton: UIButton!
    private var messageButton: UIButton!
    private var settingButton: UIButton!
    private var unreadCountLabel: UILabel!
    private var dataSource: [V2Tab] = []
    private var isFirstViewDidAppear = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.current.backgroundColor
        dataSource = V2Tab.tabs()
        setupAvatarButton()
        setupTableView()
        setupThemeButton()
        setupMessageButton()
        setupUnreadCountLabel()
        setupSettingButton()
        self.fd_prefersNavigationBarHidden = true
        tableView.reloadData()
        setupAccount()
        NotificationCenter.default.addObserver(self, selector: #selector(handleAccountUpdated(_:)), name: NSNotification.Name.V2.AccountUpdated, object: nil)
    }
    
    @objc private func handleAccountUpdated(_ notification: Notification) {
        setupAccount()
    }
    
    @objc private func handleUserLoginSuccess(_ notification: Notification) {
        setupAccount()
    }
    
    private func updateTheme() {
        view.backgroundColor = Theme.current.backgroundColor
        avatarButton.backgroundColor = Theme.current.subTitleColor
        themeButton.tintColor = Theme.current.titleColor
        messageButton.tintColor = Theme.current.titleColor
        settingButton.tintColor = Theme.current.titleColor
        userLabel.textColor = Theme.current.titleColor
        
        for cell in tableView.visibleCells {
            let c = cell as? MenuTableViewCell
            c?.updateTheme()
        }
    }
    
    func setupAccount() {
        if let account = AppContext.current.account, let avatar = account.avatarURLString {
            let url = URL(string: avatar)
            avatarButton.kf.setBackgroundImage(with: url, for: .normal)
            userLabel.text = account.username
            unreadCountLabel.text = String(account.unread)
            unreadCountLabel.isHidden = account.unread == 0
        } else {
            avatarButton.setBackgroundImage(UIImage(), for: .normal)
            userLabel.text = Strings.AccountNamePlaceholder
            unreadCountLabel.isHidden = true
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

        avatarButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarButton.widthAnchor.constraint(equalToConstant: 70),
            avatarButton.heightAnchor.constraint(equalToConstant: 70),
            avatarButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            avatarButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60)
        ])
        
        userLabel = UILabel()
        userLabel.font = UIFont.systemFont(ofSize: 14.0)
        userLabel.textColor = Theme.current.titleColor
        userLabel.text = Strings.AccountNamePlaceholder
        userLabel.textAlignment = .center
        view.addSubview(userLabel)

        userLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            userLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            userLabel.topAnchor.constraint(equalTo: avatarButton.bottomAnchor, constant: 6)
        ])
        
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
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: avatarButton.bottomAnchor, constant: 50),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100)
        ])
        tableView.reloadData()
    }
    
    private func setupThemeButton() {
        themeButton = UIButton(type: .system)
        themeButton.contentMode = .center
        themeButton.setImage(UIImage(named: "icon_light"), for: .normal)
        themeButton.tintColor = Theme.current.titleColor
        view.addSubview(themeButton)
        themeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            themeButton.widthAnchor.constraint(equalToConstant: 24),
            themeButton.heightAnchor.constraint(equalToConstant: 24),
            themeButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            themeButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30)
        ])
        themeButton.addTarget(self, action: #selector(themeButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func setupMessageButton() {
        messageButton = UIButton(type: .system)
        messageButton.setImage(UIImage(named: "message_24x24_"), for: .normal)
        messageButton.tintColor = Theme.current.titleColor
        view.addSubview(messageButton)
        messageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageButton.widthAnchor.constraint(equalToConstant: 24),
            messageButton.heightAnchor.constraint(equalToConstant: 24),
            messageButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            messageButton.centerYAnchor.constraint(equalTo: themeButton.centerYAnchor)
        ])
        messageButton.addTarget(self, action: #selector(messageButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func setupUnreadCountLabel() {
        unreadCountLabel = UILabel()
        unreadCountLabel.backgroundColor = .red
        unreadCountLabel.textColor = .white
        unreadCountLabel.font = UIFont.systemFont(ofSize: 11)
        unreadCountLabel.layer.cornerRadius = 9
        unreadCountLabel.clipsToBounds = true
        unreadCountLabel.textAlignment = .center
        unreadCountLabel.isHidden = true
        view.addSubview(unreadCountLabel)
        
        unreadCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            unreadCountLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 18),
            unreadCountLabel.heightAnchor.constraint(equalToConstant: 18),
            unreadCountLabel.leadingAnchor.constraint(equalTo: messageButton.trailingAnchor, constant: -9),
            unreadCountLabel.topAnchor.constraint(equalTo: messageButton.topAnchor, constant: -9)
        ])
    }
    
    @objc private func messageButtonTapped(_ sender: Any) {
        if AppContext.current.isLogined {
            let viewModel = NotificationsViewModel()
            let controller = ListViewController(viewModel: viewModel)
            navigationController?.pushViewController(controller, animated: true)
            
            AppContext.current.account?.unread = 0
            unreadCountLabel.text = "0"
            unreadCountLabel.isHidden = true
        } else {
            let loginVC = UIStoryboard.main.instantiateViewController(ofType: LoginViewController.self)
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: true, completion: nil)
        }
    }
    
    @objc private func avatarButtonTapped(_ sender: Any) {
        if AppContext.current.isLogined {
            let userVC = ProfileViewController()
            navigationController?.pushViewController(userVC, animated: true)
        } else {
            let loginVC = UIStoryboard.main.instantiateViewController(ofType: LoginViewController.self)
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: true, completion: nil)
        }
    }
    
    @objc private func themeButtonTapped(_ sender: Any) {
        let feedback = UIImpactFeedbackGenerator(style: .medium)
        feedback.impactOccurred()
        ThemeManager.shared.switchTheme()
        updateTheme()
    }
    
    private func setupSettingButton() {
        settingButton = UIButton(type: .system)
        settingButton.tintColor = Theme.current.titleColor
        settingButton.setImage(UIImage(named: "icon_settings_24x24_"), for: .normal)
        view.addSubview(settingButton)
        
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingButton.widthAnchor.constraint(equalToConstant: 24),
            settingButton.heightAnchor.constraint(equalToConstant: 24),
            settingButton.centerYAnchor.constraint(equalTo: themeButton.centerYAnchor),
            settingButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30)
        ])
        settingButton.addTarget(self, action: #selector(settingButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc private func settingButtonTapped(_ sender: Any) {
        let settingsController = SettingsViewController()
        let nav = SettingsNavigationController(rootViewController: settingsController)
        nav.modalPresentationStyle = .fullScreen
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
