//
//  V2SDK.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/6/22.
//

import Foundation
import GenericNetworking
import Alamofire

struct UserAgents {
    static let phone = "Mozilla/5.0 (iPhone; CPU iPhone OS 10_3 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.3 Mobile/14E277 Safari/603.1.30"
}

enum ApiPath: String {
    case signin = "signin"
    case member
    case missionDaily = "/mission/daily"
    
    var urlString: String {
        return V2SDK.baseURLString + rawValue
    }
    
    var httpHeaders: [String: String] {
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        switch self {
        case .signin:
            headers["Referer"] = V2SDK.baseURLString + "/signin"
            headers["User-Agent"] = UserAgents.phone
        default:
            break
        }
        return headers
    }
}

enum ServerError: Error {
    case needsSignIn
    case needsTwoFactor
}

protocol ServerResponse { }

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
