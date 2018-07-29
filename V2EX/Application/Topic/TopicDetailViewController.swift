//
//  TopicDetailViewController.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/6/26.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import V2SDK

class TopicDetailViewController: UIViewController {

    fileprivate var tableView: UITableView!
    
    fileprivate var comments: [Reply] = []
    
    fileprivate var detail: TopicDetail?
    
    fileprivate let topicURL: URL?
    
    init(url: URL?) {
        topicURL = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupTableView()
        
        if let url = topicURL {
            V2SDK.getTopicDetail(url) { (detail, replyList, error) in
                DispatchQueue.main.async { [weak self] in
                    self?.comments = replyList
                    self?.detail = detail
                    self?.tableView.reloadData()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        tableView.register(TopicCommentViewCell.self, forCellReuseIdentifier: NSStringFromClass(TopicCommentViewCell.self))
        tableView.register(TopicDetailViewCell.self, forCellReuseIdentifier: NSStringFromClass(TopicDetailViewCell.self))
        view.addSubview(tableView)
    }
}

extension TopicDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(TopicDetailViewCell.self), for: indexPath) as! TopicDetailViewCell
            cell.selectionStyle = .none
            if let detail = detail {
                cell.update(detail)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(TopicCommentViewCell.self), for: indexPath) as! TopicCommentViewCell
            cell.selectionStyle = .none
            let reply = comments[indexPath.row]
            cell.update(reply)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if var detail = detail {
                return TopicDetailViewCell.heightForRowWithDetail(&detail)
            }
            return 120.0
        }
        var reply = comments[indexPath.row]
        return TopicCommentViewCell.heightForRowWithReply(&reply)
    }
}
