//
//  V2SDK+Members.swift
//  Pods
//
//  Created by xu.shuifeng on 2018/6/22.
//

import Foundation
import GenericNetworking

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
    
}
