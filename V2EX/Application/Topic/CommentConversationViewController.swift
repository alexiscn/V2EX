//
//  CommentConversationViewController.swift
//  V2EX
//
//  Created by xu.shuifeng on 2019/1/9.
//  Copyright © 2019 shuifeng.me. All rights reserved.
//

import UIKit

class CommentConversationViewController: UIViewController {

    var dataSource: [Reply] = []
    
    fileprivate var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.current.backgroundColor
        title = Strings.DetailViewConversation
        setupNavigationBar()
        setupTableView()
    }
    
    fileprivate func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.estimatedRowHeight = 0.0
        tableView.backgroundColor = .clear
        tableView.separatorColor = Theme.current.cellHighlightColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(TopicCommentViewCell.self, forCellReuseIdentifier: NSStringFromClass(TopicCommentViewCell.self))
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        configureNavigationBar()
        let leftItem = UIBarButtonItem(title: Strings.Done, style: .done, target: self, action: #selector(leftNavigationButtonTapped(_:)))
        navigationItem.leftBarButtonItem = leftItem
    }
    
    @objc private func leftNavigationButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension CommentConversationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(TopicCommentViewCell.self), for: indexPath) as! TopicCommentViewCell
        cell.backgroundColor = .clear
        let reply = dataSource[indexPath.row]
        cell.update(reply)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var reply = dataSource[indexPath.row]
        return TopicCommentViewCell.heightForRowWithReply(&reply)
    }
    
}
