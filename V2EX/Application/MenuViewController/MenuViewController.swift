//
//  MenuViewController.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/11/8.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import V2SDK
import SnapKit

class MenuViewController: UIViewController {

    var selectionChangedHandler: ((_ tab: V2Tab) -> Void)?
    
    var tableView: UITableView!
    
    var dataSource: [V2Tab] = V2Tab.tabs()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView = UITableView(frame: .zero)
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(MenuTableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.bottom.equalToSuperview().offset(-100)
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
        let menu = dataSource[indexPath.row]
        cell.updateMenu(menu)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menu = dataSource[indexPath.row]
        selectionChangedHandler?(menu)
    }
}
