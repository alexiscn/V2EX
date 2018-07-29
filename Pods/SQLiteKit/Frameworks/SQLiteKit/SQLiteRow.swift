//
//  SQLiteRow.swift
//  SQLiteKit
//
//  Created by xu.shuifeng on 2018/5/24.
//  Copyright © 2018 Meteor. All rights reserved.
//

import Foundation

public typealias SQLiteRowList = [SQLiteRow]

public class SQLiteRow {
    
    let dataDict: [AnyHashable: Any]
    
    public init(dictionary: [AnyHashable: Any]) {
        self.dataDict = dictionary
    }
    
    public func decode<T: SQLiteModelProtocol>(type: T.Type) -> T? {
        if let data = try? JSONSerialization.data(withJSONObject: dataDict, options: .prettyPrinted) {
            return try? JSONDecoder().decode(T.self, from: data)
        }
        return nil
    }
}
