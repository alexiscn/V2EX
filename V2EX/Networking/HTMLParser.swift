//
//  HTMLParser.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/12/5.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import SwiftSoup

protocol HTMLParser {
    static func handle<T>(_ doc: Document) throws -> T?
}

extension HTMLParser {
    static func avatarURLWithSource(_ src: String?) -> URL? {
        guard let src = src else {
            return nil
        }
        if src.hasPrefix("//") {
            return URL(string: "https:" + src)
        } else {
            return URL(string: src)
        }
    }
}

/// 主题列表HTML解析
struct TabParser: HTMLParser {
    
    static func handle<T>(_ doc: Document) throws -> T? {
        let cells = try doc.select("div")
        var topics: [Topic] = []
        for cell in cells {
            if !cell.hasClass("cell item") {
                continue
            }
            let topic = V2SDK.parseTopicListCell(cell)
            topics.append(topic)
        }
        return topics as? T
    }
}

/// 登录验证码HTML解析
struct OnceTokenParser: HTMLParser {
    
    static func handle<T>(_ doc: Document) throws -> T? {
        let keys = try doc.select("input.sl").array()
        if keys.count == 3 {
            let username = try keys[0].attr("name")
            let password = try keys[1].attr("name")
            let captcha = try keys[2].attr("name")
            let once = try doc.select("input[name=once]").attr("value")
            let form = LoginFormData(username: username, password: password, captcha: captcha, once: once)
            return form as? T
        }
        throw ServerError.parseHTMLError
    }
    
}

/// 登录HTML解析
struct SignInParser: HTMLParser {
    
    static func handle<T>(_ doc: Document) throws -> T? {
        let title = try doc.title()
        if title.contains("两步验证登录") {
            throw ServerError.needsTwoFactor
        }
        let html = try doc.html()
        if html.contains("/mission/daily") {
            if let imgElement = try doc.select("img.avatar").first(),
                let member = try imgElement.parent()?.attr("href") {
                let src = try imgElement.attr("src")
                let avatarURLString = avatarURLWithSource(src)
                let name = member.replacingOccurrences(of: "/member/", with: "")
                let account = Account(username: name, avatarURLString: avatarURLString?.absoluteString)
                return account as? T
            }
        }
        throw ServerError.signInFailed
    }
}


/// 节点主题列表HTML解析
struct NodeTopicsParser: HTMLParser {
    
    static func handle<T>(_ doc: Document) throws -> T? {
        let detail = NodeDetail()
        if let max = try doc.select(".page_input").first()?.attr("max") {
            detail.page = Int(max) ?? 1
        }
        if let topicNodes = try doc.select("#TopicsNode").first() {
            var topics: [Topic] = []
            for cell in topicNodes.children() {
                let cellContent = try cell.html()
                if cellContent == "" || cellContent == "(adsbygoogle = window.adsbygoogle || []).push({});" {
                    continue
                }
                let topic = V2SDK.parseTopicListCell(cell, isNodeList: true)
                topics.append(topic)
            }
            detail.topics = topics
            return detail as? T
        }
        return nil
    }
}

/// 话题明细页面HTML解析
struct TopicDetailParser: HTMLParser {
    
    static func handle<T>(_ doc: Document) throws -> T? {
        var detail = TopicDetail()
        let header = try doc.select("div.header")
        let authorAvatarSrc = try header.select("img").first()?.attr("src")
        detail.authorAvatarURL = avatarURLWithSource(authorAvatarSrc)
        detail.title = try header.select("h1").text()
        detail.author = try header.select("small a").text()
        let small = try header.select("small").text()
        if let author = detail.author {
            detail.small = small.replacingOccurrences(of: "\(author) · ", with: "")
        } else {
            detail.small = small
        }
        
        detail.contentHTML = try doc.select("div.topic_content").html()
        detail.nodeTag = try doc.select("meta[property='article:tag'").attr("content")
        detail.nodeName = try doc.select("meta[property='article:section'").attr("content")
        
        let cells = try doc.select("div.cell")
        for cell in cells {
            let divID = try? cell.attr("id")
            if divID == nil || divID == "" {
                if let lastLink = try cell.select("a.page_normal").last() {
                    let href = try lastLink.attr("href")
                    if href.hasPrefix("?p=") {
                        detail.page = Int(href.replacingOccurrences(of: "?p=", with: "")) ?? 0
                    }
                    break
                }
            } else {
                continue
            }
        }
        
        return detail as? T
    }
    
}


/// 他人资料页面HTML解析
struct UserProfileParser: HTMLParser {
    
    static func handle<T>(_ doc: Document) throws -> T? {
        let mainDiv = try doc.select("div#Main").first()
        let avatar = try mainDiv?.select("img.avatar").first()?.attr("src")
        let avatarURL = avatarURLWithSource(avatar)
        let info = UserInfo()
        let username = try mainDiv?.select("h1").first()?.text()
        info.username = username
        info.avatarURL = avatarURL
        info.createdInfo = try mainDiv?.select("span.gray").first()?.text()
        
        var topics: [Topic] = []
        let cells = try doc.select("div.cell")
        for cell in cells {
            if !cell.hasClass("cell item") {
                continue
            }
            let topic = V2SDK.parseTopicListCell(cell)
            topic.avatar = avatarURL
            topics.append(topic)
        }
        
        let comments = try parseUserReplies(doc)
        for comment in comments {
            comment.avatarURL = avatarURL
            comment.username = username
        }
        
        var profile = UserProfileResponse()
        profile.info = info
        profile.topics = topics
        profile.comments = comments
        return profile as? T
    }
    
    static func parseUserReplies(_ doc: Document) throws -> [UserProfileComment] {
        var comments: [UserProfileComment] = []
        let commentsCells = try doc.select("div.dock_area").array()
        let replyCells = try doc.select("div.reply_content").array()
        if commentsCells.count == replyCells.count {
            for (index, cell) in commentsCells.enumerated() {
                let comment = UserProfileComment()
                comment.timeAgo = try cell.select("span.fade").first()?.text()
                
                let links = try cell.select("a").array()
                if links.count == 3 {
                    comment.originAuthor = try links[0].text()
                    
                    let nodeLink = links[1]
                    comment.originTopicTitle = try nodeLink.text()
                    comment.originNodename = try nodeLink.attr("href").replacingOccurrences(of: "/go/", with: "")
                    
                    let topicLink = links[2]
                    comment.originTopicTitle = try topicLink.text()
                    let topicHref = try topicLink.attr("href")
                    if let url = URL(string: V2SDK.baseURLString + topicHref) {
                        comment.originTopicURL = URL(string: V2SDK.baseURLString + url.path)
                    }
                }
                
                let reply = replyCells[index]
                comment.commentContent = try reply.text()
                comment.commentContentHTML = try reply.html()
                comments.append(comment)
            }
        }
        return comments
    }
}
