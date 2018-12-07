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
    
    fileprivate var allComments: [Reply] = []
    fileprivate var comments: [Reply] = []
    fileprivate var detail: TopicDetail?
    fileprivate let topicURL: URL?
    fileprivate let titleString: String?
    fileprivate var currentPage = 1
    fileprivate var viewAuthorOnly = false
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
        setupNavigationBar()
        setupLoadingView()
        setupTableView()
        loadTopicDetail()
        setupLongPressGesture()
    }
    
    private func setupLongPressGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        gesture.minimumPressDuration = 0.5
        tableView.addGestureRecognizer(gesture)
    }
    
    @objc private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            
            let feedback = UIImpactFeedbackGenerator(style: .light)
            feedback.impactOccurred()
            
            let point = gesture.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: point), indexPath.section == 1 {
                let comment = comments[indexPath.row]
                showCommentSheet(comment)
            }
        }
    }
    
    private func showCommentSheet(_ comment: Reply) {
        let actionSheet = ActionSheet(title: NSLocalizedString("更多操作", comment: ""), message: nil)
        if AppContext.current.isLogined {
            actionSheet.addAction(Action(title: NSLocalizedString("评论", comment: ""), style: .default, handler: { _ in
                
            }))
        }        
//        actionSheet.addAction(Action(title: NSLocalizedString("查看该作者的所有回复", comment: ""), style: .default, handler: { _ in
//
//        }))
        actionSheet.addAction(Action(title: NSLocalizedString("复制评论", comment: ""), style: .default, handler: { _ in
            UIPasteboard.general.string = comment.content
        }))
        actionSheet.addAction(Action(title: NSLocalizedString("举报", comment: ""), style: .default, handler: { _ in
            
        }))
        actionSheet.addAction(Action(title: NSLocalizedString("取消", comment: ""), style: .cancel, handler: { _ in
            
        }))
        actionSheet.show()
    }
    
    private func setupNavigationBar() {
        let moreBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_more_24x24_"), style: .done, target: self, action: #selector(moreBarButtonItemTapped(_:)))
        navigationItem.rightBarButtonItem = moreBarButtonItem
    }
    
    @objc private func moreBarButtonItemTapped(_ sender: Any) {
        let actionSheet = ActionSheet(title: NSLocalizedString("更多操作", comment: ""), message: nil)
        actionSheet.addAction(Action(title: NSLocalizedString("在Safari中打开", comment: ""), style: .default, handler: { _ in
            if let url = self.topicURL {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }))
        let viewOptionTitle = viewAuthorOnly ? NSLocalizedString("查看全部评论", comment: ""): NSLocalizedString("只看楼主", comment: "")
        actionSheet.addAction(Action(title: viewOptionTitle, style: .default, handler: { [weak self] _ in
            self?.resortReplies()
        }))
        actionSheet.addAction(Action(title: NSLocalizedString("举报", comment: ""), style: .default, handler: { _ in
            
        }))
        actionSheet.addAction(Action(title: NSLocalizedString("取消", comment: ""), style: .cancel, handler: { _ in
            
        }))
        actionSheet.show()
    }
    
    private func resortReplies() {
        viewAuthorOnly = !viewAuthorOnly
        if viewAuthorOnly {
            comments = allComments.filter { return $0.isTopicAuthor }
        } else {
            comments = allComments
        }
        tableView.reloadData()
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
        webViewHeightCaculated = false
        guard let url = topicURL else { return }
        let topicID = url.lastPathComponent
        V2SDK.request(EndPoint.topicDetail(topicID), parser: TopicDetailParser.self) { [weak self] (detail: TopicDetail?, error) in
            guard let strongSelf = self, let detail = detail else { return }
            strongSelf.detail = detail
            for r in detail.replyList {
                if r.username == detail.author {
                    r.isTopicAuthor = true
                }
            }
            strongSelf.allComments = detail.replyList
            
            strongSelf.comments = detail.replyList
            strongSelf.tableView.mj_header.endRefreshing()
            
            strongSelf.tableView.reloadData()
            if detail.page == 1 {
                strongSelf.setNoMoreData()
            }
            strongSelf.loadingIndicator.stopAnimating()
        }
    }
    
    private func loadMoreComments() {
        guard let url = topicURL, let detail = detail else { return }
        if currentPage >= detail.page {
            setNoMoreData()
            return
        }
        currentPage += 1        
        let endPoint = EndPoint.topicDetail(url.lastPathComponent, page: currentPage)
        V2SDK.request(endPoint, parser: TopicReplyParser.self) { [weak self] (replies: [Reply]?, error) in
            if let strongSelf = self, let replies = replies {
                for r in replies {
                    if r.username == strongSelf.detail?.author {
                        r.isTopicAuthor = true
                    }
                }
                strongSelf.allComments.append(contentsOf: replies)
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
        
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.loadTopicDetail()
        })
        header?.activityIndicatorViewStyle = Theme.current.activityIndicatorViewStyle
        header?.stateLabel.isHidden = true
        header?.stateLabel.textColor = Theme.current.subTitleColor
        header?.lastUpdatedTimeLabel.isHidden = true
        tableView.mj_header = header
        
        let footer = MJRefreshAutoNormalFooter { [weak self] in
            self?.loadMoreComments()
        }
        footer?.stateLabel.isHidden = true
        footer?.stateLabel.textColor = Theme.current.subTitleColor
        footer?.setTitle(NSLocalizedString("没有更多回复了", comment: ""), for: .noMoreData)
        footer?.isRefreshingTitleHidden = true
        footer?.triggerAutomaticallyRefreshPercent = 0.8
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
            cell.avatarHandler = { [weak self] in
                if let detail = self?.detail, let author = detail.author {
                    let controller = UserProfileViewController(username: author)
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
            cell.userTappedHandler = { [weak self, weak reply] in
                if let name = reply?.username {
                    let controller = UserProfileViewController(username: name)
                    self?.navigationController?.pushViewController(controller, animated: true)
                }
            }
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
