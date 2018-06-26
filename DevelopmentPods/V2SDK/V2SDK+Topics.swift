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
    ///   - page: 当前页码，从0开始
    ///   - completion: 请求回调
    public class func getTopicList(tab: V2Tabs, page: Int, completion: @escaping V2SDKLoadingCompletion) {
        let url = String(format: "https://www.v2ex.com/?tab=%@&page=%d", tab.rawValue, page)
        Alamofire.request(url).responseData { (dataResponse) in
            guard let data = dataResponse.data, let html = String(data: data, encoding: .utf8) else {
                completion([], dataResponse.error)
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
                    let topic = self.parseTopicListCell(cell)
                    topics.append(topic)
                }
                completion(topics, nil)
            } catch {
                completion([], error)
            }
        }
    }
    
    public class func getTopicDetail(_ topicURL: URL, completion: @escaping V2SDKLoadingCompletion) {
        Alamofire.request(topicURL).responseData { dataResponse in
            
        }
    }
    
    class func loadHTMLString(url: URL) {
        
    }
}

extension V2SDK {
    
    class func parseTopicDetail() {
        
    }
    
    class func parseTopicListCell(_ cell: Element) -> Topic {
        var topic = Topic()
        var member = Member()
        // parse avatar
        if let img = try? cell.select("img").first(), let imgEle = img, let src = try? imgEle.attr("src") {
            if src.hasPrefix("//") {
                member.avatar = URL(string: "https:" + src)
            } else {
                member.avatar = URL(string: src)
            }
        }
        // parse members
        if let members = try? cell.select("strong") {
            if let m1 = members.first() {
                member.username = try? m1.text()
                if let m2 = members.last(), m1 != m2 {
                    var replyMember = Member()
                    replyMember.username = try? m2.text()
                    topic.lastReplyedUser = replyMember
                }
            }
        }
        
        // parse topic title
        if let titleElement = try? cell.select("span.item_title").first() {
            if let title = try? titleElement?.text() {
                topic.title = title
            }
            if let href = try? titleElement?.select("a").attr("href"), let link = href {
                let topicLink = link.replacingOccurrences(of: "/t/", with: "")
                if topicLink.contains("#") {
                    topic.id = Int(topicLink.split(separator: "#")[0])
                } else {
                    topic.id = Int(topicLink)
                }
                topic.url = URL(string: "https://www.v2ex.com" + link)
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
            var node = Node()
            if let title = try? nodeElement?.text() {
                node.title = title
            }
            if let name = try? nodeElement?.attr("href"), let nodename = name {
                node.name = nodename.replacingOccurrences(of: "/go/", with: "")
            }
            topic.node = node
        }
        topic.member = member
        return topic
    }
}
