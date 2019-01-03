//
//  EndPoint.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/12/5.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import Alamofire

struct EndPoint {
    
    let path: String
    
    let method: HTTPMethod
    
    let parameters: Parameters?
    
    let headers: HTTPHeaders?
    
    init(path: String, method: HTTPMethod = .get, parameters: Parameters? = nil, headers: HTTPHeaders? = nil) {
        self.path = path
        self.method = method
        self.parameters = parameters
        self.headers = headers
    }
}

extension EndPoint: URLRequestConvertible {
    
    internal var url: URL {
        return URL(string: V2SDK.baseURLString.appending(path))!
    }
    
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        var urlRequest = try URLEncoding().encode(request, with: parameters)
        urlRequest.allHTTPHeaderFields = headers
        return urlRequest
    }
}


extension EndPoint {
    
    static func tab(_ tab: String) -> EndPoint {
        let path = "/?tab=\(tab)"
        return EndPoint(path: path)
    }
    
    static func recent(_ page: Int = 1) -> EndPoint {
        let path = "/recent?p=\(page)"
        return EndPoint(path: path)
    }
    
    static func memberProfile(_ username: String) -> EndPoint {
        let path = "/member/" + username
        return EndPoint(path: path)
    }
    
    static func memberTopics(_ username: String, page: Int) -> EndPoint {
        let path = "/member/\(username)/topics?p=\(page)"
        return EndPoint(path: path)
    }
    
    static func memberReplies(_ username: String, page: Int) -> EndPoint {
        let path = "/member/\(username)/replies?p=\(page)"
        return EndPoint(path: path)
    }
    
    static func node(_ node: String, page: Int = 1) -> EndPoint {
        let path = "/go/\(node)?p=\(page)"
        return EndPoint(path: path)
    }
    
    static func topicDetail(_ topicID: String, page: Int = 1) -> EndPoint {
        let path = "/t/\(topicID)?p=\(page)"
        return EndPoint(path: path)
    }
    
    static func onceToken() -> EndPoint {
        let path = "/signin"
        return EndPoint(path: path)
    }
    
    static func signIn(username: String, password: String, captcha: String, formData: LoginFormData) -> EndPoint {
        let path = "/signin"
        var params: [String: String] = [:]
        params["next"] = "/"
        params["once"] = formData.once
        params[formData.username] = username
        params[formData.password] = password
        params[formData.captcha] = captcha
        
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Referer"] = V2SDK.baseURLString + path
        headers["User-Agent"] = UserAgents.phone
        
        return EndPoint(path: path, method: .post, parameters: params, headers: headers)
    }
    
    static func googleSignIn(once: String) -> EndPoint {
        let path = "/auth/google?once=" + once
        return EndPoint(path: path)
    }
    
    static func signOut(once: String) -> EndPoint {
        let path = "/signout?once=" + once
        return EndPoint(path: path)
    }
    
    static func dailyMission(once: String) -> EndPoint {
        let path = "/mission/daily/redeem?once=" + once
        
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Referer"] = V2SDK.baseURLString + "/mission/daily"
        headers["User-Agent"] = UserAgents.phone
        
        return EndPoint(path: path, method: .get, parameters: nil, headers: headers)
    }
    
    static func myNodes() -> EndPoint {
        let path = "/my/nodes"
        return EndPoint(path: path)
    }
    
    static func myFollowing(page: Int) -> EndPoint {
        let path = "/my/following?p=\(page)"
        return EndPoint(path: path)
    }
    
    static func myFavoriteTopics(page: Int = 1) -> EndPoint {
        let path = "/my/topics?p=\(page)"
        return EndPoint(path: path)
    }
    
    static func balance(page: Int) -> EndPoint {
        let path = "/balance?p=\(page)"
        return EndPoint(path: path)
    }
    
    static func notifications(page: Int = 1) -> EndPoint {
        let path = "/notifications?p=\(page)"
        return EndPoint(path: path)
    }
    
    static func favoriteTopic(_ topicID: String, token: String) -> EndPoint {
        let path = "/favorite/topic/\(topicID)?t=\(token)"
        return EndPoint(path: path)
    }
    
    static func unfavoriteTopic(_ topicID: String, token: String) -> EndPoint {
        let path = "/unfavorite/topic/\(topicID)?t=\(token)"
        return EndPoint(path: path)
    }
    
    static func thankTopic(_ topicID: String, token: String) -> EndPoint {
        let path = "/thank/topic/\(topicID)?t=\(token)"
        return EndPoint(path: path)
    }
    
    static func thankReply(_ replyID: String, token: String) -> EndPoint {
        let path = "/thank/reply/\(replyID)?t=\(token)"
        return EndPoint(path: path)
    }
    
    static func reportTopic(_ topicID: String, token: String) -> EndPoint {
        let path = "/report/topic/\(topicID)?t=\(token)"
        return EndPoint(path: path)
    }
    
    static func commentTopic(_ topicID: String, once: String, content: String) -> EndPoint {
        let path = "/t/" + topicID
        var params: [String: String] = [:]
        params["content"] = content
        params["once"] = once
        
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["User-Agent"] = UserAgents.phone
        
        return EndPoint(path: path, method: .post, parameters: params, headers: headers)
    }
    
    static func createTopicOnce(_ nodename: String) -> EndPoint {
        let path = "/new/" + nodename
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Referer"] = V2SDK.baseURLString + path
        headers["User-Agent"] = UserAgents.phone
        return EndPoint(path: path, method: .post, parameters: nil, headers: headers)
    }

    static func createTopic(_ nodeName: String, title: String, once: String, body: String?) -> EndPoint {
        let path = "/new/" + nodeName
        var params: [String: String] = [:]
        params["title"] = title
        params["topic_content"] = body ?? ""
        params["once"] = once
        
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Referer"] = V2SDK.baseURLString + path
        headers["User-Agent"] = UserAgents.phone
        
        return EndPoint(path: path, method: .post, parameters: params, headers: headers)
    }
}
