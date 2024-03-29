//
//  Topic.swift
//  V2EX
//
//  Created by alexiscn on 2018/11/17.
//  Copyright © 2018 alexiscn. All rights reserved.
//

import Foundation
import WCDBSwift

class Topic: TableCodable, DataType {
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = Topic
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        case title
        case url
        case replies
        case username
        case avatar
        case lastReplyedUserName
        case nodeName
        case nodeTitle
        case tab
        case lastUpdatedTime
        case topicID
        
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [:]
        }
    }
    
    
    // this property is not stored in database
    var _rowHeight: CGFloat = 0
    
    var title: String? = nil
    
    var url: URL? = nil
    
    var replies: Int = 0
    
    var username: String? = nil
    
    var avatar: URL? = nil
    
    var lastReplyedUserName: String? = nil
    
    var nodeName: String? = nil
    
    var nodeTitle: String? = nil
    
    var tab: String = ""
    
    var lastUpdatedTime: String? = nil
    
    var topicID: String?
    
    init() {
        
    }
    
}
