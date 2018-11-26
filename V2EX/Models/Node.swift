//
//  Node.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/11/26.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import WCDBSwift

class Node: TableCodable {
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = Node
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        case name
        case title
        case letter
        
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [:]
        }
    }
    
    var name: String
    
    var title: String
 
    var letter: String
    
    init(name: String, title: String, letter: String) {
        self.name = name
        self.title = title
        self.letter = letter
    }
    
    static let `default` = Node.nodeWithName("v2ex", title: "V2EX")
    
    class func nodeWithName(_ name: String, title: String) -> Node {
        var letter = ""
        let str = NSMutableString(string: title) as CFMutableString
        if CFStringTransform(str, nil, kCFStringTransformToLatin, false) && CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false) {
            letter = String(((str as NSString) as String).first!).uppercased()
        } else {
            letter = ""
        }
        return Node(name: name, title: title, letter: letter)
    }
}

class NodeGroup {
    
    var title: String
    
    var nodes: [Node]
    
    init(title: String, nodes: [Node]) {
        self.title = title
        self.nodes = nodes
    }
}
