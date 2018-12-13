//
//  LanguageManager.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/12/12.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation

fileprivate var bundleKey: UInt8 = 0

enum Language: String {
    case none
    case en = "en"
    case zhHans = "zh-Hans"
    
    var title: String {
        switch self {
        case .none:
            return "Follow System"
        case .en:
            return "English"
        case .zhHans:
            return "简体中文"
        }
    }
}

class LanguageManager {
    
    static let shared = LanguageManager()
    
    var currentLanguage: Language {
        get {
            if let langList = UserDefaults.standard.value(forKey: "AppleLanguages") as? [String], let lang = langList.first {
                return Language(rawValue: lang) ?? .none
            }
            return .none
        }
        set {
            if newValue == .none {
                UserDefaults.standard.setValue(nil, forKey: "AppleLanguages")
            } else {
                Bundle.setLanguage(newValue.rawValue)
                UserDefaults.standard.setValue([newValue.rawValue], forKey: "AppleLanguages")
            }
        }
    }
    
    func supporttedLanguages() -> [Language] {
        return [.none, .en, .zhHans]
    }
    
}

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
