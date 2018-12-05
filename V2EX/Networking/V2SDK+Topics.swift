//
//  V2SDK+Topics.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/6/22.
//

import Foundation
import GenericNetworking
import Alamofire
import SwiftSoup
import AVFoundation
//
//extension V2SDK {
//    
//    class func parseTopicListCell(_ cell: Element, isNodeList: Bool = false) -> Topic {
//        let topic = Topic()
//        // parse avatar
//        if let img = try? cell.select("img").first(), let imgEle = img, let src = try? imgEle.attr("src") {
//            topic.avatar = avatarURLWithSource(src)
//        }
//        // parse members
//        if let members = try? cell.select("strong") {
//            if let m1 = members.first() {
//                topic.username = try? m1.text()
//                if let m2 = members.last(), m1 != m2 {
//                    topic.lastReplyedUserName = try? m2.text()
//                }
//            }
//        }
//        
//        // parse topic title
//        if let titleElement = try? cell.select("span.item_title").first() {
//            if let title = try? titleElement?.text() {
//                topic.title = title
//            }
//            if let href = try? titleElement?.select("a").attr("href"), let link = href {
//                if link.contains("#") {
//                    topic.url = URL(string: baseURLString + String(link.split(separator: "#")[0]))
//                } else {
//                    topic.url = URL(string: baseURLString + link)
//                }
//            }
//        }
//        
//        // parse reply count
//        if let countElement = try? cell.select("a.count_livid").first() {
//            if let count = try? countElement?.text(), let c = count {
//                topic.replies = Int(c)!
//            }
//        }
//        
//        // parse node
//        if let nodeElement = try? cell.select("a.node").first() {
//            if let title = try? nodeElement?.text() {
//                topic.nodeTitle = title
//            }
//            if let name = try? nodeElement?.attr("href"), let nodename = name {
//                topic.nodeName = nodename.replacingOccurrences(of: "/go/", with: "")
//            }
//        }
//        if let text = try? cell.text() {
//            let components = text.split(separator: "•")
//            if components.count >= 3 {
//                if isNodeList {
//                    topic.lastUpdatedTime = String(components[1]).trimed()
//                    topic.lastReplyedUserName = String(components[2]).trimed()
//                } else {
//                    topic.lastUpdatedTime = String(components[2]).trimed()
//                    if components.count >= 4 {
//                        topic.lastReplyedUserName = String(components[3]).trimed()
//                    }
//                }
//            }
//        }
//        return topic
//    }
//    
//    
//}
