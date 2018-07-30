//
//  TabMenuViewController.swift
//  V2EX
//
//  Created by xushuifeng on 2018/6/26.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import V2SDK

class TabMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var didSelectTabHandler: ((V2Tab) -> Void)?
    
    fileprivate var dataSource: [V2Tab] = V2Tab.tabs()
    
    fileprivate var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
        let menu = dataSource[indexPath.row]
        cell.textLabel?.text = menu.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let menu = dataSource[indexPath.row]
        didSelectTabHandler?(menu)
    }
}
