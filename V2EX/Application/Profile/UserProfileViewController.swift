//
//  UserProfileViewController.swift
//  V2EX
//
//  Created by xushuifeng on 2018/12/2.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import SnapKit
import MJRefresh

enum UserProfileSections: Int {
    case topics = 0
    case comments = 1
    
    var title: String? {
        switch self {
        case .topics:
            return NSLocalizedString("Ta创建的主题", comment: "")
        case .comments:
            return NSLocalizedString("Ta的最近回复", comment: "")
        }
    }
}

class UserProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
 
    private let username: String
    
    private var headerView: UserProfileHeaderView?
    
    let headerHeight: CGFloat = 150.0
    
    init(username: String) {
        self.username = username
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var tableView: UITableView!
    
    private var profile: UserProfileResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadUserProfile()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let moreBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_more_24x24_"), style: .done, target: self, action: #selector(moreBarButtonItemTapped(_:)))
        navigationItem.rightBarButtonItem = moreBarButtonItem
    }
    
    @objc private func moreBarButtonItemTapped(_ sender: Any) {
        let actionSheet = ActionSheet(title: NSLocalizedString("更多操作", comment: ""), message: nil)
        actionSheet.addAction(Action(title: NSLocalizedString("举报", comment: ""), style: .default, handler: { _ in
            
        }))
        actionSheet.addAction(Action(title: NSLocalizedString("取消", comment: ""), style: .cancel, handler: { _ in
            
        }))
        actionSheet.show()
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.backgroundColor = Theme.current.backgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.register(TimelineViewCell.self, forCellReuseIdentifier: NSStringFromClass(TimelineViewCell.self))
        tableView.register(UserCommentViewCell.self, forCellReuseIdentifier: NSStringFromClass(UserCommentViewCell.self))
        view.addSubview(tableView)
        tableView.tableFooterView = UIView()

        let headerView = UserProfileHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: headerHeight))
        tableView.tableHeaderView = headerView
        self.headerView = headerView
    }
    
    private func loadUserProfile() {
        V2SDK.getUserProfile(name: username) { [weak self] (profileRes, error) in
            self?.profile = profileRes
            self?.tableView.reloadData()
            if let info = profileRes?.info {
                self?.headerView?.update(info: info)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return profile?.topics.count ?? 0
        } else {
            return profile?.comments.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let profile = profile else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(TimelineViewCell.self), for: indexPath) as! TimelineViewCell
            cell.backgroundColor = .clear
            let topic = profile.topics[indexPath.row]
            cell.update(topic)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UserCommentViewCell.self), for: indexPath) as! UserCommentViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let profile = profile else { return 0.0 }
        
        if indexPath.section == 0 {
            var topic = profile.topics[indexPath.row]
            return TimelineViewCell.heightForRowWithTopic(&topic)
        } else {
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let profile = profile else { return 0.0 }
        if section == 0, profile.topics.count == 0 { return 0.0 }
        if section == 1, profile.comments.count == 0 { return 0.0 }
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: 50.0)))
        header.backgroundColor = Theme.current.backgroundColor
        let label = UILabel(frame: .zero)
        label.text = UserProfileSections(rawValue: section)?.title
        label.textColor = Theme.current.subTitleColor
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        header.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        let viewAllButton = UIButton(type: .system)
        viewAllButton.setTitle("See all", for: .normal)
        viewAllButton.setTitleColor(Theme.current.titleColor, for: .normal)
        header.addSubview(viewAllButton)
        viewAllButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
        }
        
        return header
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let profile = profile else { return }
        
        if indexPath.section == 0 {
            let topic = profile.topics[indexPath.row]
            let controller = TopicDetailViewController(url: topic.url, title: topic.title)
            navigationController?.pushViewController(controller, animated: true)
        } else if indexPath.section == 1 {
            
        }
    }
}
