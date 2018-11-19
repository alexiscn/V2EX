//
//  MenuViewController.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/11/8.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import SnapKit

class MenuViewController: UIViewController {

    var selectionChangedHandler: ((_ tab: V2Tab) -> Void)?
    
    private var tableView: UITableView!
    private var settingButton: UIButton!
    private var dataSource: [V2Tab] = V2Tab.tabs()
    private var isFirstViewDidAppear = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.current.backgroundColor
        setupTableView()
        setupSettingButton()
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
            make.top.equalToSuperview().offset(150)
            make.bottom.equalToSuperview().offset(-100)
        }
        tableView.reloadData()
    }
    
    private func setupSettingButton() {
        settingButton = UIButton(type: .system)
        settingButton.tintColor = Theme.current.titleColor
        settingButton.setImage(UIImage(named: "icon_settings_24x24_"), for: .normal)
        view.addSubview(settingButton)
        
        settingButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.bottom.equalToSuperview().offset(-30)
            make.trailing.equalToSuperview().offset(-30)
        }
        settingButton.addTarget(self, action: #selector(settingButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc private func settingButtonTapped(_ sender: Any) {
        let settingsController = UIStoryboard.settings.instantiateViewController(ofType: SettingsViewController.self)
        let nav = SettingsNavigationController(rootViewController: settingsController)
        present(nav, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isFirstViewDidAppear {
            isFirstViewDidAppear = true
            if let index = self.dataSource.firstIndex(where: { $0.title == "最热" }) {
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
    }
}
