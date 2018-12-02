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
    
    class func captchaURL(once: String) -> URL {
        let urlString = baseURLString + "/_captcha?once=" + once
        return URL(string: urlString)!
    }
    
    class func checkIfNeedsSignIn(dataResponse: DataResponse<Data>) -> Bool {
        let path = "/signin"
        if dataResponse.response?.url?.path == path && dataResponse.request?.url?.path != path {
            return true
        }
        return false
    }
    
    class func refreshCode(completion: @escaping AccountCompletion) {
        let urlString =  baseURLString + "/signin"
        let url = URL(string: urlString)!
        loadHTMLString(url: url) { (html, error) in
            guard let html = html else {
                completion(nil, error)
                return
            }
            do {
                let doc = try SwiftSoup.parse(html)
                let keys = try doc.select("input.sl").array()
                if keys.count == 3 {
                    let username = try keys[0].attr("name")
                    let password = try keys[1].attr("name")
                    let captcha = try keys[2].attr("name")
                    let once = try doc.select("input[name=once]").attr("value")
                    let form = LoginFormData(username: username, password: password, captcha: captcha, once: once)
                    completion(form, nil)
                } else {
                    completion(nil, NSError(domain: "v2ex", code: 10001, userInfo: [NSLocalizedDescriptionKey: "不能解析网页内容"]))
                }
            } catch {
                print(error)
                completion(nil, error)
            }
        }
    }
    
    class func login(username: String, password: String, captcha: String, formData: LoginFormData, completion: @escaping LoginCompletion) {
        let urlString =  baseURLString + "/signin"
        let url = URL(string: urlString)!
        var params: [String: String] = [:]
        params["next"] = "/"
        params["once"] = formData.once
        params[formData.username] = username
        params[formData.password] = password
        params[formData.captcha] = captcha
        
        post(url: url, params: params, headers: httpHeaders(path: "/signin")) { (html, error) in
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
                    if let imgElement = try doc.select("img.avatar").first() {
                        let src = try imgElement.attr("src")
                        let member = try imgElement.parent()?.attr("href")
                        
                        let account = Account(username: member, avatarURL: nil)
                    }
                }
                
            } catch {
                print(error)
                completion(nil, error)
            }
        }
    }
}
