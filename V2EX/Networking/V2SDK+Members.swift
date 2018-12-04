//
//  V2SDK+Members.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/6/22.
//

import Foundation
import GenericNetworking
import SwiftSoup

extension V2SDK {
    
    /// 获取用户信息
    ///
    /// - Parameters:
    ///   - username: 用户名称
    ///   - completion: 请求回调
    public class func getMember(username: String, completion: @escaping GenericNetworkingCompletion<Int>) {
        let path = "/api/members/show.json"
        let params = ["username": username]
        GenericNetworking.getJSON(path: path, parameters: params, completion: completion)
    }
    
    
    /// 获取用户信息
    ///
    /// - Parameters:
    ///   - userID: 用户ID
    ///   - completion: 请求回调
    public class func getMember(userID: Int, completion: @escaping GenericNetworkingCompletion<Int>) {
        let path = "/api/members/show.json"
        let params = ["id": userID]
        GenericNetworking.getJSON(path: path, parameters: params, completion: completion)
    }
    
    class func getUserProfile(name: String, completion: @escaping UserProfileRequestCompletion) {
        let url = baseURLString + "/member/" + name
        loadHTMLString(urlString: url) { (html, error) in
            guard let html = html else {
                completion(nil, error)
                return
            }
            do {
                let doc = try SwiftSoup.parse(html)
                let mainDiv = try doc.select("div#Main").first()
                let username = try mainDiv?.select("h1").first()?.text()
                let created = try mainDiv?.select("span.gray").first()?.text()
                let avatar = try mainDiv?.select("img.avatar").first()?.attr("src")
                let avatarURL = avatarURLWithSource(avatar)
                let info = UserInfo(username: username, avatarURL: avatarURL, createdInfo: created)
                
                var topics: [Topic] = []
                let cells = try doc.select("div.cell")
                for cell in cells {
                    if !cell.hasClass("cell item") {
                        continue
                    }
                    let topic = parseTopicListCell(cell)
                    topic.avatar = avatarURL
                    topics.append(topic)
                }
                
                let comments = parseUserReply(doc: doc)
                for comment in comments {
                    comment.avatarURL = avatarURL
                    comment.username = username
                }
                
                var profile = UserProfileResponse()
                profile.info = info
                profile.topics = topics
                profile.comments = parseUserReply(doc: doc)
                completion(profile, nil)
            } catch {
                print(error)
                completion(nil, error)
            }
        }
    }
    
    class func parseUserReply(doc: Document) -> [UserProfileComment] {
        do {
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
                        if let url = URL(string: baseURLString + topicHref) {
                            comment.originTopicURL = URL(string: baseURLString + url.path)
                        }
                    }
                    
                    let reply = replyCells[index]
                    comment.commentContent = try reply.text()
                    comment.commentContentHTML = try reply.html()
                    comments.append(comment)
                }
            }
        } catch {
            print(error)
        }
        return []
    }
    
}
