//
//  V2SDK.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/6/22.
//

import Foundation
import GenericNetworking
import Alamofire
import SwiftSoup

struct UserAgents {
    static let phone = "Mozilla/5.0 (iPhone; CPU iPhone OS 10_3 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.3 Mobile/14E277 Safari/603.1.30"
}

enum ServerError: Error {
    case needsSignIn
    case needsTwoFactor
    case parseHTMLError
    case signInFailed
}

typealias RequestCompletionHandler<T> = (T?, Error?) -> Void

typealias V2SDKLoadTimelineCompletion = ([Topic], Error?) -> Void

typealias V2SDKLoadNodeTopicsCompletion = (NodeDetail, Error?) -> Void

typealias V2SDKLoadTopicDetailCompletion = (TopicDetail?, [Reply], Error?) -> Void

typealias V2SDKLoadTopicReplyCompletion = ([Reply], Error?) -> Void

typealias AccountCompletion = (LoginFormData?, Error?) -> Void

typealias LoginCompletion = (Account?, Error?) -> Void

typealias UserProfileRequestCompletion = (UserProfileResponse?, Error?) -> Void

class V2SDK {
    
    static let baseURLString = "https://www.v2ex.com"
    
    static var shouldParseHotNodes: Bool = true
    
    static var shouldParseAccount: Bool = true
    
    class func setup() {
        GenericNetworking.baseURLString = baseURLString
    }
    
    class func avatarURLWithSource(_ src: String?) -> URL? {
        guard let src = src else {
            return nil
        }
        if src.hasPrefix("//") {
            return URL(string: "https:" + src)
        } else {
            return URL(string: src)
        }
    }
    
    class func captchaURL(once: String) -> URL {
        let urlString = baseURLString + "/_captcha?once=" + once
        return URL(string: urlString)!
    }
    
    class func loadHTMLString(urlString: String, completion: @escaping (String?, Error?) -> Void) {
        let url = URL(string: urlString)!
        loadHTMLString(url: url, completion: completion)
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
    
    class func request<T>(_ endPoint: EndPoint, parser: HTMLParser.Type, completion: @escaping RequestCompletionHandler<T>) {
        let dataResponse = Alamofire.request(endPoint)
        dataResponse.responseString { response in
            guard let html = response.value else {
                completion(nil, ServerError.needsSignIn)
                return
            }
            // 需要登录才能访问
            if response.response?.url?.path == "/signin" && response.request?.url?.path != "/signin" {
                completion(nil, ServerError.needsSignIn)
                return
            }
            
            do {
                let doc = try SwiftSoup.parse(html)
                let result: T? = try parser.handle(doc)
                completion(result, nil)
            } catch {
                print(error)
                completion(nil, error)
            }
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
    
    public class func getAllNodes(completion: @escaping GenericNetworkingCompletion<Int>) {
        let path = "/api/nodes/all.json"
        GenericNetworking.getJSON(path: path, completion: completion)
    }
}

extension String {
    
    func trimed() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
}
