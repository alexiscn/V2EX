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

typealias V2SDKLoadNodeTopicsCompletion = (NodeDetail, Error?) -> Void

typealias V2SDKLoadTopicDetailCompletion = (TopicDetail?, [Reply], Error?) -> Void

typealias V2SDKLoadTopicReplyCompletion = ([Reply], Error?) -> Void

typealias AccountCompletion = (LoginFormData?, Error?) -> Void

class V2SDK {
    
    static let baseURLString = "https://www.v2ex.com"
    
    static var shouldParseHotNodes: Bool = true
    
    class func httpHeaders(path: String) -> [String: String]? {
        
        var headers: [String: String] = Alamofire.SessionManager.defaultHTTPHeaders
        if path == "/signin" {
            headers["Referer"] = baseURLString
            headers["User-Agent"] = "Mozilla/5.0 (iPhone; CPU iPhone OS 10_3 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.3 Mobile/14E277 Safari/603.1.30"
            return headers
        }
        return nil
    }
    
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
    
    class func post(url: URL, params: Parameters?, headers: HTTPHeaders? = nil, completion: @escaping (String?, Error?) -> Void) {
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseData { dataResponse in
            guard let data = dataResponse.data, let html = String(data: data, encoding: .utf8) else {
                completion(nil, dataResponse.error)
                return
            }
            completion(html, nil)
        }
    }
}

extension String {
    
    func trimed() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
}
