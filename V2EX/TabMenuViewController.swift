//
//  TabMenuViewController.swift
//  V2EX
//
//  Created by xushuifeng on 2018/6/26.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import V2SDK

struct TabMenu {
    let tab: V2Tabs
    let title: String
}

class TabMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var didSelectTabHandler: ((TabMenu) -> Void)?
    
    fileprivate var dataSource: [TabMenu] = []
    
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
        
        dataSource.removeAll()
        dataSource.append(TabMenu(tab: .tech, title: "程序员"))
        dataSource.append(TabMenu(tab: .creative, title: "创意"))
        dataSource.append(TabMenu(tab: .play, title: "好玩"))
        dataSource.append(TabMenu(tab: .apple, title: "Apple"))
        dataSource.append(TabMenu(tab: .jobs, title: "酷工作"))
        dataSource.append(TabMenu(tab: .deals, title: "交易"))
        dataSource.append(TabMenu(tab: .city, title: "城市"))
        dataSource.append(TabMenu(tab: .qna, title: "问与答"))
        dataSource.append(TabMenu(tab: .hot, title: "最热"))
        dataSource.append(TabMenu(tab: .all, title: "全部"))
        dataSource.append(TabMenu(tab: .r2, title: "R2"))
        
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
