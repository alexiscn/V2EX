//
//  TimelineViewController.swift
//  V2EX
//
//  Created by alexiscn on 2018/6/22.
//  Copyright © 2018 alexiscn. All rights reserved.
//

import UIKit
import MJRefresh

class TimelineViewController: UIViewController {
    
    fileprivate var tableView: UITableView!
    
    fileprivate var viewModel: TimelineViewModel
    
    init(viewModel: TimelineViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        if let vm = viewModel as? TabTimelineViewModel {
            vm.delegate = self
        } else if let vm = viewModel as? NodeTimelineViewModel {
            vm.delegate = self
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.current.backgroundColor
        title = viewModel.title
        
        setupTableView()
        refresh()
        ThemeManager.shared.observeThemeUpdated { [weak self] _ in
            self?.updateTheme()
        }
    }
    
    func updateTheme() {
        view.backgroundColor = Theme.current.backgroundColor
        if let header = tableView.mj_header as? MJRefreshNormalHeader {
            header.stateLabel?.textColor = Theme.current.subTitleColor
            header.loadingView?.style = Theme.current.activityIndicatorViewStyle
        }
        if let footer = tableView.mj_footer as? MJRefreshAutoNormalFooter {
            footer.stateLabel?.textColor = Theme.current.subTitleColor
            footer.loadingView?.style = Theme.current.activityIndicatorViewStyle
        }
    }
    
    func updateTab(_ tab: V2Tab) {
        
        UIView.animate(withDuration: 0.3, animations: {
            if self.viewModel.dataSource.count > 0 {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }) { _ in
        
            let vm = TabTimelineViewModel(tab: tab)
            vm.delegate = self
            vm.dataSource = self.viewModel.dataSource
            self.viewModel = vm
            self.title = vm.title
            self.refresh()
        }
    }
    
    func updateNode(_ node: Node) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }) { _ in
            let vm = NodeTimelineViewModel(node: node)
            vm.delegate = self
            vm.dataSource = self.viewModel.dataSource
            self.viewModel = vm
            self.title = vm.title
            self.refresh()
        }
    }

    private func refresh(){
        if tableView != nil {
            tableView.mj_header?.beginRefreshing()
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
            self?.viewModel.loadData(isLoadMore: false)
        }
        tableView.mj_footer = V2RefreshFooter { [weak self] in
            self?.viewModel.loadData(isLoadMore: true)
        }
    }
}

extension TimelineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(TimelineViewCell.self), for: indexPath) as! TimelineViewCell
        cell.backgroundColor = .clear
        let topic = viewModel.dataSource[indexPath.row]
        cell.update(topic)
        cell.nodeHandler = { [weak topic, weak self] in
            if let topic = topic, let name = topic.nodeName, let title = topic.nodeTitle {
                let node = Node.nodeWithName(name, title: title)
                let viewModel = NodeTimelineViewModel(node: node)
                let controller = TimelineViewController(viewModel: viewModel)
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
        var topic = viewModel.dataSource[indexPath.row]
        return TimelineViewCell.heightForRowWithTopic(&topic)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let topic = viewModel.dataSource[indexPath.row]
        let detailViewController = TopicDetailViewController(url: topic.url, title: topic.title)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension TimelineViewController: TimelineViewModelDelegate {
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func endRefreshing() {
        tableView.mj_header?.endRefreshing()
        tableView.mj_footer?.endRefreshing()
    }
    
    func setNoMoreData() {
        if let footer = tableView.mj_footer as? V2RefreshFooter {
            if viewModel is TabTimelineViewModel {
                footer.setTitle(Strings.TabRecentTips, for: .noMoreData)
            } else {
                footer.setTitle(Strings.NoMoreData, for: .noMoreData)
            }
            footer.endRefreshingWithNoMoreData()
            footer.stateLabel?.isHidden = false
        }
    }
    
    func resetNoMoreData() {
        tableView.mj_footer?.resetNoMoreData()
    }
}
