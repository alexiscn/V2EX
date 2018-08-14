//
//  V2SDK+Topics.swift
//  V2SDK
//
//  Created by xu.shuifeng on 2018/6/22.
//

import Foundation
import GenericNetworking
import Alamofire
import SwiftSoup
import AVFoundation

extension V2SDK {
    
    /// 获取社区每天最热的10个主题
    ///
    /// - Parameter completion: 请求回调
    public class func getHotTopics(completion: @escaping GenericNetworkingCompletion<Int>) {
        let path = "/api/topics/hot.json"
        GenericNetworking.getJSON(path: path, completion: completion)
    }
    
    /// 获取最新的主题
    ///
    /// - Parameter completion: 请求回调
    public class func getLatestTopics(completion: @escaping GenericNetworkingCompletion<Int>) {
        let path = "/api/topics/latest.json"
        GenericNetworking.getJSON(path: path, completion: completion)
    }

    /// 根据用户名获取用户的主题列表
    ///
    /// - Parameters:
    ///   - username: 用户名
    ///   - completion: 请求回调
    public class func showUserTopics(username: String, completion: @escaping GenericNetworkingCompletion<Int>) {
        let path = "/api/topics/show.json?username=" + username
        GenericNetworking.getJSON(path: path, completion: completion)
    }
    
    /// 获取主题列表
    ///
    /// - Parameters:
    ///   - tab: tab
    ///   - completion: 请求回调
    public class func getTopicList(tab: V2Tab, completion: @escaping V2SDKLoadTimelineCompletion) {
        let url = URL(string: String(format: "https://www.v2ex.com/?tab=%@", tab.key))!
        loadHTMLString(url: url) { (html, error) in
            guard let html = html else {
                completion([], error)
                return
            }
            
            do {
                let doc = try SwiftSoup.parse(html)
                let cells = try doc.select("div")
                var topics: TopicList = []
                for cell in cells {
                    if !cell.hasClass("cell item") {
                        continue
                    }
                    var topic = self.parseTopicListCell(cell)
                    topic.tab = tab.key
                    topics.append(topic)
                }
                //parseNodeNavigations(doc)
                V2DataManager.shared.saveTopics(topics, forTab: tab.key)
                completion(topics, nil)
            } catch {
                completion([], error)
            }
        }
        
    }
    
    
    /// 获取主题详情，包括评论列表
    ///
    /// - Parameters:
    ///   - topicURL: 主题URL
    ///   - completion: 请求回调
    public class func getTopicDetail(_ topicURL: URL, page: Int = 1, completion: @escaping V2SDKLoadTopicDetailCompletion) {
        
        let urlString = topicURL.absoluteString.appending("?p=1")
        let url = URL(string: urlString)!
        
        loadHTMLString(url: url) { (html, error) in
            guard let html = html else {
                completion(nil, [], error)
                return
            }
            
            do {
                let doc = try SwiftSoup.parse(html)
                let replyList = parseTopicReply(doc)
                let detail = parseTopicDetail(doc)
                completion(detail, replyList, nil)
            } catch {
                completion(nil, [], error)
            }
        }
    }
    
}

extension V2SDK {
    
    class func parseTopicReply(_ doc: Document) -> [Reply] {
        do {
            let cells = try doc.select("div.cell")
            // comments
            var replyList: [Reply] = []
            for cell in cells {
                let divID = try? cell.attr("id")
                if divID == nil || divID == "" {
                    continue
                }
                var reply = Reply()
                let avatarSrc = try cell.select("img").first()?.attr("src")
                reply.avatarURL = avatarURLWithSource(avatarSrc)
                reply.content = try cell.select("div.reply_content").text()
                reply.timeAgo = try cell.select("span.ago").text()
                let userLink = try cell.select("a.dark")
                reply.username = try userLink.text()
                reply.floor = try cell.select("span.no").text()
                
                replyList.append(reply)
            }
            return replyList
        } catch {
            print(error)
        }
        return []
    }
    
    class func parseTopicDetail(_ doc: Document) -> TopicDetail? {
        do {
            // header
            var detail = TopicDetail()
            let header = try doc.select("div.header")
            let authorAvatarSrc = try header.select("img").first()?.attr("src")
            detail.authorAvatarURL = avatarURLWithSource(authorAvatarSrc)
            detail.title = try header.select("h1").text()
            detail.author = try header.select("small a").text()
            detail.small = try header.select("small").text()
            detail.contentHTML = try doc.select("div.topic_content").html()
            
            return detail
        } catch {
            print(error)
            return nil
        }
    }
    
    class func avatarURLWithSource(_ src: String?) -> URL? {
        guard let src = src else {
            return nil
        }
        if src.hasPrefix("//") {
            return URL(string: "https:" + src)
        } else {
            return URL(string: src)
        }
    }
    
    class func parseTopicListCell(_ cell: Element) -> Topic {
        var topic = Topic()
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
                    topic.url = URL(string: baseURLString + String(link.split(separator: "#")[0]))
                } else {
                    topic.url = URL(string: baseURLString + link)
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
                topic.nodeName = nodename.replacingOccurrences(of: "/go/", with: "")
            }
        }
        return topic
    }
    
    // has performance issue
    class func parseNodeNavigations(_ doc: Document) {
        
        do {
            print("begin....")
            print(CFAbsoluteTimeGetCurrent())
            let planes = try doc.select("a[href=/planes]")
            
            print(CFAbsoluteTimeGetCurrent())
            let div = planes.parents().parents()
            print(CFAbsoluteTimeGetCurrent())
            let nodes = try div.select("a[href*=/go/]")
            print(CFAbsoluteTimeGetCurrent())
            for node in nodes {
                print(try node.text())
            }
        } catch {
            print(error)
        }
        
    }
}
