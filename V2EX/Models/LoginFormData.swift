//
//  LoginModel.swift
//  V2EX
//
//  Created by alexiscn on 2018/12/1.
//  Copyright © 2018 alexiscn. All rights reserved.
//

import Foundation

struct LoginFormData {
    let username: String
    let password: String
    let captcha: String
    let once: String
}

struct LoginPostData {
    let username: String
    let password: String
    let captcha: String
}
