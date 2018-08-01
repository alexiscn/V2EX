//
//  SQLiteTable.swift
//  SQLiteKit
//
//  Created by xu.shuifeng on 2018/5/24.
//

import Foundation

public protocol SQLiteCodingKeyBase: CodingKey {
    var rootType: SQLiteCodingKeyBase.Type { get }
}

public protocol SQLiteCodingKey: SQLiteCodingKeyBase, Hashable {
    
    associatedtype base: SQLiteCodingKeyBase

}

/// Type to reflect to a database table
public protocol SQLiteCodable: Codable {

    //associatedtype CodingKeys: CodingKey
    
    /// Specifiy column attributes of a table, eg: isPK
    ///
    /// - Returns: column attributes
    static func attributes() -> [SQLiteAttribute]
    
    init()
}

extension SQLiteCodable {

    /// Return mapping type of SQLiteTable
    internal var mapType: SQLiteCodable.Type {
        let mirror = Mirror(reflecting: self)
        return mirror.subjectType as! SQLiteCodable.Type
    }
}
