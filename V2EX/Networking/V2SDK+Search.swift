//
//  V2SDK+Search.swift
//  V2EX
//
//  Created by xushuifeng on 2018/6/26.
//

import Foundation
import GenericNetworking

//https://github.com/bynil/sov2ex/blob/master/API.md
extension V2SDK {
    /// 搜索
    ///
    /// - Parameters:
    ///   - key: 查询关键词
    ///   - from: 与第一个结果的偏移量（默认 0），比如 0, 10, 20
    ///   - options: 搜索选项
    ///   - completion: 请求回调
    public class func search(key: String, from: Int = 0, options: SearchOptions = SearchOptions.default, completion: @escaping GenericNetworkingCompletion<SearchResponse>) {
        var params: [String: Any] = [:]
        params["q"] = key
        params["size"] = options.size
        params["sort"] = options.sort.rawValue
        params["from"] = from
        if let node = options.node {
            params["node"] = node
        }
        GenericNetworking.getJSON(URLString: "https://www.sov2ex.com/api/search", parameters: params, headers: nil, completion: completion)
    }
}


public struct SearchOptions {
    /// 结果数量（默认 10）    0 - 50
    var size: Int = 30
    /// 结果排序方式（默认 sumup)    sumup（权重）, created（发帖时间）
    var sort: Sort = .sumup
    /// 升降序，sort 不为 sumup 时有效（默认 降序）    0（降序）, 1（升序）
    var order: Order = .descending
    /// 指定节点名称
    var node: String?
    /// 关键词关系参数    or（默认）, and
    var `operator`: Operator = .or
    
    //        gte    int    false    最早发帖时间    epoch_second
    //        lte    int    false    最晚发帖时间    epoch_second
    
    public enum Order: Int {
        case descending = 0
        case ascending = 1
    }
    
    public enum Sort: String {
        case sumup, created
    }
    
    public enum Operator: String {
        case or, and
    }
    
    public static var `default`: SearchOptions {
        return SearchOptions(size: 30, sort: .sumup, order: .descending, node: nil, operator: .or)
    }
}

struct SearchResponse: Codable {
    /// 搜索过程耗时(ms)
    let took: Int
    /// 是否超时
    let timed_out: Bool
    /// 命中主题总数
    let total: Int
    /// 主题列表
    let hits: [SearchHit]
}

struct SearchHit: Codable {
    
    enum CodingKeys: String, CodingKey {
        case score = "_score"
        case source = "_source"
        case highlight
    }
    
    let score: Float?
    
    let source: SearchHitSource
    
    let highlight: SearchHitHighlight?
}

struct SearchHitSource: Codable {
    
    enum CodingKeys: String, CodingKey {
        case nodeID = "node"
        case replies
        case created
        case member
        case topicID = "id"
        case title
        case content
    }
    /// 节点 id
    let nodeID: Int
    /// 回复数量
    let replies: Int
    /// 创建时间(UTC)
    let created: String
    /// 主题作者
    let member: String
    /// 主题 id
    let topicID: Int
    /// 主题标题
    let title: String
    /// 主题内容
    let content: String
}

struct SearchHitHighlight: Codable {
    
    enum CodingKeys: String, CodingKey {
        case title
        case content
        case postscript = "postscript_list.content"
        case replyList = "reply_list.content"
    }
    
    /// 标题高亮（最多 1 条）
    let title: [String]?
    /// 主题内容高亮（最多 1 条）
    let content: [String]?
    /// 附言高亮（最多 1 条）
    let postscript: [String]?
    /// 回复高亮（最多 1 条）
    let replyList: [String]?
}
