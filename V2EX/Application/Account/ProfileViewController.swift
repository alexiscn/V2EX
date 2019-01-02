//
//  ProfileViewController.swift
//  V2EX
//
//  Created by xushuifeng on 2018/8/13.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import WXActionSheet

enum ProfileSections: Int {
    case topics = 0
    case comments = 1
    
    var title: String? {
        switch self {
        case .topics:
            return Strings.ProfileMyTopics
        case .comments:
            return Strings.ProfileMyComments
        }
    }
}

class ProfileViewController: UIViewController {
    
    private var tableView: UITableView!
    private var loadingIndicator: UIActivityIndicatorView!
    private var profile: UserProfileResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.current.backgroundColor
        setupNavigationBar()
        setupLoadingView()
        setupTableView()
        loadUserProfile()
    }
    
    private func setupNavigationBar() {
        let moreBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_more_24x24_"), style: .done, target: self, action: #selector(moreBarButtonItemTapped(_:)))
        navigationItem.rightBarButtonItem = moreBarButtonItem
    }
    
    private func loadUserProfile() {
        guard let username = AppContext.current.account?.username else {
            return
        }
        let endPoint = EndPoint.memberProfile(username)
        V2SDK.request(endPoint, parser: UserProfileParser.self) { [weak self] (response: V2Response<UserProfileResponse>) in
            self?.loadingIndicator.stopAnimating()
            switch response {
            case .success(let profileRes):
                self?.profile = profileRes
                self?.tableView.reloadData()
//                if let info = profileRes.info {
//                    self?.headerView?.update(info: info)
//                }
            case .error(let error):
                HUD.show(message: error.description)
            }
        }
    }
    
    private func setupLoadingView() {
        loadingIndicator = UIActivityIndicatorView(style: Theme.current.activityIndicatorViewStyle)
        view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(60)
        }
        loadingIndicator.startAnimating()
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView.backgroundColor = .clear
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.showsHorizontalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(TimelineViewCell.self, forCellReuseIdentifier: NSStringFromClass(TimelineViewCell.self))
        tableView.register(UserCommentViewCell.self, forCellReuseIdentifier: NSStringFromClass(UserCommentViewCell.self))
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        
        let header = ProfileHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 200))
        header.myNodesActionHandler = { [weak self] in
            self?.viewMyNodes()
        }
        header.myTopicsActionHandler = { [weak self] in
            self?.viewMyTopics()
        }
        header.myFollowingActionHandler = { [weak self] in
            self?.viewMyFollowings()
        }
        header.balanceActionHandler = { [weak self] in
            let viewModel = BalanceViewModel()
            let controller = ListViewController(viewModel: viewModel)
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        tableView.tableHeaderView = header
        header.update()
    }
    
    private func viewMyNotifications() {
        let viewModel = NotificationsViewModel()
        let controller = ListViewController(viewModel: viewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func viewMyNodes() {
        let viewModel = MyNodesViewModel()
        let controller = ListViewController(viewModel: viewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func viewMyTopics() {
        let viewModel = MyFavoritedTopicsViewModel()
        let controller = ListViewController(viewModel: viewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func viewMyFollowings() {
        let viewModel = MyFollowingViewModel()
        let controller = ListViewController(viewModel: viewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc private func moreBarButtonItemTapped(_ sender: Any) {
        let actionSheet = WXActionSheet(cancelButtonTitle: Strings.Cancel)
        actionSheet.add(WXActionSheetItem(title: Strings.SettingsLogout, handler: { [weak self] _ in
            self?.handleUserLogout()
        }))
        actionSheet.show()
       
    }
    
    private func handleUserLogout() {
        let alert = UIAlertController(title: Strings.SettingsLogoutPrompt, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.OK, style: .default, handler: { [weak self] _ in
            self?.doLogout()
        }))
        alert.addAction(UIAlertAction(title: Strings.Cancel, style: .cancel, handler: { _ in
            
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func doLogout() {
        AppContext.current.doLogout()
        navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func notifications() {
        let viewModel = NotificationsViewModel()
        let controller = ListViewController(viewModel: viewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        guard profile != nil else { return 0.0 }
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: 50.0)))
        header.backgroundColor = Theme.current.backgroundColor
        let label = UILabel(frame: .zero)
        label.text = ProfileSections(rawValue: section)?.title
        label.textColor = Theme.current.subTitleColor
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        header.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
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
