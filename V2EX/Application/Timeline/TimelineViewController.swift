//
//  TimelineViewController.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/6/22.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import MJRefresh

enum TimelineType {
    case tab
    case node
}

class TimelineViewController: UIViewController {

    fileprivate var dataSource: [Topic] = []
    
    fileprivate var tableView: UITableView!
    
    fileprivate var currentPage: Int = 0
    fileprivate var recentPage: Int = 1
    
    fileprivate var tab: V2Tab = V2Tab.hotTab
    
    fileprivate var type: TimelineType = .tab
    
    fileprivate var node: Node = Node.default
    fileprivate var nodeDetail: NodeDetail?
    
    init(tab: V2Tab) {
        self.tab = tab
        self.type = .tab
        super.init(nibName: nil, bundle: nil)
    }
    
    init(node: Node) {
        self.node = node
        self.type = .node
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.current.backgroundColor
        setupTableView()
        updateTitle()
        refresh()
        ThemeManager.shared.observeThemeUpdated { [weak self] _ in
            self?.updateTheme()
        }
    }
    
    private func updateTitle() {
        switch type {
        case .tab:
            navigationItem.title = tab.title
        case .node:
            navigationItem.title = "#\(node.title)"
        }
    }
    
    func updateTheme() {
        view.backgroundColor = Theme.current.backgroundColor
        if let header = tableView.mj_header as? MJRefreshNormalHeader {
            header.stateLabel.textColor = Theme.current.subTitleColor
            header.activityIndicatorViewStyle = Theme.current.activityIndicatorViewStyle
        }
        if let footer = tableView.mj_footer as? MJRefreshAutoNormalFooter {
            footer.stateLabel.textColor = Theme.current.subTitleColor
            footer.activityIndicatorViewStyle = Theme.current.activityIndicatorViewStyle
        }
    }
    
    func updateTab(_ tab: V2Tab) {
        self.type = .tab
        self.tab = tab
        updateTitle()
        recentPage = 1
        refreshSwitchingTimeline()
    }
    
    func updateNode(_ node: Node) {
        self.type = .node
        self.node = node
        self.nodeDetail = nil
        updateTitle()
        currentPage = 1
        refreshSwitchingTimeline()
    }
    
    func refreshSwitchingTimeline() {
        if dataSource.count > 0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }) { _ in
                self.refresh()
            }
        } else {
            refresh()
        }
    }
    
    private func refresh(){
        if tableView != nil {
            tableView.mj_header.beginRefreshing()
        }
    }
    
    private func loadTabTopics(isLoadMore: Bool = false) {
        recentPage = isLoadMore ? (recentPage + 1): 1
        
        DispatchQueue.global().async {
            let topics = V2DataManager.shared.loadTopics(forTab: self.tab.key)
            DispatchQueue.main.async {
                if topics.count > 0 {
                    self.dataSource = topics
                    self.tableView.reloadData()
                }
            }
            let key = self.tab.key
            let isRecent = self.tab == V2Tab.recentTab
            let endPoint = isRecent ? EndPoint.recent(self.recentPage): EndPoint.tab(key)
            V2SDK.request(endPoint, parser: TabParser.self, completion: { [weak self] (response: V2Response<[Topic]>) in
                guard let strongSelf = self else { return }
                switch response {
                case .success(let topics):
                    if isLoadMore {
                        for topic in topics {
                            if !strongSelf.dataSource.contains(where: { $0.url == topic.url }) {
                                strongSelf.dataSource.append(topic)
                            }
                        }
                    } else {
                        strongSelf.dataSource = topics
                    }
                    strongSelf.tableView.reloadData()
                    strongSelf.tableView.mj_header.endRefreshing()
                    if strongSelf.tab == V2Tab.recentTab {
                        strongSelf.tableView.mj_footer.resetNoMoreData()
                    } else {
                        strongSelf.setNoMoreData()
                    }
                    topics.forEach { $0.tab = key }
                    V2DataManager.shared.saveTopics(topics, forTab: key)
                case .error(let error):
                    strongSelf.tableView.mj_header.endRefreshing()
                    HUD.show(message: error.description)
                }
            })
        }
    }
    
    fileprivate func loadMoreData() {
        switch type {
        case .node:
            loadNodeTopics(isLoadMore: true)
        case .tab:
            if tab == V2Tab.recentTab {
                loadTabTopics(isLoadMore: true)
            }
        }
    }
    
    fileprivate func loadNodeTopics(isLoadMore: Bool = false) {
        
        let totalPage = nodeDetail?.page ?? Int.max
        if currentPage >= totalPage {
            setNoMoreData()
            return
        }
    
        currentPage = isLoadMore ? (currentPage + 1): 1
                
        let endPoint = EndPoint.node(node.name, page: currentPage)
        V2SDK.request(endPoint, parser: NodeTopicsParser.self) { [weak self] (response: V2Response<NodeDetail>) in
            guard let strongSelf = self else { return }
            switch response {
            case .success(let nodeDetail):
                strongSelf.nodeDetail = nodeDetail
                if isLoadMore {
                    strongSelf.dataSource.append(contentsOf: nodeDetail.topics)
                } else {
                    strongSelf.dataSource = nodeDetail.topics
                }
                
                strongSelf.tableView.reloadData()
                strongSelf.tableView.mj_header.endRefreshing()
                strongSelf.tableView.mj_footer.endRefreshing()
                
                if nodeDetail.topics.count > 0 {
                    strongSelf.tableView.mj_footer.resetNoMoreData()
                } else {
                    strongSelf.setNoMoreData()
                }
            case .error(let error):
                strongSelf.tableView.mj_header.endRefreshing()
                strongSelf.tableView.mj_footer.endRefreshing()
                HUD.show(message: error.description)
            }
        }
    }
    
    fileprivate func setNoMoreData() {
        if let footer = tableView.mj_footer as? V2RefreshFooter {
            switch type {
            case .node:
                footer.setTitle(Strings.NoMoreData, for: .noMoreData)
            case .tab:
                footer.setTitle(Strings.TabRecentTips, for: .noMoreData)
            }
            footer.endRefreshingWithNoMoreData()
            footer.stateLabel.isHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.register(TimelineViewCell.self, forCellReuseIdentifier: NSStringFromClass(TimelineViewCell.self))
        view.addSubview(tableView)
        tableView.mj_header = V2RefreshHeader { [weak self] in
            guard let strongSelf = self else { return }
            switch strongSelf.type {
            case .tab:
                strongSelf.loadTabTopics()
            case .node:
                strongSelf.loadNodeTopics()
            }
        }
        tableView.mj_footer = V2RefreshFooter { [weak self] in
            self?.loadMoreData()
        }
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
        cell.backgroundColor = .clear
        let topic = dataSource[indexPath.row]
        cell.update(topic)
        cell.nodeHandler = { [weak topic, weak self] in
            if let topic = topic, let name = topic.nodeName, let title = topic.nodeTitle {
                let node = Node.nodeWithName(name, title: title)
                let controller = TimelineViewController(node: node)
                self?.navigationController?.pushViewController(controller, animated: true)
            }
        }
        cell.avatarHandler = { [weak topic, weak self] in
            if let name = topic?.username {
                let controller = UserProfileViewController(username: name)
                self?.navigationController?.pushViewController(controller, animated: true)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var topic = dataSource[indexPath.row]
        return TimelineViewCell.heightForRowWithTopic(&topic)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let topic = dataSource[indexPath.row]
        let detailViewController = TopicDetailViewController(url: topic.url, title: topic.title)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
