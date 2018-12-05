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

    var topicSelectionHandler: ((Topic?) -> Void)?
    
    var userTappedHandler: ((String?) -> Void)?
    
    fileprivate var dataSource: [Topic] = []
    
    fileprivate var tableView: UITableView!
    
    fileprivate var currentPage: Int = 0
    
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
        
        setupTableView()
        updateTitle()
        loadData()
    }
    
    private func updateTitle() {
        switch type {
        case .tab:
            navigationItem.title = tab.title
        case .node:
            navigationItem.title = "#\(node.title)"
        }
    }
    
    func updateTab(_ tab: V2Tab) {
        self.type = .tab
        self.tab = tab
        if dataSource.count > 0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }) { _ in
                self.loadData(loadCache: false)
            }
        } else {
            loadData()
        }
    }
    
    func updateNode(_ node: Node) {
        self.type = .node
        self.node = node
        self.nodeDetail = nil
        updateTitle()
        if dataSource.count > 0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }) { _ in
                self.loadData(loadCache: false)
            }
        } else {
            loadData()
        }
    }

    private func loadData(loadCache: Bool = true) {
        tableView.mj_header.beginRefreshing()
        switch type {
        case .tab:
            loadTopicList()
        case .node:
            loadNodeTopics()
        }
    }
    
    private func loadTopicList(loadCache: Bool = true) {
        DispatchQueue.global().async {
            if loadCache {
                DispatchQueue.main.async {
                    let topics = V2DataManager.shared.loadTopics(forTab: self.tab.key)
                    if topics.count > 0 {
                        self.dataSource = topics
                        self.tableView.reloadData()
                    }
                }
            }
            let key = self.tab.key
            V2SDK.request(.tab(key), parser: TabParser.self, completion: { [weak self] (topics: [Topic]?, error) in
                DispatchQueue.main.async {
                    guard let strongSelf = self, let topics = topics else {
                        return
                    }
                    strongSelf.dataSource = topics
                    strongSelf.tableView.reloadData()
                    strongSelf.tableView.mj_header.endRefreshing()
                    if strongSelf.tab.key == V2Tab.allTab.key {
                        strongSelf.tableView.mj_footer.resetNoMoreData()
                    } else {
                        strongSelf.setNoMoreData()
                    }
                    V2DataManager.shared.saveTopics(topics, forTab: key)
                }
            })
        }
    }
    
    fileprivate func loadMoreData() {
        if type == .node {
            loadNodeTopics(isLoadMore: true)
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
        V2SDK.request(endPoint, parser: NodeTopicsParser.self) { [weak self] (nodeDetail: NodeDetail?, error) in
            guard let strongSelf = self, let nodeDetail = nodeDetail else { return }
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
        }
    }
    
    fileprivate func setNoMoreData() {
        if let footer = tableView.mj_footer as? MJRefreshAutoNormalFooter {
            switch type {
            case .node:
                footer.setTitle(NSLocalizedString("没有更多了", comment: ""), for: .noMoreData)
            case .tab:
                footer.setTitle(NSLocalizedString("只有节点才能加载更多", comment: ""), for: .noMoreData)
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
        tableView.backgroundColor = Theme.current.backgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.register(TimelineViewCell.self, forCellReuseIdentifier: NSStringFromClass(TimelineViewCell.self))
        view.addSubview(tableView)
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.loadData()
        })
        header?.activityIndicatorViewStyle = Theme.current.activityIndicatorViewStyle
        header?.stateLabel.isHidden = true
        header?.stateLabel.textColor = Theme.current.subTitleColor
        header?.lastUpdatedTimeLabel.isHidden = true
        tableView.mj_header = header
        
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            self?.loadMoreData()
        })
        footer?.activityIndicatorViewStyle = Theme.current.activityIndicatorViewStyle
        footer?.isRefreshingTitleHidden = true
        footer?.triggerAutomaticallyRefreshPercent = 0.8
        footer?.stateLabel.textColor = Theme.current.subTitleColor
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
        cell.backgroundColor = .clear
        let topic = dataSource[indexPath.row]
        cell.update(topic)
        cell.nodeHandler = { [weak topic, weak self] in
            self?.topicSelectionHandler?(topic)
        }
        cell.avatarHandler = { [weak topic, weak self] in
            self?.userTappedHandler?(topic?.username)
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
