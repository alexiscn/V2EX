//
//  V2SDK+Account.swift
//  V2EX
//
//  Created by xushuifeng on 2018/12/1.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import Alamofire
import SwiftSoup

extension V2SDK {
    
    class func login(username: String, password: String, captcha: String, formData: LoginFormData, completion: @escaping LoginCompletion) {
        let urlString =  baseURLString + "/signin"
        let url = URL(string: urlString)!
        var params: [String: String] = [:]
        params["next"] = "/"
        params["once"] = formData.once
        params[formData.username] = username
        params[formData.password] = password
        params[formData.captcha] = captcha
        
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Referer"] = V2SDK.baseURLString + "/signin"
        headers["User-Agent"] = UserAgents.phone
        
        post(url: url, params: params, headers: headers) { (html, error) in
            guard let html = html else {
                completion(nil, error)
                return
            }
            do {
                let doc = try SwiftSoup.parse(html)
                let title = try doc.title()
                if title.contains("两步验证登录") {
                    return
                }
    
                if html.contains("/mission/daily") {
                    if let imgElement = try doc.select("img.avatar").first(),
                        let member = try imgElement.parent()?.attr("href") {
                        let src = try imgElement.attr("src")
                        let avatarURLString = avatarURLWithSource(src)
                        let name = member.replacingOccurrences(of: "/member/", with: "")
                        let account = Account(username: name, avatarURLString: avatarURLString?.absoluteString)
                        completion(account, nil)
                    }
                }
                
            } catch {
                print(error)
                completion(nil, error)
            }
        }
    }
}
