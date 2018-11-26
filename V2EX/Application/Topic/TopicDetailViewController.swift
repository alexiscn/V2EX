//
//  TopicDetailViewController.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/6/26.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import MJRefresh

class TopicDetailViewController: UIViewController {

    fileprivate var tableView: UITableView!
    fileprivate var loadingIndicator: UIActivityIndicatorView!
    
    fileprivate var comments: [Reply] = []
    fileprivate var detail: TopicDetail?
    fileprivate let topicURL: URL?
    fileprivate let titleString: String?
    fileprivate var currentPage = 1
    
    fileprivate var webViewHeightCaculated = false

    init(url: URL?, title: String?) {
        topicURL = url
        titleString = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = titleString
        view.backgroundColor = Theme.current.backgroundColor
        setupLoadingView()
        setupTableView()
        loadTopicDetail()
    }
    
    private func setupLoadingView() {
        loadingIndicator = UIActivityIndicatorView(style: Theme.current.activityIndicatorViewStyle)
        view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-60)
        }
        loadingIndicator.startAnimating()
    }
    
    private func loadTopicDetail() {
        if let url = topicURL {
            V2SDK.getTopicDetail(url) { (detail, replyList, error) in
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.detail = detail
                    for r in replyList {
                        if r.username == detail?.author {
                            r.isTopicAuthor = true
                        }
                    }
                    
                    strongSelf.comments = replyList
                    
                    strongSelf.tableView.reloadData()
                    if let detail = detail, detail.page == 1 {
                        strongSelf.setNoMoreData()
                    }
                    strongSelf.loadingIndicator.stopAnimating()
                }
            }
        }
    }
    
    private func loadMoreComments() {
        guard let url = topicURL, let detail = detail else { return }
        if currentPage >= detail.page {
            setNoMoreData()
            return
        }
        currentPage += 1
        V2SDK.loadMoreReplies(topicURL: url, page: currentPage) { (replies, error) in
            DispatchQueue.main.async { [weak self] in
                if error == nil, let strongSelf = self {
                    for r in replies {
                        if r.username == strongSelf.detail?.author {
                            r.isTopicAuthor = true
                        }
                    }
                    strongSelf.comments.append(contentsOf: replies)
                    strongSelf.tableView.reloadData()
                    if strongSelf.currentPage == detail.page {
                        strongSelf.setNoMoreData()
                    } else {
                        strongSelf.tableView.mj_footer.endRefreshing()
                    }
                }
            }
        }
    }
    
    private func setNoMoreData() {
        if let footer = tableView.mj_footer as? MJRefreshAutoNormalFooter {
            footer.endRefreshingWithNoMoreData()
            footer.stateLabel.isHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorColor = Theme.current.cellHighlightColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        let footer = MJRefreshAutoNormalFooter { [weak self] in
            self?.loadMoreComments()
        }
        footer?.stateLabel.isHidden = true
        footer?.stateLabel.textColor = Theme.current.subTitleColor
        footer?.setTitle(NSLocalizedString("没有更多回复了", comment: ""), for: .noMoreData)
        footer?.isRefreshingTitleHidden = true
        footer?.triggerAutomaticallyRefreshPercent = 0.9
        footer?.activityIndicatorViewStyle = Theme.current.activityIndicatorViewStyle
        tableView.mj_footer = footer
        
        tableView.register(TopicCommentViewCell.self, forCellReuseIdentifier: NSStringFromClass(TopicCommentViewCell.self))
        tableView.register(TopicDetailViewCell.self, forCellReuseIdentifier: NSStringFromClass(TopicDetailViewCell.self))
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
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
            cell.backgroundColor = .clear
            cell.webViewHeightChangedHandler = { [weak self] height in
                guard let strongSelf = self else {
                    return
                }
                if !strongSelf.webViewHeightCaculated {
                    strongSelf.webViewHeightCaculated = true
                    strongSelf.detail?._rowHeight += height
                    strongSelf.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                }
            }
            cell.topicButtonHandler = { [weak self] in
                if let detail = self?.detail, let name = detail.nodeTag, let title = detail.nodeName {
                    let node = Node.nodeWithName(name, title: title)
                    let controller = TimelineViewController(node: node)
                    self?.navigationController?.pushViewController(controller, animated: true)
                }
            }
            if let detail = detail {
                cell.update(detail)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(TopicCommentViewCell.self), for: indexPath) as! TopicCommentViewCell
            cell.backgroundColor = .clear
            let reply = comments[indexPath.row]
            cell.update(reply)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if var detail = detail {
                let height = TopicDetailViewCell.heightForRowWithDetail(&detail)
                self.detail = detail
                return height
            }
            return 0.0
        }
        var reply = comments[indexPath.row]
        return TopicCommentViewCell.heightForRowWithReply(&reply)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
