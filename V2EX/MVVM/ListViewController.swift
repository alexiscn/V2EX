//
//  ListViewController.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/12/13.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import MJRefresh

class ListViewController<T: ListViewModel>: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var tableView: UITableView!
    
    private var viewModel: T

    init(vm: T) {
        self.viewModel = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        tableView.mj_header.beginRefreshing()
    }
    
    fileprivate func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.register(viewModel.cellClass, forCellReuseIdentifier: NSStringFromClass(viewModel.cellClass))
        view.addSubview(tableView)
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.loadData(isLoadMore: false)
        })
        header?.activityIndicatorViewStyle = Theme.current.activityIndicatorViewStyle
        header?.stateLabel.isHidden = true
        header?.stateLabel.textColor = Theme.current.subTitleColor
        header?.lastUpdatedTimeLabel.isHidden = true
        tableView.mj_header = header
        
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            self?.loadData(isLoadMore: true)
        })
        footer?.activityIndicatorViewStyle = Theme.current.activityIndicatorViewStyle
        footer?.isRefreshingTitleHidden = true
        footer?.triggerAutomaticallyRefreshPercent = 0.8
        footer?.stateLabel.textColor = Theme.current.subTitleColor
        footer?.stateLabel.isHidden = true
        tableView.mj_footer = footer
    }
    
    private func loadData(isLoadMore: Bool) {
        
        viewModel.loadData(isLoadMore: isLoadMore) { [weak self] (info) in
            if info.isLoadMore {
                self?.tableView.mj_footer.endRefreshing()
                if !info.canLoadMore {
                    self?.tableView.mj_footer.resetNoMoreData()
                }
            } else {
                self?.tableView.mj_header.endRefreshing()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSouce.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = NSStringFromClass(viewModel.cellClass)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.backgroundColor = .clear
        return cell
    }
}
