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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "设置"
        view.backgroundColor = Theme.current.backgroundColor
        setupNavigationBar()
        setupTableView()
        setupDataSource()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundColor(Theme.current.navigationBarBackgroundColor, textColor: .white)
        
        let leftItem = UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(leftNavigationButtonTapped(_:)))
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
    
    private func setupDataSource() {
        
        setupGenerals()
        
        let autoRefresh = SettingTableModel(title: "自动刷新列表", type: SettingType.switchButton(true))
        
        let switchesSection = SettingTableSectionModel(title: nil, items: [autoRefresh])
        dataSource.append(switchesSection)
        setupAbouts()
    }
    
    private func setupGenerals() {
        let viewOption = SettingTableModel(title: "浏览偏好设置", type: .actionCommand { [weak self] in
            let controller = DisplaySettingsViewController()
            self?.navigationController?.pushViewController(controller, animated: true)
        })
        
        let generalSection = SettingTableSectionModel(title: nil, items: [viewOption])
        dataSource.append(generalSection)
    }
    
    private func setupAbouts() {
        let sourceCode = SettingTableModel(title: "Source Code", type: .actionCommand { [weak self] in
            let url = URL(string: "https://github.com/alexiscn/V2EX")!
            let controller = SFSafariViewController(url: url)
            self?.navigationController?.pushViewController(controller, animated: true)
        })
        
        let openSource = SettingTableModel(title: "Open Source Libraries", type: .actionCommand { [weak self] in
            let controller = OpenSourceViewController()
            self?.navigationController?.pushViewController(controller, animated: true)
        })
        let about = SettingTableModel(title: "关于V2EX", type: .actionCommand {
            
        })
        let aboutSection = SettingTableSectionModel(title: "关于", items: [sourceCode, openSource, about])
        dataSource.append(aboutSection)
    }
    
    @objc private func leftNavigationButtonTapped(_ sender: Any) {
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
        
        switch item.type {
        case .actionCommand(_):
            cell.accessoryType = .disclosureIndicator
        case .switchButton(let value):
            let switchButton = UISwitch()
            switchButton.isOn = value
            cell.accessoryView = switchButton
        }
        cell.textLabel?.text = item.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let group = dataSource[indexPath.section]
        let item = group.items[indexPath.row]
        switch item.type {
        case .actionCommand(let action):
            action?()
        case .switchButton(let value):
            print(value)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: 40)))
        let label = UILabel(frame: .zero)
        label.text = dataSource[section].title
        label.textColor = Theme.current.subTitleColor
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        header.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
}
