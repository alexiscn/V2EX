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
    
    fileprivate let tab: V2Tab
    
    init(tab: V2Tab) {
        self.tab = tab
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "V2EX"
        setupTableView()
        loadData()
    }

    private func loadData() {
        
        DispatchQueue.global().async {
            
            let topics = V2DataManager.shared.loadTopics(forTab: self.tab.key)
            if topics.count > 0 {
                DispatchQueue.main.async {
                    self.dataSource = topics
                    self.tableView.reloadData()
                }
            }
            V2SDK.getTopicList(tab: self.tab) { [weak self] (topics, error) in
                DispatchQueue.main.async {
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.dataSource = topics
                    strongSelf.tableView.reloadData()
                    strongSelf.tableView.mj_header.endRefreshing()
                    if strongSelf.tab.key == V2Tab.allTab.key {
                        strongSelf.tableView.mj_footer.resetNoMoreData()
                    } else {
                        strongSelf.tableView.mj_footer.endRefreshingWithNoMoreData()
                    }
                }
            }
        }
    }
    
    fileprivate func loadMoreData() {
        
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
            self?.loadMoreData()
        })
        footer?.stateLabel.isHidden = true
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
        
        let topic = dataSource[indexPath.row]
        let detailViewController = TopicDetailViewController(url: topic.url)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
