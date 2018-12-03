//
//  AppContext.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/11/26.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation

class AppContext {
    
    static let current = AppContext()
    
    var account: Account?
    
    var isLogined: Bool { return account != nil }
    
    var font: AppFont = NormalFonts()
    
    private init() {
        
    }
}
