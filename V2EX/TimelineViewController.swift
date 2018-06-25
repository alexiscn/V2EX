//
//  TimelineViewController.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/6/22.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import V2SDK

class TimelineViewController: UIViewController {

    fileprivate var dataSource: [Topic] = []
    
    fileprivate var tableView: UITableView!
    
    fileprivate var currentPage: Int = 0
    
    fileprivate var currentTab: V2Tabs = .hot
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "V2EX"
        setupTableView()
        
        loadData()
    }
    
    func switchTo(_ menu: TabMenu) {
        currentTab = menu.tab
        currentPage = 0
        loadData()
    }
    
    private func loadData(isLoadMore: Bool = false) {
        if isLoadMore {
            currentPage += 1
        } else {
            currentPage = 0
        }
        V2SDK.getTopics(tab: currentTab, page: currentPage) { (topics, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                } else {
                    if self.currentPage == 0 {
                        self.dataSource = topics
                    } else {
                        self.dataSource.append(contentsOf: topics)
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(TimelineViewCell.self, forCellReuseIdentifier: NSStringFromClass(TimelineViewCell.self))
        view.addSubview(tableView)
    }
}

extension TimelineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(TimelineViewCell.self), for: indexPath) as! TimelineViewCell
        let topic = dataSource[indexPath.row]
        cell.update(topic)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var topic = dataSource[indexPath.row]
        return TimelineViewCell.heightForRowWithTopic(&topic)
    }
}
