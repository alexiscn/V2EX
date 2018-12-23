//
//  SettingsViewController.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/6/26.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import SafariServices

class SettingsNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.current.statusBarStyle
    }
}

class SettingsViewController: UIViewController {

    private var tableView: UITableView!
    private var dataSource: [SettingTableSectionModel] = []
    private var versionLabel: UILabel!
    
    enum Tags: Int {
        case autoRefreshListOnAppLaunch = 1
        case enableFullScreenGesture = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = Strings.Settings
        view.backgroundColor = Theme.current.backgroundColor
        setupNavigationBar()
        setupTableView()
        setupVersionLabel()
        setupDataSource()
    }
    
    private func setupNavigationBar() {
        configureNavigationBar()
        let leftItem = UIBarButtonItem(title: Strings.Done, style: .done, target: self, action: #selector(leftNavigationButtonTapped(_:)))
        navigationItem.leftBarButtonItem = leftItem
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .grouped)
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.separatorColor = Theme.current.backgroundColor
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(SettingViewCell.self, forCellReuseIdentifier: NSStringFromClass(SettingViewCell.self))
    }
    
    private func setupVersionLabel() {
        versionLabel = UILabel()
        versionLabel.font = UIFont.systemFont(ofSize: 11)
        versionLabel.textColor = Theme.current.subTitleColor
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            versionLabel.text = "V \(version)"
        } else {
            versionLabel.text = "V 1.0"
        }
        
        view.addSubview(versionLabel)
        versionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-view.keyWindowSafeAreaInsets.bottom)
        }
    }
    
    private func setupDataSource() {
        setupGenerals()
        setupAbouts()
        setupAccounts()
    }
    
    private func setupGenerals() {
        let language = SettingTableModel(title: Strings.SettingsLanguage, value: .actionCommand { [weak self] in
            let controller = LanguageSettingsViewController()
            self?.navigationController?.pushViewController(controller, animated: true)
            })
//        let viewOption = SettingTableModel(title: Strings.SettingsViewOptions, value: .actionCommand { [weak self] in
//            let controller = DisplaySettingsViewController()
//            self?.navigationController?.pushViewController(controller, animated: true)
//        })
        let autoRefresh = SettingTableModel(title: Strings.SettingsAutoRefresh, value: SettingValue.switchButton(AppSettings.shared.autoRefreshOnAppLaunch, Tags.autoRefreshListOnAppLaunch.rawValue))
        
        let enableFullScreenGesture = SettingTableModel(title: Strings.SettingsEnableFullGesture, value: SettingValue.switchButton(AppSettings.shared.enableFullScreenGesture, Tags.enableFullScreenGesture.rawValue))
        let generalSection = SettingTableSectionModel(title: nil, items: [language, autoRefresh, enableFullScreenGesture])
        dataSource.append(generalSection)
    }
    
    private func setupAbouts() {
        let sourceCode = SettingTableModel(title: Strings.SettingsSourceCode, value: .actionCommand { [weak self] in
            let url = URL(string: "https://github.com/alexiscn/V2EX")!
            let controller = SFSafariViewController(url: url)
            self?.present(controller, animated: true, completion: nil)
        })
        
        let openSource = SettingTableModel(title: Strings.SettingsOpenSource, value: .actionCommand { [weak self] in
            let controller = OpenSourceViewController()
            self?.navigationController?.pushViewController(controller, animated: true)
        })
        let releaseNotes = SettingTableModel(title: Strings.SettingsReleaseNotes, value: .actionCommand { [weak self] in
            let url = URL(string: "https://github.com/alexiscn/V2EX/blob/master/ReleaseNotes.md")!
            let controller = SFSafariViewController(url: url)
            self?.present(controller, animated: true, completion: nil)
        })
        let about = SettingTableModel(title: Strings.SettingsAbout, value: .actionCommand { [weak self] in
            let controller = UIStoryboard.main.instantiateViewController(ofType: AboutViewController.self)
            self?.navigationController?.pushViewController(controller, animated: true)
        })
        let aboutSection = SettingTableSectionModel(title: Strings.SettingsAbout, items: [sourceCode, openSource, releaseNotes, about])
        dataSource.append(aboutSection)
    }
    
    private func setupAccounts() {
        guard AppContext.current.isLogined else { return }
        
        let logout = SettingTableModel(title: Strings.SettingsLogout, value: .actionCommand { [weak self] in
            self?.handleUserLogout()
        })
        let accountSection = SettingTableSectionModel(title: Strings.SettingsAccount, items: [logout])
        dataSource.append(accountSection)
    }
    
    @objc private func leftNavigationButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func switchValueDidChanged(_ sender: UISwitch) {
        switch sender.tag {
        case Tags.autoRefreshListOnAppLaunch.rawValue:
            AppSettings.shared.autoRefreshOnAppLaunch = sender.isOn
        case Tags.enableFullScreenGesture.rawValue:
            AppSettings.shared.enableFullScreenGesture = sender.isOn
            NotificationCenter.default.post(name: NSNotification.Name.V2.FullGestureEnableChanged, object: nil)
        default:
            break
        }
    }
    
    private func handleUserLogout() {
        let alert = UIAlertController(title: Strings.SettingsLogoutPrompt, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.OK, style: .default, handler: { [weak self] _ in
            self?.doLogout()
        }))
        alert.addAction(UIAlertAction(title: Strings.Cancel, style: .cancel, handler: { _ in

        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func doLogout() {
        AppContext.current.doLogout()
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let group = dataSource[section]
        return group.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = dataSource[indexPath.section]
        let item = group.items[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(SettingViewCell.self), for: indexPath)
        cell.backgroundColor = Theme.current.cellBackgroundColor
        cell.textLabel?.textColor = Theme.current.titleColor
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15.0)
        
        switch item.value {
        case .actionCommand(_):
            cell.accessoryType = .disclosureIndicator
        case .switchButton(let isOn, let tag):
            let switchButton = UISwitch()
            switchButton.isOn = isOn
            switchButton.tag = tag
            switchButton.addTarget(self, action: #selector(switchValueDidChanged(_:)), for: .valueChanged)
            cell.accessoryView = switchButton
        }
        cell.textLabel?.text = item.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let group = dataSource[indexPath.section]
        let item = group.items[indexPath.row]
        switch item.value {
        case .actionCommand(let action):
            action?()
        case .switchButton(let value):
            print(value)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: 40)))
        let label = UILabel(frame: .zero)
        label.text = dataSource[section].title?.uppercased()
        label.textColor = Theme.current.subTitleColor
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        header.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-8)
            make.trailing.equalToSuperview()
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10.0
        }
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
}
