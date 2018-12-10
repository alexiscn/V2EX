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
    
    static func trimNode(_ nodeName: String) -> String {
        return nodeName.replacingOccurrences(of: "/go/", with: "")
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
            let topic = NodeTopicsParser.parseTopicListCell(cell)
            topics.append(topic)
        }
        
        if V2SDK.shouldParseHotNodes {
            if let nodes: [Node] = try NodeNavigationParser.handle(doc) {
                V2DataManager.shared.saveHotNodes(nodes)
            }
            V2SDK.shouldParseHotNodes = false
        }
        if V2SDK.shouldParseAccount {
            if let account: Account? = try AccountInfoParser.handle(doc) {
                AppContext.current.account = account
            }
            V2SDK.shouldParseAccount = false
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
        throw V2Error.parseHTMLError
    }
    
}

/// 登录HTML解析
struct SignInParser: HTMLParser {
    
    static func handle<T>(_ doc: Document) throws -> T? {
        let title = try doc.title()
        if title.contains("两步验证登录") {
            throw V2Error.needsTwoFactor
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
        throw V2Error.signInFailed
    }
}

struct AccountInfoParser: HTMLParser {
    
    static func handle<T>(_ doc: Document) throws -> T? {
        let rightBar = try doc.select("div#Rightbar").first()
        let box = try rightBar?.select("div.box").first()
        
        if let img = try box?.select("img.avatar").first(), let member = try img.parent()?.attr("href") {
            let src = try img.attr("src")
            let avatarURLString = avatarURLWithSource(src)
            let name = member.replacingOccurrences(of: "/member/", with: "")
            let account = Account(username: name, avatarURLString: avatarURLString?.absoluteString)
            return account as? T
        }
        return nil
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
                let topic = parseTopicListCell(cell, isNodeList: true)
                topics.append(topic)
            }
            detail.topics = topics
            return detail as? T
        }
        return nil
    }
    
    static func parseTopicListCell(_ cell: Element, isNodeList: Bool = false) -> Topic {
        let topic = Topic()
        // parse avatar
        if let img = try? cell.select("img").first(), let imgEle = img, let src = try? imgEle.attr("src") {
            topic.avatar = avatarURLWithSource(src)
        }
        // parse members
        if let members = try? cell.select("strong") {
            if let m1 = members.first() {
                topic.username = try? m1.text()
                if let m2 = members.last(), m1 != m2 {
                    topic.lastReplyedUserName = try? m2.text()
                }
            }
        }
        
        // parse topic title
        if let titleElement = try? cell.select("span.item_title").first() {
            if let title = try? titleElement?.text() {
                topic.title = title
            }
            if let href = try? titleElement?.select("a").attr("href"), let link = href {
                if link.contains("#") {
                    topic.url = URL(string: V2SDK.baseURLString + String(link.split(separator: "#")[0]))
                } else {
                    topic.url = URL(string: V2SDK.baseURLString + link)
                }
            }
        }
        
        // parse reply count
        if let countElement = try? cell.select("a.count_livid").first() {
            if let count = try? countElement?.text(), let c = count {
                topic.replies = Int(c)!
            }
        }
        
        // parse node
        if let nodeElement = try? cell.select("a.node").first() {
            if let title = try? nodeElement?.text() {
                topic.nodeTitle = title
            }
            if let name = try? nodeElement?.attr("href"), let nodename = name {
                topic.nodeName = trimNode(nodename)
            }
        }
        if let text = try? cell.text() {
            let components = text.split(separator: "•")
            if components.count >= 3 {
                if isNodeList {
                    topic.lastUpdatedTime = String(components[1]).replacingOccurrences(of: " ", with: "")
                    topic.lastReplyedUserName = String(components[2]).replacingOccurrences(of: " ", with: "")
                } else {
                    topic.lastUpdatedTime = String(components[2]).replacingOccurrences(of: " ", with: "")
                    if components.count >= 4 {
                        topic.lastReplyedUserName = String(components[3]).replacingOccurrences(of: " ", with: "")
                    }
                }
            }
        }
        return topic
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
        
        var contentHTML = try doc.select("div.topic_content").first()?.html()
        let subtles = try doc.select("div.subtle").array()
        if subtles.count > 0 {
            for subtle in subtles {
                let title = try subtle.select("span.fade").text()
                let html = try subtle.select("div.topic_content").html()
                contentHTML?.append("<hr><p>\(title)</p>\(html)")
            }
        }
        detail.contentHTML = contentHTML
        
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
        let list: [Reply]? = try TopicReplyParser.handle(doc)
        if let list = list {
            detail.replyList = list
        }
        
        return detail as? T
    }
    
}

/// 主题回复解析
struct TopicReplyParser: HTMLParser {
    
    static func handle<T>(_ doc: Document) throws -> T? {
        let cells = try doc.select("div.cell")
        var replyList: [Reply] = []
        for cell in cells {
            let divID = try? cell.attr("id")
            if divID == nil || divID == "" {
                continue
            }
            let reply = Reply()
            let avatarSrc = try cell.select("img").first()?.attr("src")
            reply.avatarURL = avatarURLWithSource(avatarSrc)
            reply.content = try cell.select("div.reply_content").text()
            reply.contentHTML = try cell.select("div.reply_content").html()
            
//            let body = NSMutableAttributedString()
//            if let replyContent = try cell.select("div.reply_content").first() {
//                
//                let nodes = replyContent.getChildNodes()
//                
//                for node in nodes {
//                    if let textNode = node as? TextNode {
//                        body.append(NSAttributedString(string: textNode.text()))
//                    } else if let element = node as? Element {
//                        switch element.tagName() {
//                        case "br":
//                            body.append(NSAttributedString(string: "\n"))
//                        case "a":
//                            print("aaaaa")
//                            print(try element.outerHtml())
//                        case "img":
//                            print("img")
//                            print(try element.outerHtml())
//                        default:
//                            print(element.tagName())
//                            print(try element.outerHtml())
//                            break
//                        }
//                    }
//                }
//            }
            
            reply.timeAgo = try cell.select("span.ago").text()
            let userLink = try cell.select("a.dark")
            reply.username = try userLink.text()
            reply.floor = try cell.select("span.no").text()
            if let like = try cell.select(".small.fade").first() {
                reply.likesInfo = try like.text()
            }
            
            replyList.append(reply)
        }
        return replyList as? T
    }
}


/// 他人资料页面HTML解析
struct MemberProfileParser: HTMLParser {
    
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
            let topic = NodeTopicsParser.parseTopicListCell(cell)
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
                    comment.originNodename = trimNode(try nodeLink.attr("href"))
                    
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


/// 节点导航解析
struct NodeNavigationParser: HTMLParser {
    
    static func handle<T>(_ doc: Document) throws -> T? {
        var groups: [NodeGroup] = []
        let main = try doc.select("div#Main").first()
        if let cells = try main?.select("div.cell") {
            for cell in cells {
                let table = try cell.select("table")
                if table.isEmpty() {
                    continue
                }
                let name = try cell.select("span.fade").text()
                if name.isEmpty {
                    continue
                }
                var nodes: [Node] = []
                let nodeElements = try cell.select("a")
                for node in nodeElements {
                    let title = try node.text()
                    let nodeName = trimNode(try node.attr("href"))
                    nodes.append(Node(name: nodeName, title: title, letter: name))
                }
                let group = NodeGroup(title: name, nodes: nodes)
                groups.append(group)
            }
        }
        let allNodes = groups.flatMap { return $0.nodes }
        return allNodes as? T
    }
}

struct BalanceParser: HTMLParser {
    
    static func handle<T>(_ doc: Document) throws -> T? {
        guard let table = try doc.select("table.data").first() else {
            return nil
        }
        var response = BalanceResponse()
        if let max = try doc.select("input.page_input").first()?.attr("max") {
           response.page = Int(max) ?? 1
        }
        let lines = try table.select("tr").array()
        for (index, line) in lines.enumerated() {
            if index == 0 {
                continue
            }
            let list = line.children().array()
            if list.count == 5 {
                var balance = Balance()
                balance.time = try line.select("small.gray").text()
                balance.title = try list[1].text()
                balance.total = try list[4].text()
                balance.value = try line.select("strong").text()
                balance.desc = try line.select("span.gray").text()
                response.balances.append(balance)
            }
        }
        return response as? T
    }
}
