//
//  BundleExtensions.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/12/12.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation

fileprivate var bundleKey: UInt8 = 0

class AppBundle: Bundle {
    
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        guard let path = objc_getAssociatedObject(self, &bundleKey) as? String, let bundle = Bundle(path: path) else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
    
}

extension Bundle {
    
    class func setLanguage(_ code: String) {
        defer {
            object_setClass(Bundle.main, AppBundle.self)
        }
        let path = Bundle.main.path(forResource: code, ofType: "lproj")
        objc_setAssociatedObject(Bundle.main, &bundleKey, path, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
}
