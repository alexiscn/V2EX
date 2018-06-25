//
//  V2SDK.swift
//  Pods
//
//  Created by xu.shuifeng on 2018/6/22.
//

import Foundation
import GenericNetworking


public typealias TopicList = [Topic]

public typealias V2SDKLoadingCompletion = (TopicList, Error?) -> Void



public class V2SDK {
    
    public class func setup() {
        GenericNetworking.baseURLString = "https://www.v2ex.com"
    }
}
