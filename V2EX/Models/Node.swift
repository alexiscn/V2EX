//
//  Node.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/11/26.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation

class Node: Codable {
    
    public let name: String
    
    public let title: String
 
    public let letter: String
}

struct NodeGroup {
    
    var nodes: [Node]
    
    var title: String
}
