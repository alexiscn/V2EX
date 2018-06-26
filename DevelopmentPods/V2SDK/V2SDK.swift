//
//  V2SDK.swift
//  Pods
//
//  Created by xu.shuifeng on 2018/6/22.
//

import Foundation
import GenericNetworking
import Alamofire

public typealias TopicList = [Topic]

public typealias V2SDKLoadTimelineCompletion = (TopicList, Error?) -> Void

public typealias V2SDKLoadTopicDetailCompletion = (Topic?, Error?) -> Void

public class V2SDK {
    
    public class func setup() {
        GenericNetworking.baseURLString = "https://www.v2ex.com"
    }
    
    internal class func loadHTMLString(url: URL, completion: @escaping (String?, Error?) -> Void) {
        Alamofire.request(url).responseData { (dataResponse) in
            guard let data = dataResponse.data, let html = String(data: data, encoding: .utf8) else {
                completion(nil, dataResponse.error)
                return
            }
            completion(html, nil)
        }
    }
}
