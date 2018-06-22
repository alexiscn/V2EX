//
//  V2SDK+Replies.swift
//  V2SDK
//
//  Created by xu.shuifeng on 2018/6/22.
//

import Foundation
import GenericNetworking

extension V2SDK {
    
    /// 获取主题回复
    ///
    /// - Parameters:
    ///   - topicID: 主题 id
    ///   - completion: 请求回调
    public class func getTopicReplies(topicID: Int, completion: @escaping GenericNetworkingCompletion<Reply>) {
        let path = "/replies/show.json"
        let params = ["topic_id": topicID]
        GenericNetworking.getJSON(path: path, parameters: params, completion: completion)
    }
    
}
