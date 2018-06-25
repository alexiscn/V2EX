//
//  V2SDK+Search.swift
//  V2SDK
//
//  Created by xushuifeng on 2018/6/26.
//

import Foundation
import GenericNetworking

public struct SearchOptions {
    /// 结果数量（默认 10）    0 - 50
    var size: Int = 50
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
        return SearchOptions(size: 50, sort: .sumup, order: .descending, node: nil, operator: .or)
    }
}

extension V2SDK {
    /// 搜索
    ///
    /// - Parameters:
    ///   - key: 查询关键词
    ///   - from: 与第一个结果的偏移量（默认 0），比如 0, 10, 20
    ///   - options: 搜索选项
    ///   - completion: 请求回调
    public class func search(key: String, from: Int = 0, options: SearchOptions = SearchOptions.default, completion: @escaping GenericNetworkingCompletion<Int>) {
        //https://github.com/bynil/sov2ex/blob/master/API.md
        
        var params: [String: Any] = [:]
        params["q"] = key
        
        GenericNetworking.postJSON(URLString: "https://www.sov2ex.com/api/search", parameters: params, headers: nil, completion: completion)
    }
}
