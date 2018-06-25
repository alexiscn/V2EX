//
//  V2SDK+Nodes.swift
//  V2SDK
//
//  Created by xu.shuifeng on 2018/6/22.
//

import Foundation
import GenericNetworking

extension V2SDK {
    
    public class func getNode(_ nodeName: String, completion: @escaping GenericNetworkingCompletion<Int>) {
        let path = "api/nodes/show.json"
        let params = ["name": nodeName]
        GenericNetworking.getJSON(path: path, parameters: params, completion: completion)
    }
    
    public class func getAllNodes(completion: @escaping GenericNetworkingCompletion<Int>) {
        let path = "/api/nodes/all.json"
        GenericNetworking.getJSON(path: path, completion: completion)
    }
}
