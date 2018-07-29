//
//  SQLiteTable.swift
//  SQLiteKit
//
//  Created by xu.shuifeng on 2018/5/24.
//

import Foundation

/// Type to reflect to a database table
public protocol SQLiteTable: class, Codable {
    
    /// Required initializer. used for Mirror reflecting of Object ORM
    init()

    /// Specifiy column attributes of a table, eg: isPK
    ///
    /// - Returns: column attributes
    static func attributes() -> [SQLiteAttribute]
    
}

extension SQLiteTable {

    /// Return mapping type of SQLiteTable
    internal var mapType: SQLiteTable.Type {
        let mirror = Mirror(reflecting: self)
        return mirror.subjectType as! SQLiteTable.Type
    }
}
