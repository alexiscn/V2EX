//
//  RightMenuViewController.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/11/20.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class RightMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var tableView: UITableView!
    private var dataSource: [V2Tab] = V2Tab.tabs()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.current.backgroundColor
        setupTableView()
    }
    
    func updateDataSource(_ tabs: [V2Tab]) {
        dataSource = tabs
        if tableView != nil {
            tableView.reloadData()
        }
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
            make.bottom.equalToSuperview().offset(-150)
        }
        tableView.reloadData()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
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
}
