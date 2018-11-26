//
//  V2SDK.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/6/22.
//

import Foundation
import GenericNetworking
import Alamofire

typealias TopicList = [Topic]

typealias V2SDKLoadTimelineCompletion = (TopicList, Error?) -> Void

typealias V2SDKLoadTopicDetailCompletion = (TopicDetail?, [Reply], Error?) -> Void

typealias V2SDKLoadTopicReplyCompletion = ([Reply], Error?) -> Void

class V2SDK {
    
    static let baseURLString = "https://www.v2ex.com"
    
    static var shouldParseHotNodes: Bool = true
    
    class func setup() {
        GenericNetworking.baseURLString = baseURLString
    }
    
    class func loadHTMLString(url: URL, completion: @escaping (String?, Error?) -> Void) {
        Alamofire.request(url).responseData { (dataResponse) in
            guard let data = dataResponse.data, let html = String(data: data, encoding: .utf8) else {
                completion(nil, dataResponse.error)
                return
            }
            completion(html, nil)
        }
    }
    
    class func checkIfNeedsSignIn(dataResponse: DataResponse<Data>) -> Bool {
        let path = "/signin"
        if dataResponse.response?.url?.path == path && dataResponse.request?.url?.path != path {
            return true
        }
        return false
    }
}

extension String {
    
    func trimed() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
}
