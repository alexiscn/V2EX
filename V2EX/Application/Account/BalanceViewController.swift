//
//  BalanceViewController.swift
//  V2EX
//
//  Created by xushuifeng on 2018/12/9.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import MJRefresh

class BalanceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var tableView: UITableView!
    
    private var dataSource: [Balance] = []
    
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
        tableView.register(BalanceViewCell.self, forCellReuseIdentifier: NSStringFromClass(BalanceViewCell.self))
        view.addSubview(tableView)
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.loadBalances()
        })
        header?.activityIndicatorViewStyle = Theme.current.activityIndicatorViewStyle
        header?.stateLabel.isHidden = true
        header?.stateLabel.textColor = Theme.current.subTitleColor
        header?.lastUpdatedTimeLabel.isHidden = true
        tableView.mj_header = header
        
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            self?.loadBalances(isLoadMore: true)
        })
        footer?.activityIndicatorViewStyle = Theme.current.activityIndicatorViewStyle
        footer?.isRefreshingTitleHidden = true
        footer?.triggerAutomaticallyRefreshPercent = 0.8
        footer?.stateLabel.textColor = Theme.current.subTitleColor
        footer?.stateLabel.isHidden = true
        tableView.mj_footer = footer
    }
    
    private func loadBalances(isLoadMore: Bool = false) {
        let endPoint = EndPoint.balance(page: 1)
        V2SDK.request(endPoint, parser: BalanceParser.self) { (response: V2Response<BalanceResponse>) in
            
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(BalanceViewCell.self), for: indexPath) as! BalanceViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}
