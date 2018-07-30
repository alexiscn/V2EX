//
//  TopicDetailViewCell.swift
//  V2EX
//
//  Created by xushuifeng on 2018/7/29.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import SnapKit
import V2SDK
import WebKit

class TopicDetailViewCell: UITableViewCell {
 
    var webViewHeightChangedHandler: ((CGFloat) -> Void)?
    
    private let avatarView: UIImageView
    
    private let usernameButton: UIButton
    
    private let titleLabel: UILabel
    
    private let timeAgoLabel: UILabel
    
    private let webView: WKWebView
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        avatarView = UIImageView()
        usernameButton = UIButton(type: .system)
        usernameButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        usernameButton.setTitleColor(UIColor(red: 108.0/255, green: 108.0/255, blue: 108.0/255, alpha: 1.0), for: .normal)
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        
        timeAgoLabel = UILabel()
        timeAgoLabel.font = UIFont.systemFont(ofSize: 11)
        timeAgoLabel.textColor = UIColor(red: 204.0/255, green: 204.0/255, blue: 204.0/255, alpha: 1)
        
        let configuration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: configuration)
        
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(avatarView)
        contentView.addSubview(usernameButton)
        contentView.addSubview(timeAgoLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(webView)
        
        webView.navigationDelegate = self
        
        avatarView.snp.makeConstraints { make in
            make.height.width.equalTo(40)
            make.leading.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(12)
        }
        
        usernameButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(64)
        }
        
        timeAgoLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameButton.snp.bottom).offset(-3)
            make.leading.equalToSuperview().offset(64)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.top.equalTo(avatarView.snp.bottom).offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        
        webView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(_ detail: TopicDetail) {
        avatarView.kf.setImage(with: detail.authorAvatarURL)
        usernameButton.setTitle(detail.author, for: .normal)
        titleLabel.text = detail.title
        timeAgoLabel.text = detail.small
        webView.loadHTMLString(htmlContent(detail.contentHTML), baseURL: URL(string: "https://www.v2ex.com"))
    }
    
    func htmlContent(_ contentHTML: String?) -> String {
        var html = "<html><head><meta name=\"viewport\" content=\"width=device-width, user-scalable=no\">"
        html += "<style>\(ThemeManager.shared.webViewStyle())</style></head>"
        if let content = contentHTML {
            html += content
        }
        html += "</html>"
        return html
    }
    
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
        
        rowHeight += 12
        
        detail._rowHeight = rowHeight
        return rowHeight
        
    }
    
    func updateWebViewHeight(_ height: CGFloat) {
        webViewHeightChangedHandler?(height)    
        webView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
    }

}

extension TopicDetailViewCell: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        let js = "Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight)"
        webView.evaluateJavaScript(js) { [weak self] (height, error) in
            if let h = height as? CGFloat {
                self?.updateWebViewHeight(h)
            }
        }
    }
    
}

enum H: Int {
    case h1 = 22
    case h2 = 18
    case h3 = 16
}
