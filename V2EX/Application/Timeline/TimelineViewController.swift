//
//  TimelineViewController.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/6/22.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import V2SDK
import MJRefresh

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
        V2SDK.getTopicList(tab: currentTab, page: currentPage) { [weak self] (topics, error) in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                if let error = error {
                    print(error)
                } else {
                    if strongSelf.currentPage == 0 {
                        strongSelf.dataSource = topics
                    } else {
                        strongSelf.dataSource.append(contentsOf: topics)
                    }
                    strongSelf.tableView.reloadData()
                }
                if isLoadMore {
                    strongSelf.tableView.mj_footer.endRefreshing()
                } else {
                    strongSelf.tableView.mj_header.endRefreshing()
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
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.loadData()
        })
        header?.lastUpdatedTimeLabel.isHidden = true
        tableView.mj_header = header
        
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            self?.loadData(isLoadMore: true)
        })
        tableView.mj_footer = footer
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let detailViewController = TopicDetailViewController()
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
