//
//  UserProfileViewController.swift
//  V2EX
//
//  Created by alexiscn on 2018/12/2.
//  Copyright © 2018 alexiscn. All rights reserved.
//

import UIKit
import MJRefresh
import WXActionSheet

enum UserProfileSections: Int {
    case topics = 0
    case comments = 1
    
    var title: String? {
        switch self {
        case .topics:
            return Strings.ProfileHisTopics
        case .comments:
            return Strings.ProfileHisComments
        }
    }
}

class UserProfileViewController: UIViewController {
 
    private let username: String
    private var headerView: UserProfileHeaderView?
    private var loadingIndicator: UIActivityIndicatorView!
    private var tableView: UITableView!
    private var profile: UserProfileResponse?
    
    init(username: String) {
        self.username = username
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupLoadingView()
        loadUserProfile()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = username
        let moreBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_more_24x24_"), style: .done, target: self, action: #selector(moreBarButtonItemTapped(_:)))
        navigationItem.rightBarButtonItem = moreBarButtonItem
    }
    
    @objc private func moreBarButtonItemTapped(_ sender: Any) {
        let actionSheet = WXActionSheet(cancelButtonTitle: Strings.Cancel)
        let followTitle = (profile?.info?.hasFollowed ?? false) ? Strings.ProfileUnFollow: Strings.ProfileFollow
        actionSheet.add(WXActionSheetItem(title: followTitle, handler: { [weak self] _ in
            self?.handleFollowButton()
        }))
        
        let blockTitle = (profile?.info?.hasBlocked ?? false) ? Strings.ProfileUnBlock: Strings.ProfileBlock
        actionSheet.add(WXActionSheetItem(title: blockTitle, handler: { [weak self] _ in
            self?.handleBlockButton()
        }))
        actionSheet.add(WXActionSheetItem(title: Strings.Report, handler: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                HUD.show(message: "举报成功，我们会及时处理你的举报")
            })
        }))
        actionSheet.show()
    }
    
    private func setupLoadingView() {
        loadingIndicator = UIActivityIndicatorView(style: Theme.current.activityIndicatorViewStyle)
        view.addSubview(loadingIndicator)
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -60)
        ])
        loadingIndicator.startAnimating()
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
        tableView.register(UserProfileSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: UserProfileSectionHeaderView.identifier)
        view.addSubview(tableView)
        tableView.tableFooterView = UIView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])

        let headerView = UserProfileHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 150.0))
        tableView.tableHeaderView = headerView
        self.headerView = headerView
    }
    
    private func loadUserProfile() {
        let endPoint = EndPoint.memberProfile(username)
        V2SDK.request(endPoint, parser: UserProfileParser.self) { [weak self] (response: V2Response<UserProfileResponse>) in
            self?.loadingIndicator.stopAnimating()
            switch response {
            case .success(let profileRes):
                self?.profile = profileRes
                self?.tableView.reloadData()
                if let info = profileRes.info {
                    self?.headerView?.update(info: info)
                }
            case .error(let error):
                HUD.show(message: error.description)
            }
        }
    }
    
    private func handleViewAllButtonTapped(section: Int) {
        if section == 0 {
            let viewModel = UserTopicViewModel(username: username, avatarURL: profile?.info?.avatarURL)
            let controller = ListViewController(viewModel: viewModel)
            navigationController?.pushViewController(controller, animated: true)
        } else {
            let viewModel = UserReplyViewModel(username: username, avatarURL: profile?.info?.avatarURL)
            let controller = ListViewController(viewModel: viewModel)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension UserProfileViewController {
    
    fileprivate func handleFollowButton() {
        if !AppContext.current.isLogined {
            HUD.show(message: Strings.LoginRequired)
            return
        }
        guard let info = profile?.info, let url = info.followURL else {
            return
        }
        V2SDK.request(url: url) { [weak self] (response: V2Response<OperationResponse>) in
            switch response {
            case .success(_):
                self?.loadUserProfile()
                let message = info.hasFollowed ? Strings.ProfileUnFollowSuccess: Strings.ProfileFollowSuccess
                HUD.show(message: message)
            case .error(let error):
                HUD.show(message: error.description)
            }
        }
    }
    
    fileprivate func handleBlockButton() {
        if !AppContext.current.isLogined {
            HUD.show(message: Strings.LoginRequired)
            return
        }
        guard let info = profile?.info, let url = info.blockURL else {
            return
        }
        
        V2SDK.request(url: url) { [weak self] (response: V2Response<OperationResponse>) in
            switch response {
            case .success(_):
                self?.loadUserProfile()
                let message = info.hasBlocked ? Strings.ProfileUnBlockSuccess: Strings.ProfileBlockSuccess
                HUD.show(message: message)
            case .error(let error):
                HUD.show(message: error.description)
            }
        }
    }
    
}


// MARK: - UITableViewDataSource, UITableViewDelegate
extension UserProfileViewController: UITableViewDataSource, UITableViewDelegate {
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
            cell.backgroundColor = .clear
            let comment = profile.comments[indexPath.row]
            cell.update(comment)
            cell.topicHandler = { [weak self] in
                let controller = TopicDetailViewController(url: comment.originTopicURL, title: comment.originTopicTitle)
                self?.navigationController?.pushViewController(controller, animated: true)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let profile = profile else { return 0.0 }
        
        if indexPath.section == 0 {
            var topic = profile.topics[indexPath.row]
            return TimelineViewCell.heightForRowWithTopic(&topic)
        } else {
            var comment = profile.comments[indexPath.row]
            return UserCommentViewCell.heightForComment(&comment)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let profile = profile else { return 0.0 }
        if section == 0, profile.topics.count == 0 { return 0.0 }
        if section == 1, profile.comments.count == 0 { return 0.0 }
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: UserProfileSectionHeaderView.identifier) as? UserProfileSectionHeaderView
        let title = UserProfileSections(rawValue: section)?.title
        header?.update(title: title, section: section)
        header?.viewAllButtonHandler = { [weak self] section in
            self?.handleViewAllButtonTapped(section: section)
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
