//
//  DisplaySettingsViewController.swift
//  V2EX
//
//  Created by alexiscn on 2018/11/28.
//  Copyright © 2018 alexiscn. All rights reserved.
//

import UIKit

class DisplaySettingsViewController: UIViewController {

    private var tableView: UITableView!
    private var dataSource: [SettingTableSectionModel] = []
    
    private let tagDisplayAvatar: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.SettingsViewOptions
        view.backgroundColor = Theme.current.backgroundColor
        setupDataSource()
        setupTableView()
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
        
        let header = TimelineViewCell(style: .default, reuseIdentifier: nil)
        var topic = Topic()
        topic.title = "BlizzCon 2018 上所有的新发布的游戏的视频合集"
        topic.avatar = URL(string: "https://cdn.v2ex.com/avatar/c4ca/4238/1_large.png?m=1466415272")
        topic.replies = 30
        topic.nodeTitle = "游戏"
        topic.lastUpdatedTime = "3 天前"
        topic._rowHeight = TimelineViewCell.heightForRowWithTopic(&topic)
        topic.username = "Livid"
        header.update(topic)
        
        header.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: topic._rowHeight)
        tableView.tableHeaderView = header
    }

    private func setupDataSource() {
        
        let shouldDisplayAvatar = AppSettings.shared.displayAvatar
        let displayAvatar = SettingTableModel(title: "显示头像", value: SettingValue.switchButton(shouldDisplayAvatar, tagDisplayAvatar))
        dataSource.append(SettingTableSectionModel(title: nil, items: [displayAvatar]))
    }
    
    @objc func switchValueDidChanged(_ sender: UISwitch) {
        switch sender.tag {
        case tagDisplayAvatar:
            AppSettings.shared.displayAvatar = sender.isOn
        default:
            break
        }
    }
}

extension DisplaySettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let group = dataSource[section]
        return group.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(SettingViewCell.self), for: indexPath)
        let group = dataSource[indexPath.section]
        let item = group.items[indexPath.row]
        
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
            cell.accessoryView = switchButton
            switchButton.addTarget(self, action: #selector(switchValueDidChanged(_:)), for: .valueChanged)
        }
        cell.textLabel?.text = item.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}
