//
//  SettingsViewController.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/6/26.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

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
        
        let viewOption = SettingTableModel(title: "浏览偏好设置") {
            
        }
        let viewOption2 = SettingTableModel(title: "浏览偏好设置") {
            
        }
        let viewOption3 = SettingTableModel(title: "浏览偏好设置") {
            
        }
        let viewOption4 = SettingTableModel(title: "浏览偏好设置") {
            
        }
        let generalSection = SettingTableSectionModel(title: nil, items: [viewOption, viewOption2, viewOption3, viewOption4])
        dataSource.append(generalSection)
        
        let openSource = SettingTableModel(title: "Open Source") { [weak self] in
            let controller = OpenSourceViewController()
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        let about = SettingTableModel(title: "关于V2EX") {
            
        }
        let aboutSection = SettingTableSectionModel(title: "关于", items: [openSource, about])
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
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(SettingViewCell.self), for: indexPath)
        cell.backgroundColor = Theme.current.cellBackgroundColor
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.textColor = Theme.current.titleColor
        
        let group = dataSource[indexPath.section]
        let item = group.items[indexPath.row]
        cell.textLabel?.text = item.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let group = dataSource[indexPath.section]
        let item = group.items[indexPath.row]
        item.action?()
    }
    
}
