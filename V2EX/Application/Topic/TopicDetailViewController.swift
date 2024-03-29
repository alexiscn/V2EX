//
//  TopicDetailViewController.swift
//  V2EX
//
//  Created by alexiscn on 2018/6/26.
//  Copyright © 2018 alexiscn. All rights reserved.
//

import UIKit
import MJRefresh
import CoreServices
import Photos
import WXActionSheet
import SKPhotoBrowser

enum CommentOrder {
    case asc
    case desc
    
    var buttonTitle: String {
        switch self {
        case .asc:
            return "正序查看"
        case .desc:
            return "倒序查看"
        }
    }
}

class TopicDetailViewController: UIViewController {

    fileprivate var tableView: UITableView!
    fileprivate var detailCell: TopicDetailViewCell?
    fileprivate var loadingIndicator: UIActivityIndicatorView!
    
    fileprivate var allComments: [Reply] = []
    fileprivate var comments: [Reply] = []
    fileprivate var detail: TopicDetail?
    
    fileprivate let topicURL: URL?
    fileprivate let titleString: String?
    fileprivate var currentPage = 1
    fileprivate var viewAuthorOnly = false
    fileprivate var order: CommentOrder = .asc
    fileprivate var webViewHeightCaculated = false
    fileprivate var inputBar = CommentInputBar()
    
    override var inputAccessoryView: UIView? {
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
    
    private func resortReplies() {
        viewAuthorOnly = !viewAuthorOnly
        if viewAuthorOnly {
            comments = allComments.filter { return $0.isTopicAuthor }
        } else {
            comments = allComments
        }
        tableView.reloadData()
    }
    
    private func loadTopicDetail(page: Int = 1) {
        guard let topicID = topicID else { return }

        let endPoint = EndPoint.topicDetail(topicID, page: page)
        V2SDK.request(endPoint, parser: TopicDetailParser.self) { [weak self] (response: V2Response<TopicDetail>) in
            guard let strongSelf = self else { return }
            strongSelf.loadingIndicator.stopAnimating()
            strongSelf.tableView.mj_header?.endRefreshing()
            switch response {
            case .success(let detail):
                if !strongSelf.webViewHeightCaculated {
                    strongSelf.detail = detail
                }
                strongSelf.title = detail.title
                
                for r in detail.replyList {
                    if r.username == detail.author {
                        r.isTopicAuthor = true
                    }
                }
                switch strongSelf.order {
                case .asc:
                    strongSelf.allComments = detail.replyList
                    strongSelf.comments = detail.replyList
                case .desc:
                    strongSelf.allComments = detail.replyList.reversed()
                    strongSelf.comments = detail.replyList.reversed()
                }
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
        
        switch order {
        case .asc:
            if currentPage >= detail.page {
                setNoMoreData()
                return
            }
            currentPage += 1
        case .desc:
            if currentPage == 1 {
                setNoMoreData()
                return
            }
            currentPage -= 1
        }
        
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
                switch strongSelf.order {
                case .asc:
                    strongSelf.allComments.append(contentsOf: replies)
                    strongSelf.comments.append(contentsOf: replies)
                    strongSelf.tableView.reloadData()
                    if strongSelf.currentPage == detail.page {
                        strongSelf.setNoMoreData()
                    } else {
                        strongSelf.tableView.mj_footer?.endRefreshing()
                    }
                case .desc:
                    strongSelf.allComments.append(contentsOf: replies.reversed())
                    strongSelf.comments.append(contentsOf: replies.reversed())
                    strongSelf.tableView.reloadData()
                    if strongSelf.currentPage == 1 {
                        strongSelf.setNoMoreData()
                    } else {
                        strongSelf.tableView.mj_footer?.endRefreshing()
                    }
                }
            case .error(let error):
                strongSelf.tableView.mj_footer?.endRefreshing()
                HUD.show(message: error.description)
            }
        }
    }
    
    private func setNoMoreData() {
        if let footer = tableView.mj_footer as? MJRefreshAutoNormalFooter {
            footer.endRefreshingWithNoMoreData()
            footer.stateLabel?.isHidden = false
        }
    }
    
    private func reOrder() {
        guard let topicID = topicID, let detail = detail else { return }
        switch order {
        case .asc:
            order = .desc
            currentPage = detail.page
        case .desc:
            order = .asc
            currentPage = 1
        }
        
        if detail.page == 1 {
            comments.reverse()
            allComments.reverse()
            tableView.reloadData()
            detailCell?.order = order
        } else {
            detailCell?.orderButton.isSelected = true
            let endPoint = EndPoint.topicDetail(topicID, page: currentPage)
            V2SDK.request(endPoint, parser: TopicReplyParser.self) { [weak self] (response: V2Response<[Reply]>) in
                guard let strongSelf = self else { return }
                strongSelf.detailCell?.orderButton.isSelected = false
                switch response {
                case .success(let replies):
                    for r in replies {
                        if r.username == strongSelf.detail?.author {
                            r.isTopicAuthor = true
                        }
                    }
                    strongSelf.allComments.removeAll()
                    strongSelf.comments.removeAll()
                    switch strongSelf.order {
                    case .asc:
                        strongSelf.allComments = replies
                        strongSelf.comments = replies
                        strongSelf.tableView.reloadData()
                        if strongSelf.currentPage == detail.page {
                            strongSelf.setNoMoreData()
                        } else {
                            strongSelf.tableView.mj_footer?.endRefreshing()
                        }
                    case .desc:
                        strongSelf.allComments = replies.reversed()
                        strongSelf.comments = replies.reversed()
                        strongSelf.tableView.reloadData()
                        if strongSelf.currentPage == 1 {
                            strongSelf.setNoMoreData()
                        } else {
                            strongSelf.tableView.mj_footer?.endRefreshing()
                        }
                    }
                    strongSelf.detailCell?.order = strongSelf.order
                case .error(let error):
                    strongSelf.tableView.mj_footer?.endRefreshing()
                    HUD.show(message: error.description)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Setup UI
extension TopicDetailViewController {
    
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
    
    fileprivate func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.estimatedRowHeight = 0.0
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        tableView.backgroundColor = .clear
        tableView.separatorColor = Theme.current.cellHighlightColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
        tableView.register(TopicCommentViewCell.self, forCellReuseIdentifier: NSStringFromClass(TopicCommentViewCell.self))
        tableView.register(TopicDetailViewCell.self, forCellReuseIdentifier: NSStringFromClass(TopicDetailViewCell.self))
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        let header = V2RefreshHeader { [weak self] in
            self?.webViewHeightCaculated = false
            self?.loadTopicDetail()
        }
        tableView.mj_header = header
        tableView.mj_footer = V2RefreshFooter { [weak self] in
            self?.loadMoreComments()
        }
    }
    
    private func setupLongPressGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        gesture.minimumPressDuration = 0.5
        tableView.addGestureRecognizer(gesture)
    }
    
    fileprivate func setupNavigationBar() {
        let moreBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_more_24x24_"), style: .done, target: self, action: #selector(moreBarButtonItemTapped(_:)))
        navigationItem.rightBarButtonItem = moreBarButtonItem
    }
}


// MARK: - Events
extension TopicDetailViewController {
    
    @objc fileprivate func moreBarButtonItemTapped(_ sender: Any) {
        let actionSheet = WXActionSheet(cancelButtonTitle: Strings.Cancel)
        actionSheet.add(WXActionSheetItem(title: Strings.DetailOpenInSafari, handler: { _ in
            if let url = self.topicURL {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }))
        if AppContext.current.isLogined, let detail = detail {
            let title = detail.favorited ? Strings.DetailRemoveFromFavorites: Strings.DetailAddToFavorites
            actionSheet.add(WXActionSheetItem(title: title, handler: { [weak self] _ in
                self?.doFavorite()
            }))
        }
        actionSheet.add(WXActionSheetItem(title: Strings.Share, handler: { [weak self] _ in
            if let url = self?.topicURL {
                let controller = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                self?.present(controller, animated: true, completion: nil)
            }
        }))
        actionSheet.add(WXActionSheetItem(title: Strings.CopyLink, handler: { [weak self] _ in
            UIPasteboard.general.url = self?.topicURL
        }))
        let viewOptionTitle = viewAuthorOnly ? Strings.DetailViewAllComments: Strings.DetailViewAuthorOnly
        actionSheet.add(WXActionSheetItem(title: viewOptionTitle, handler: { [weak self] _ in
            self?.resortReplies()
        }))
        actionSheet.add(WXActionSheetItem(title: Strings.Report, handler: { _ in
            // TODO: 暂时这么写，下个版本请求接口
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                HUD.show(message: "举报成功，我们会及时处理你的举报")
            })
        }))
        actionSheet.show()
    }
    
    @objc fileprivate func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
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
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension TopicDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 1 }
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
                    let vm = NodeTimelineViewModel(node: node)
                    let controller = TimelineViewController(viewModel: vm)
                    self?.navigationController?.pushViewController(controller, animated: true)
                }
            }
            cell.avatarHandler = { [weak self] in
                if let detail = self?.detail, let author = detail.author {
                    let controller = UserProfileViewController(username: author)
                    self?.navigationController?.pushViewController(controller, animated: true)
                }
            }
            cell.orderButtonHandler = { [weak self] in
                self?.reOrder()
            }
            cell.imageTappedHandler = { [weak self] urlString in
                let photo = SKPhoto.photoWithImageURL(urlString)
                photo.shouldCachePhotoURLImage = true
                let browser = SKPhotoBrowser(photos: [photo], initialPageIndex: 0)
                self?.present(browser, animated: true, completion: nil)
            }
            cell.detailLinkHandler = { [weak self] url in
                let controller = TopicDetailViewController(url: url, title: nil)
                self?.navigationController?.pushViewController(controller, animated: true)
            }
            if let detail = detail {
                cell.update(detail)
            }
            detailCell = cell
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
            cell.topicLinkHandler = { [weak self] topicURL in
                let controller = TopicDetailViewController(url: topicURL, title: nil)
                self?.navigationController?.pushViewController(controller, animated: true)
            }
            cell.nodeLinkHandler = { [weak self] nodename in
                let node = Node(name: nodename, title: nodename, letter: "")
                let vm = NodeTimelineViewModel(node: node)
                let controller = TimelineViewController(viewModel: vm)
                self?.navigationController?.pushViewController(controller, animated: true)
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if indexPath.section == 0 {
            return nil
        }
        
        let commentAction = UITableViewRowAction(style: .default, title: Strings.DetailComment) { (_, indexPath) in
            let comment = self.comments[indexPath.row]
            if let name = comment.username {
                self.mentionUser(name)
            }
        }
        let likeAction = UITableViewRowAction(style: .default, title: Strings.DetailThanks) { (_, indexPath) in
            let comment = self.comments[indexPath.row]
            self.thankReply(comment, indexPath: indexPath)
        }
        return [commentAction, likeAction]
    }
}

extension TopicDetailViewController: CommentInputBarDelegate {
    
    func inputBar(_ inputBar: CommentInputBar, didSendText text: String) {
        guard let topicID = topicID else { return }
        let comment = text.trimmingCharacters(in: CharacterSet.whitespaces)
        if comment.count == 0 { return }
        
        inputBar.inputTextView.resignFirstResponder()
        inputBar.inputTextView.text = String()
        
        HUD.showIndicator()
        
        func sendComment(once: String) {
            let endPoint = EndPoint.commentTopic(topicID, once: once, content: comment)
            V2SDK.request(endPoint, parser: CommentParser.self) { [weak self] (response: V2Response<OperationResponse>) in
                HUD.removeIndicator()
                switch response {
                case .success(_):
                    HUD.show(message: Strings.DetailCommentSuccess)
                    self?.webViewHeightCaculated = false
                    self?.loadTopicDetail()
                case .error(let error):
                    HUD.show(message: error.description)
                }
            }
        }
        
        V2SDK.request(EndPoint.onceToken(), parser: OnceTokenParser.self) { (response: V2Response<LoginFormData>) in
            switch response {
            case .success(let form):
                sendComment(once: form.once)
            case .error(let error):
                HUD.show(message: error.description)
            }
        }
    }
    
    func inputBarDidPressedPhotoButton() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
}


// MARK: - Actions
extension TopicDetailViewController {
    
    private func showCommentSheet(_ comment: Reply) {
        let actionSheet = WXActionSheet(cancelButtonTitle: Strings.Cancel)
        if AppContext.current.isLogined {
            actionSheet.add(WXActionSheetItem(title: Strings.DetailComment, handler: { [weak self]  _ in
                if let name = comment.username {
                    self?.mentionUser(name)
                }
            }))
        }
        
        if comment.mentions.count > 0 {
            actionSheet.add(WXActionSheetItem(title: Strings.DetailViewConversation, handler: { [weak self] _ in
                self?.showConversation(with: comment)
            }))
        }
        
        actionSheet.add(WXActionSheetItem(title: Strings.DetailCopyComments, handler: { _ in
            UIPasteboard.general.string = comment.content
        }))
        actionSheet.add(WXActionSheetItem(title: Strings.Report, handler: { _ in
            // 为了审核用，实际上没有该接口
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                HUD.show(message: "举报成功，我们会及时处理你的举报")
            })
        }))
        actionSheet.show()
    }
 
    private func doFavorite() {
        guard let token = detail?.csrfToken,
            let topicID = self.topicID,
            let isFavorited = detail?.favorited else {
                return
        }
        let endPoint: EndPoint = isFavorited ? .unfavoriteTopic(topicID, token: token): .favoriteTopic(topicID, token: token)
        V2SDK.request(endPoint, parser: OperationParser.self) { [weak self] (response: V2Response<OperationResponse>) in
            switch response {
            case .success(_):
                let msg = isFavorited ? Strings.DetailUnFavoritedSuccess: Strings.DetailFavoritedSuccess
                self?.detail?.favorited = !isFavorited
                HUD.show(message: msg)
            case .error(let error):
                HUD.show(message: error.description)
            }
        }
    }
    
    private func showConversation(with originComment: Reply) {
        guard let floorAuthor = originComment.username else { return }
        var dataSource: [Reply] = []
        for comment in allComments {
            if let username = comment.username {
                if originComment.mentions.contains(username) {
                    if comment.mentions.count == 0 || comment.mentions.contains(floorAuthor) {
                        dataSource.append(comment)
                    }
                }
            }
            if comment.replyID == originComment.replyID {
                dataSource.append(comment)
            }
        }
        
        let controller = CommentConversationViewController()
        let nav = SettingsNavigationController(rootViewController: controller)
        controller.dataSource = dataSource
        present(nav, animated: true, completion: nil)
    }
    
    private func mentionUser(_ name: String) {
        inputBar.appendMention(text: "@\(name) ")
        inputBar.inputTextView.becomeFirstResponder()
    }
    
    private func thankReply(_ reply: Reply, indexPath: IndexPath) {
        guard let replyID = reply.replyID, let token = detail?.csrfToken else { return }
        let endPoint = EndPoint.thankReply(replyID, token: token)
        
        V2SDK.request(endPoint, parser: OperationParser.self) { [weak self] (response: V2Response<OperationResponse>) in
            switch response {
            case .success(_):
                reply.likeCount += 1
                self?.tableView.reloadRows(at: [indexPath], with: .none)
                HUD.show(message: "感谢成功")
            case .error(let error):
                HUD.show(message: error.description)
            }
        }
    }
}


// MARK: - UIImagePickerControllerDelegate
extension TopicDetailViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage, let data = image.jpegData(compressionQuality: 1.0) {
            if data.count > 1024 * 1024 * 5 {
                HUD.show(message: "图片大小不能超过5M")
                picker.dismiss(animated: true, completion: nil)
                return
            }
            HUD.showIndicator()
            V2SDK.upload(data: data, mimeType: .image, completion: { (response, error) in
                HUD.removeIndicator()
                if let response = response {
                    print(response)
                }
                picker.dismiss(animated: true, completion: nil)
            })
        } else {
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
