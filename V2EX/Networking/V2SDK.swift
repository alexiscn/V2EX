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

enum V2Error: Error, CustomStringConvertible {
    case needsSignIn
    case needsTwoFactor
    case parseHTMLError
    case signInFailed
    case severNotFound
    
    var description: String {
        switch self {
        case .needsSignIn:
            return NSLocalizedString("需要登录后才能查看", comment: "")
        case .needsTwoFactor:
            return NSLocalizedString("开启了两步验证", comment: "")
        case .parseHTMLError:
            return NSLocalizedString("服务器解析错误", comment: "")
        case .signInFailed:
            return NSLocalizedString("登录失败", comment: "")
        case .severNotFound:
            return NSLocalizedString("服务器暂时开小差了，请稍后再试", comment: "")
        }
    }
}

enum V2Response<T> {
    case success(T)
    case error(V2Error)
}

typealias RequestCompletionHandler<T> = (V2Response<T>) -> Void

class V2SDK {
    
    static let baseURLString = "https://www.v2ex.com"
    
    static var shouldParseHotNodes: Bool = true
    
    static var shouldParseAccount: Bool = true
    
    static var once: String? = nil
    
    class func setup() {
        GenericNetworking.baseURLString = baseURLString
    }
    
    class func captchaURL(once: String) -> URL {
        let urlString = baseURLString + "/_captcha?once=" + once
        return URL(string: urlString)!
    }
    
    class func request<T>(_ endPoint: EndPoint, parser: HTMLParser.Type, completion: @escaping RequestCompletionHandler<T>) {
        let dataResponse = Alamofire.request(endPoint)
        dataResponse.responseString { response in
            guard let html = response.value else {
                completion(V2Response.error(.severNotFound))
                return
            }
            // 需要登录才能访问
            if response.response?.url?.path == "/signin" && response.request?.url?.path != "/signin" {
                completion(V2Response.error(.needsSignIn))
                return
            }
            
            do {
                let doc = try SwiftSoup.parse(html)
                let result: T? = try parser.handle(doc)
                if let result = result {
                    completion(V2Response.success(result))
                } else {
                    completion(V2Response.error(.severNotFound))
                }
            } catch {
                print(error)
                completion(V2Response.error(.parseHTMLError))
            }
        }
    }
    
    public class func getAllNodes(completion: @escaping GenericNetworkingCompletion<Int>) {
        let path = "/api/nodes/all.json"
        GenericNetworking.getJSON(path: path, completion: completion)
    }
    
    public class func dailyMission() {
        guard let token = self.once else { return }

        request(EndPoint.dailyMission(once: token), parser: DailyMissionParser.self) { (response: V2Response<DailyMission>) in
            switch response {
            case .success(let mission):
                if let msg = mission.message {
                    HUD.show(message: msg)
                }
            case .error(let error):
                print(error.description)
            }
        }
    }
}
