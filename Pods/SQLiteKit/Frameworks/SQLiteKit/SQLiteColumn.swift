//
//  SQLiteColumn.swift
//  SQLiteKit
//
//  Created by xu.shuifeng on 2018/5/24.
//  Copyright © 2018 Meteor. All rights reserved.
//

import Foundation

public enum SQLiteDataType: String {
    case null = "NULL"
    case time = "TIMESTAMP"
    case string = "VARCHAR(50)"
    case float = "REAL"
    case int = "INTEGER"
    case text = "TEXT"
    case data = "BLOB"
}

/// Represent SQLite Column Item
public struct SQLiteColumn: CustomStringConvertible {

    /// column field name
    public let name: String
    
    /// column field data type
    public let dataType: SQLiteDataType
    
    /// whether column is primary key, default to `false`
    public var primaryKey: Bool = false
    
    /// whether column should auto increase. Default to `false`
    public var autoIncrement: Bool = false
    
    /// whether should create index. Default to `false`
    public var createIndex: Bool = false
    
    public init(name: String, dataType: SQLiteDataType) {
        self.name = name
        self.dataType = dataType
    }
    
    public var description: String {
        get {
            var sql = String(format: "%@ %@", name, dataType.rawValue)
            if primaryKey {
                sql += " PRIMARY KEY"
            }
            if autoIncrement {
                sql += " AUTOINCREMENT"
            }
            return sql
        }
    }
}
