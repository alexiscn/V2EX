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
        let html = try doc.html()
        if V2SDK.shouldParseHotNodes && html.contains("节点导航") {
            if let nodes: [Node] = try NodeNavigationParser.handle(doc) {
                V2DataManager.shared.saveHotNodes(nodes)
            }
            V2SDK.shouldParseHotNodes = false
        }
        
        if V2SDK.shouldParseAccount {
            if let account: Account? = try AccountInfoParser.handle(doc) {
                AppContext.current.account = account
                NotificationCenter.default.post(name: NSNotification.Name.V2.AccountUpdated, object: nil)
                V2SDK.shouldParseAccount = false
            }
            if let regex = try? NSRegularExpression(pattern: "signout\\?once=(\\d+)", options: NSRegularExpression.Options.caseInsensitive) {
                let range = NSRange(location: 0, length: html.utf16.count)
                if let result = regex.firstMatch(in: html, options: .withoutAnchoringBounds, range: range) {
                    let r = result.range(at: 1)
                    let start = html.index(html.startIndex, offsetBy: r.location)
                    let end = html.index(html.startIndex, offsetBy: r.location + r.length - 1)
                    let once = html[start...end]
                    V2SDK.once = String(once)
                }
            }
        }
        if html.contains("/mission/daily") {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                V2SDK.dailyMission()
            }
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
        if html.contains("/notifications") {
            if let link = try doc.select("a.top").first() {
                let member = try link.attr("href")
                let src = try link.select("img").first()?.attr("src")
                
                var account = Account()
                account.avatarURLString = avatarURLWithSource(src)?.absoluteString
                account.username = member.replacingOccurrences(of: "/member/", with: "")
                return account as? T
            }
        }
        throw V2Error.signInFailed
    }
}

struct DailyMissionParser: HTMLParser {
    
    static func handle<T>(_ doc: Document) throws -> T? {
        let html = try doc.html()
        if !html.contains("已成功领取每日登录奖励") {
            return DailyMission(message: nil) as? T
        }
        let mainDiv = try doc.select("div#Main")
        let boxDiv = try mainDiv.select("div.box")
        if let info = try boxDiv.select("div").last()?.text().trimmingCharacters(in: .whitespaces) {
            let message = "每日登录奖励领取成功\n\(info)"
            return DailyMission(message: message) as? T
        }
        return DailyMission(message: "每日登录奖励领取成功") as? T
    }
}

struct AccountInfoParser: HTMLParser {
    
    static func handle<T>(_ doc: Document) throws -> T? {
        
        guard let rightBar = try doc.select("div#Rightbar").first(),
            let box = try rightBar.select("div.box").first() else {
            return nil
        }
        
        if let img = try box.select("img.avatar").first(), let member = try img.parent()?.attr("href") {
            let src = try img.attr("src")
            var account = Account()
            account.username = member.replacingOccurrences(of: "/member/", with: "")
            account.avatarURLString = avatarURLWithSource(src)?.absoluteString
            let links = try rightBar.select("a.dark")
            for link in links {
                let href = try link.attr("href")
                if href == "/my/nodes" {
                    account.myNodes = try link.select("span.bigger").text()
                } else if href == "/my/topics" {
                    account.myTopics = try link.select("span.bigger").text()
                } else if href == "/my/following" {
                    account.myFollowing = try link.select("span.bigger").text()
                }
            }
            if let balance = try box.select("a.balance_area").first()?.text() {
                let components = balance.components(separatedBy: " ")
                if components.count == 3 {
                    account.golden = String(components[0])
                    account.silver = String(components[1])
                    account.bronze = String(components[2])
                } else if components.count == 2 {
                    account.silver = String(components[0])
                    account.bronze = String(components[1])
                }
                account.balance = balance.replacingOccurrences(of: " ", with: "")
            }
            
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
        if let max = try doc.select("input.page_input").first()?.attr("max") {
            detail.page = Int(max) ?? 1
        }
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
        
        if let buttons = try doc.select("div.topic_buttons").first(), let favoriteLink = try buttons.select("a").first() {
            detail.favorited = (try favoriteLink.text()) == "取消收藏"
            let favoriteHref = try favoriteLink.attr("href")
            if favoriteHref.contains("=") {
                detail.csrfToken = String(favoriteHref.split(separator: "=").last!)
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
            if let replyContent = try cell.select("div.reply_content").first() {
                reply.contentAttributedString = parseContentCell(replyContent)
            }
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
    
    static func parseContentCell(_ replyContent: Element) -> NSMutableAttributedString {
        
        func textString(_ text: String) -> NSAttributedString {
            let attributedString = NSAttributedString(string: text, attributes: [
                .foregroundColor: Theme.current.titleColor, .font: UIFont.systemFont(ofSize: 14)])
            return attributedString
        }
        
        func linkString(_ linkURL: NSURL, content: String) -> NSAttributedString {
            let link = NSAttributedString(string: content, attributes: [
                .link: linkURL,
                .foregroundColor: Theme.current.linkColor,
                .font: UIFont.systemFont(ofSize: 14)])
            return link
        }
        
        func mention(username: String) -> NSAttributedString {
            let URL = NSURL(string: V2SDK.baseURLString + "/member/" + username)!
            let link = NSAttributedString(string: username, attributes: [
                .link: URL,
                .foregroundColor: Theme.current.subTitleColor,
                .font: UIFont.systemFont(ofSize: 14)])
            return link
        }
        
        let body = NSMutableAttributedString()
        do {
            let nodes = replyContent.getChildNodes()
            for node in nodes {
                if let textNode = node as? TextNode {
                    body.append(textString(textNode.text()))
                } else if let element = node as? Element {
                    switch element.tagName() {
                    case "br":
                        body.append(textString("\n"))
                    case "a":
                        let href = try element.attr("href")
                        let content = try element.text()
                        if content.isEmpty {
                            body.append(parseContentCell(element))
                        } else {
                            if href.hasPrefix("/member/") {
                                body.append(mention(username: content))
                            } else {
                                if content.hasPrefix("http") {
                                    if let url = NSURL(string: href) {
                                        body.append(linkString(url, content: content))
                                    } else {
                                        body.append(textString(content))
                                    }
                                } else {
                                    if content.hasPrefix("/t/") || content.hasPrefix("/go/") {
                                        if let url = NSURL(string: V2SDK.baseURLString.appending(content)) {
                                            body.append(linkString(url, content: content))
                                        }
                                    } else {
                                        print(try element.outerHtml())
                                        print(href)
                                    }
                                }
                            }
                        }
                    case "img":
                        let imageSrc = try element.attr("src")
                        if imageSrc.hasPrefix("http") {
//                            let attachment = NSTextAttachment()
//                            attachment.bounds = CGRect(x: 0, y: 0, width: 100.0, height: 80.0)
//                            let imageString = NSAttributedString(attachment: attachment)
//                            body.append(imageString)
                            let link = NSAttributedString(string: imageSrc, attributes: [
                                .link: NSURL(string: imageSrc)!,
                                .foregroundColor: Theme.current.linkColor,
                                .font: UIFont.systemFont(ofSize: 14)])
                            body.append(link)
                        }
                        
                        print("img")
                        print(try element.outerHtml())
                    default:
                        print(element.tagName())
                        print(try element.outerHtml())
                        break
                    }
                }
            }
        } catch {
            print(error)
        }
        
        return body
    }
}

struct CommentParser: HTMLParser {
    static func handle<T>(_ doc: Document) throws -> T? {
        if let problem = try doc.select("div.problem").first()?.text() {
            throw V2Error.commonError(problem)
        }
        return OperationResponse() as? T
    }
}

/// 他人资料页面HTML解析
struct UserProfileParser: HTMLParser {

    private static func parse(onclick: String) -> URL? {
        let components = onclick.components(separatedBy: "'")
        if components.count > 3 {
            let urlString = V2SDK.baseURLString + String(components[3])
            return URL(string: urlString)
        }
        return nil
    }
    
    static func handle<T>(_ doc: Document) throws -> T? {
        let mainDiv = try doc.select("div#Main").first()
        let avatar = try mainDiv?.select("img.avatar").first()?.attr("src")
        let avatarURL = avatarURLWithSource(avatar)
        
        let info = UserInfo()
        let username = try mainDiv?.select("h1").first()?.text()
        info.username = username
        info.avatarURL = avatarURL
        info.createdInfo = try mainDiv?.select("span.gray").first()?.text()
        if let inputs = try mainDiv?.select("input[type=button]").array(), inputs.count == 2 {
            info.followURL = parse(onclick: try inputs[0].attr("onclick"))
            info.blockURL = parse(onclick: try inputs[1].attr("onclick"))
            info.hasFollowed = info.followURL?.absoluteString.contains("unfollow") ?? false
            info.hasBlocked = info.followURL?.absoluteString.contains("unblock") ?? false
        }
        
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
        var response: ListResponse<Balance> = ListResponse()
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
                let balance = Balance()
                balance.time = try line.select("small.gray").text().replacingOccurrences(of: " +08:00", with: "")
                balance.title = try list[1].text()
                balance.total = try list[4].text()
                balance.value = try line.select("strong").text()
                balance.desc = try line.select("span.gray").text()
                response.list.append(balance)
            }
        }
        return response as? T
    }
}

struct NotificationParser: HTMLParser {
    
    static func handle<T>(_ doc: Document) throws -> T? {
        var response: ListResponse<MessageNotification> = ListResponse()
        if let max = try doc.select("input.page_input").first()?.attr("max") {
            response.page = Int(max) ?? 1
        }
        let cells = try doc.select("div.cell")
        for cell in cells {
            let divID = try? cell.attr("id")
            if divID == nil || divID == "" {
                 continue
            }
            let message = MessageNotification()
            message.timeAgo = try cell.select("span.snow").text()
            
            let source = try cell.select("img.avatar").first()?.attr("src")
            message.avatarURL = avatarURLWithSource(source)
            message.username = try cell.select("strong").text()
            message.comment = try cell.select("div.payload").text()
            response.list.append(message)
        }
        return response as? T
    }
}

struct UserTopicsParser: HTMLParser {
    
    static var avatarURL: URL?
    
    static func handle<T>(_ doc: Document) throws -> T? {
        var response: ListResponse<Topic> = ListResponse()
        if let max = try doc.select("input.page_input").first()?.attr("max") {
            response.page = Int(max) ?? 1
        }
        
        let cells = try doc.select("div.cell")
        for cell in cells {
            if !cell.hasClass("cell item") {
                continue
            }
            let topic = NodeTopicsParser.parseTopicListCell(cell)
            topic.avatar = avatarURL
            response.list.append(topic)
        }
        return response as? T
    }
}

struct UserRepliesParser: HTMLParser {
    
    static var username: String?
    static var avatarURL: URL?
    
    static func handle<T>(_ doc: Document) throws -> T? {
        var response: ListResponse<UserProfileComment> = ListResponse()
        if let max = try doc.select("input.page_input").first()?.attr("max") {
            response.page = Int(max) ?? 1
        }
        let comments = try UserProfileParser.parseUserReplies(doc)
        for comment in comments {
            comment.username = username
            comment.avatarURL = avatarURL
        }
        response.list = comments
        return response as? T
    }
    
}

struct MyNodesParser: HTMLParser {
    static func handle<T>(_ doc: Document) throws -> T? {
        let nodes = try doc.select("a.grid_item")
        var response = ListResponse<MyNode>()
        for node in nodes {
            let my = MyNode()
            
            let logo = try node.select("img").first()?.attr("src")
            let text = try node.text()
            let count = try node.select("span.fade").text()
            my.title = text.replacingOccurrences(of: count, with: "")
            my.count = Int(count.replacingOccurrences(of: " ", with: "")) ?? 0
            my.logoURL = avatarURLWithSource(logo)
            my.nodeName = try node.attr("href").replacingOccurrences(of: "/go/", with: "")
            response.list.append(my)
        }
        return response as? T
    }
}

struct MyFavoritedTopicsParser: HTMLParser {
    static func handle<T>(_ doc: Document) throws -> T? {
        var response = ListResponse<Topic>()
        let cells = try doc.select("div")
        for cell in cells {
            if !cell.hasClass("cell item") {
                continue
            }
            let topic = NodeTopicsParser.parseTopicListCell(cell)
            response.list.append(topic)
        }
        return response as? T
    }
}

struct MyFollowingsParser: HTMLParser {
    static func handle<T>(_ doc: Document) throws -> T? {
        var response = ListResponse<Topic>()
        if let max = try doc.select("input.page_input").first()?.attr("max") {
            response.page = Int(max) ?? 1
        }
        let cells = try doc.select("div")
        for cell in cells {
            if !cell.hasClass("cell item") {
                continue
            }
            let topic = NodeTopicsParser.parseTopicListCell(cell)
            response.list.append(topic)
        }
        return response as? T
    }
}

struct OperationParser: HTMLParser {
    static func handle<T>(_ doc: Document) throws -> T? {
        return OperationResponse() as? T
    }
}
