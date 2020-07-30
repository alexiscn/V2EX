//
//  TopicDetailViewCell.swift
//  V2EX
//
//  Created by xushuifeng on 2018/7/29.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

class TopicDetailViewCell: UITableViewCell {
 
    var webViewHeightChangedHandler: ((CGFloat) -> Void)?
    
    var imageTappedHandler: ((String) -> Void)?
    
    var orderButtonHandler: RelayCommand?
    
    var topicButtonHandler: RelayCommand?
    
    var detailLinkHandler: ((URL) -> Void)?
    
    var avatarHandler: RelayCommand?
    
    private let avatarButton: UIButton
    
    private let usernameButton: UIButton
    
    private let titleLabel: UILabel
    
    private let timeAgoLabel: UILabel
    
    private let webView: WKWebView
    
    private var webViewHeightConstraint: NSLayoutConstraint!
    
    private let nodeButton: UIButton
    
    let orderButton: UIButton
    
    var order: CommentOrder = .asc {
        didSet {
            orderButton.setTitle(order.buttonTitle, for: .normal)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        avatarButton = UIButton()
        avatarButton.layer.cornerRadius = 5.0
        avatarButton.layer.masksToBounds = true
        usernameButton = UIButton(type: .system)
        usernameButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        usernameButton.setTitleColor(Theme.current.titleColor, for: .normal)
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = Theme.current.titleColor
        
        timeAgoLabel = UILabel()
        timeAgoLabel.font = UIFont.systemFont(ofSize: 11)
        timeAgoLabel.textColor = Theme.current.subTitleColor
        
        nodeButton = UIButton(type: .system)
        nodeButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        nodeButton.setTitleColor(Theme.current.titleColor, for: .normal)
        nodeButton.backgroundColor = Theme.current.cellBackgroundColor
        nodeButton.isHidden = true
        nodeButton.contentEdgeInsets = UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5)
        
        let configuration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.backgroundColor = .clear
        
        orderButton = UIButton(type: .custom)
        orderButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        orderButton.setTitleColor(Theme.current.titleColor, for: .normal)
        orderButton.setTitleColor(Theme.current.titleColor, for: .selected)
        orderButton.backgroundColor = Theme.current.cellBackgroundColor
        orderButton.contentEdgeInsets = UIEdgeInsets(top: 3, left: 10, bottom: 3, right: 10)
        orderButton.setTitle(CommentOrder.asc.buttonTitle, for: .normal)
        orderButton.setTitle("正在加载", for: .selected)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(avatarButton)
        contentView.addSubview(usernameButton)
        contentView.addSubview(timeAgoLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(nodeButton)
        contentView.addSubview(webView)
        contentView.addSubview(orderButton)
        
        webView.navigationDelegate = self
        
        configureConstraints()
        
        nodeButton.addTarget(self, action: #selector(handleNodeButtonTapped(_:)), for: .touchUpInside)
        avatarButton.addTarget(self, action: #selector(userAvatarButtonTapped(_:)), for: .touchUpInside)
        orderButton.addTarget(self, action: #selector(handleOrderButtonTapped(_:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        
        avatarButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarButton.widthAnchor.constraint(equalToConstant: 40),
            avatarButton.heightAnchor.constraint(equalToConstant: 40),
            avatarButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            avatarButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12)
        ])
        
        usernameButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            usernameButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            usernameButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 64)
        ])
        
        timeAgoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeAgoLabel.topAnchor.constraint(equalTo: usernameButton.bottomAnchor, constant: -3),
            timeAgoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 64)
        ])
        
        nodeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nodeButton.centerYAnchor.constraint(equalTo: usernameButton.centerYAnchor),
            nodeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: avatarButton.bottomAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        webViewHeightConstraint = webView.heightAnchor.constraint(equalToConstant: 0)
        webViewHeightConstraint.isActive = true
        
        orderButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            orderButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            orderButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            orderButton.heightAnchor.constraint(equalToConstant: 22)
        ])
    }

    func update(_ detail: TopicDetail) {
        avatarButton.kf.setBackgroundImage(with: detail.authorAvatarURL, for: .normal)
        usernameButton.setTitle(detail.author, for: .normal)
        titleLabel.text = detail.title
        timeAgoLabel.text = detail.small
        if let nodeName = detail.nodeName {
            nodeButton.isHidden = false
            nodeButton.setTitle(nodeName, for: .normal)
        } else {
            nodeButton.isHidden = true
        }
        webView.loadHTMLString(htmlContent(detail.contentHTML), baseURL: URL(string: "local://www.v2ex.com"))
    }
    
    func htmlContent(_ contentHTML: String?) -> String {
        var html = "<html><head><meta name=\"viewport\" content=\"width=device-width, user-scalable=no\">"
        html += "<style>\(Theme.current.webViewStyle())</style></head>"
        if let content = contentHTML {
            html += content
        }
        html += "</html>"
        return html
    }

    func updateWebViewHeight(_ height: CGFloat) {
        webViewHeightChangedHandler?(height)    
        webViewHeightConstraint.constant = height
    }

}

// MARK: - Events
extension TopicDetailViewCell {
    
    @objc private func handleOrderButtonTapped(_ sender: Any) {
        orderButtonHandler?()
    }
    
    @objc private func handleNodeButtonTapped(_ sender: Any) {
        topicButtonHandler?()
    }
    
    @objc private func userAvatarButtonTapped(_ sender: Any) {
        avatarHandler?()
    }
}

// MARK: - Height Calculation
extension TopicDetailViewCell {
    
    class func heightForRowWithDetail(_ detail: inout TopicDetail) -> CGFloat {
        
        if detail._rowHeight > 0 {
            return detail._rowHeight
        }
        var rowHeight: CGFloat = 64
     
        let width = UIScreen.main.bounds.width - 24
        if let title = detail.title {
            let maxSize = CGSize(width: width, height: CGFloat.infinity)
            let rect = title.boundingRectWithSize(maxSize, attributes: [.font: UIFont.systemFont(ofSize: 20) as Any])
            rowHeight += rect.height
        }
        rowHeight += 30 // bottom
        rowHeight += 12
        
        detail._rowHeight = rowHeight
        return rowHeight
    }
    
}

// MARK: - WKNavigationDelegate
extension TopicDetailViewCell: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        let js = "Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight)"
        webView.evaluateJavaScript(js) { [weak self] (height, error) in
            if let h = height as? CGFloat {
                self?.updateWebViewHeight(h)
            }
        }
        
        let imgJavascriptInjection = """
                                    var images = document.getElementsByTagName('img');
                                    for (var i = 0; i < images.length ; i++) {
                                        var img = images[i];
                                        var src = img.src;
                                        img.onclick = (function(src) {
                                            return function () {
                                                location.href = 'v2ex-img://url=' + encodeURIComponent(src)
                                            }
                                        })(src)
                                    }
                                    """
        webView.evaluateJavaScript(imgJavascriptInjection, completionHandler: nil)
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, url.scheme == "v2ex-img" {
            let src = url.absoluteString.replacingOccurrences(of: "v2ex-img://url=", with: "")
            if let url = src.removingPercentEncoding {
                imageTappedHandler?(url)
            }
            decisionHandler(.cancel)
            return
        }
        if let url = navigationAction.request.url {
            
            if url.absoluteString == "local://www.v2ex.com" {
                decisionHandler(.allow)
                return
            }
            
            if url.absoluteString.hasPrefix("https://www.v2ex.com") {
                detailLinkHandler?(url)
                decisionHandler(.cancel)
            } else {
                presentSafariViewController(url: url)
                decisionHandler(.cancel)
            }
            return
        }
        decisionHandler(.allow)
    }
    
}
