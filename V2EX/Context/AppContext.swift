//
//  AppContext.swift
//  V2EX
//
//  Created by alexiscn on 2018/11/26.
//  Copyright © 2018 alexiscn. All rights reserved.
//

import Foundation

class AppContext {
    
    static let current = AppContext()
    
    var account: Account?
    
    var isLogined: Bool { return account != nil }
    
    var font: AppFont = NormalFonts()
    
    private init() {
        
    }
    
    func setup() {
        Theme.current = Theme(rawValue: AppSettings.shared.theme) ?? .dark
    }
    
    func doLogout() {
        HTTPCookieStorage.shared.cookies?.forEach { HTTPCookieStorage.shared.deleteCookie($0) }
        URLCache.shared.removeAllCachedResponses()
        account = nil
        NotificationCenter.default.post(name: NSNotification.Name.V2.AccountUpdated, object: nil)
    }
}
