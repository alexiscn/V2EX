//
//  NotificationsViewController.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/12/10.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import MJRefresh

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var tableView: UITableView!
    
    private var dataSource: [MessageNotification] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = Strings.Notifications
        
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
        tableView.register(NotificationViewCell.self, forCellReuseIdentifier: NSStringFromClass(NotificationViewCell.self))
        view.addSubview(tableView)
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.loadNotifications()
        })
        header?.activityIndicatorViewStyle = Theme.current.activityIndicatorViewStyle
        header?.stateLabel.isHidden = true
        header?.stateLabel.textColor = Theme.current.subTitleColor
        header?.lastUpdatedTimeLabel.isHidden = true
        tableView.mj_header = header
        
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            self?.loadNotifications(isLoadMore: true)
        })
        footer?.activityIndicatorViewStyle = Theme.current.activityIndicatorViewStyle
        footer?.isRefreshingTitleHidden = true
        footer?.triggerAutomaticallyRefreshPercent = 0.8
        footer?.stateLabel.textColor = Theme.current.subTitleColor
        footer?.stateLabel.isHidden = true
        tableView.mj_footer = footer
    }
    
    private func loadNotifications(isLoadMore: Bool = false) {
        let endPoint = EndPoint.notifications()
        V2SDK.request(endPoint, parser: NotificationParser.self) { (response: V2Response<NotificationResponse>) in
            switch response {
            case .success(let notificationRes):
                print(notificationRes.page)
            case .error(let error):
                HUD.show(message: error.description)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(NotificationViewCell.self), for: indexPath) as! NotificationViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var message = dataSource[indexPath.row]
        return NotificationViewCell.heightForNotification(&message)
    }
}


