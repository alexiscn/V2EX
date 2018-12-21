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
    fileprivate var inputBar = CommentInputBar()
    
    override var inputAccessoryView: UIView? {
        if !AppContext.current.isLogined {
            return nil
        }
        return inputBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    fileprivate var topicID: String? {
        guard let url = topicURL else {
            return nil
        }
        return url.lastPathComponent
    }

    init(url: URL?, title: String?) {
        self.topicURL = url
        self.titleString = title
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
        inputBar.delegate = self
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
        let actionSheet = ActionSheet(title: nil, message: nil)
        if AppContext.current.isLogined {
            actionSheet.addAction(Action(title: Strings.DetailComment, style: .default, handler: { [weak self] _ in
                if let name = comment.username {
                    self?.inputBar.appendMention(text: "@\(name) ")
                    self?.inputBar.inputTextView.becomeFirstResponder()
                }
            }))
        }
        actionSheet.addAction(Action(title: Strings.DetailCopyComments, style: .default, handler: { _ in
            UIPasteboard.general.string = comment.content
        }))
        actionSheet.addAction(Action(title: Strings.Report, style: .default, handler: { _ in
            // 为了审核用，实际上没有该接口
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                HUD.show(message: "举报成功，我们会及时处理你的举报")
            })
        }))
        actionSheet.addAction(Action(title: Strings.Cancel, style: .cancel, handler: { _ in
        }))
        actionSheet.show()
    }
    
    private func setupNavigationBar() {
        let moreBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_more_24x24_"), style: .done, target: self, action: #selector(moreBarButtonItemTapped(_:)))
        navigationItem.rightBarButtonItem = moreBarButtonItem
    }
    
    @objc private func moreBarButtonItemTapped(_ sender: Any) {
        let actionSheet = ActionSheet(title: nil, message: nil)
        actionSheet.addAction(Action(title: Strings.DetailOpenInSafari, style: .default, handler: { _ in
            if let url = self.topicURL {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }))
        if AppContext.current.isLogined {
            actionSheet.addAction(Action(title: "加入收藏", style: .default, handler: { _ in
                
            }))
        }
        actionSheet.addAction(Action(title: Strings.Share, style: .default, handler: { [weak self] _ in
            self?.presentShare()
        }))
        actionSheet.addAction(Action(title: Strings.CopyLink, style: .default, handler: { [weak self] _ in
            UIPasteboard.general.url = self?.topicURL
        }))
        let viewOptionTitle = viewAuthorOnly ? Strings.DetailViewAllComments: Strings.DetailViewAuthorOnly
        actionSheet.addAction(Action(title: viewOptionTitle, style: .default, handler: { [weak self] _ in
            self?.resortReplies()
        }))
        actionSheet.addAction(Action(title: Strings.Report, style: .default, handler: { _ in
            
        }))
        actionSheet.addAction(Action(title: Strings.Cancel, style: .cancel, handler: { _ in
            
        }))
        actionSheet.show()
    
    }
    
    private func presentShare() {
        guard let url = topicURL else {
            return
        }
        let controller = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(controller, animated: true, completion: nil)
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
        guard let topicID = topicID else { return }
        
        let endPoint = EndPoint.topicDetail(topicID)
        V2SDK.request(endPoint, parser: TopicDetailParser.self) { [weak self] (response: V2Response<TopicDetail>) in
            guard let strongSelf = self else { return }
            strongSelf.loadingIndicator.stopAnimating()
            strongSelf.tableView.mj_header.endRefreshing()
            switch response {
            case .success(let detail):
                strongSelf.detail = detail
                for r in detail.replyList {
                    if r.username == detail.author {
                        r.isTopicAuthor = true
                    }
                }
                strongSelf.allComments = detail.replyList
                strongSelf.comments = detail.replyList
                strongSelf.tableView.reloadData()
                if detail.page == 1 {
                    strongSelf.setNoMoreData()
                }
            case .error(let error):
                HUD.show(message: error.description)
            }
        }
    }
    
    private func loadMoreComments() {
        guard let topicID = topicID, let detail = detail else { return }
        if currentPage >= detail.page {
            setNoMoreData()
            return
        }
        currentPage += 1        
        let endPoint = EndPoint.topicDetail(topicID, page: currentPage)
        V2SDK.request(endPoint, parser: TopicReplyParser.self) { [weak self] (response: V2Response<[Reply]>) in
            guard let strongSelf = self else { return }
            switch response {
            case .success(let replies):
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
            case .error(let error):
                strongSelf.tableView.mj_footer.endRefreshing()
                HUD.show(message: error.description)
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
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        tableView.backgroundColor = .clear
        tableView.separatorColor = Theme.current.cellHighlightColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
        
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
        footer?.setTitle(Strings.NoMoreData, for: .noMoreData)
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
            cell.mentionUserTappedHandler = { [weak self] username in
                let controller = UserProfileViewController(username: username)
                self?.navigationController?.pushViewController(controller, animated: true)
            }
            cell.mentionHandler = { [weak self, weak reply] in
                if let name = reply?.username {
                    self?.inputBar.appendMention(text: "@\(name) ")
                    self?.inputBar.inputTextView.becomeFirstResponder()
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

extension TopicDetailViewController: CommentInputBarDelegate {
    
    func inputBar(_ inputBar: CommentInputBar, didSendText text: String) {
        guard let topicID = topicID, let once = V2SDK.once else { return }
        let comment = text.trimmingCharacters(in: CharacterSet.whitespaces)
        if comment.count == 0 { return }
        
        let endPoint = EndPoint.commentTopic(topicID, once: once, content: comment)
        V2SDK.request(endPoint, parser: CommentParser.self) { [weak self] (response: V2Response<OperationResponse>) in
            switch response {
            case .success(_):
                HUD.show(message: Strings.DetailCommentSuccess)
                self?.loadTopicDetail()
            case .error(let error):
                HUD.show(message: error.localizedDescription)
            }
            self?.inputBar.inputTextView.text = String()
        }
    }
    
    func inputBarDidPressedPhotoButton() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
}

extension TopicDetailViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
    }
}
