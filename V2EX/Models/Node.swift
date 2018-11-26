//
//  Node.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/11/26.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation

class Node: Codable {
    
    var name: String
    
    var title: String
 
    var letter: String
    
    init(name: String, title: String) {
        self.name = name
        self.title = title
        
        let str = NSMutableString(string: title) as CFMutableString
        if CFStringTransform(str, nil, kCFStringTransformToLatin, false) && CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false) {
            self.letter = String(((str as NSString) as String).first!).uppercased()
        } else {
            self.letter = ""
        }
    }
    
    static let `default` = Node(name: "v2ex", title: "V2EX")
}

struct NodeGroup {
    
    var nodes: [Node]
    
    var title: String
}
