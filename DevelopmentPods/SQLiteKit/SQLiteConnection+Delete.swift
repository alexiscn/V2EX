//
//  SQLiteConnection+Delete.swift
//  SQLiteKit
//
//  Created by xu.shuifeng on 2018/8/9.
//

import Foundation

extension SQLiteConnection {
    
    /// Deletes the given object from the database using its primary key.
    ///
    /// - Parameter obj: The object to delete. It must have a primary key designated using the Attribute.isPK.
    /// - Returns: The number of rows deleted.
    /// - Throws: Exceptions
    @discardableResult
    public func delete<Object: SQLiteCodable>(_ obj: Object) throws -> Int {
        let type: Object.Type = obj.mapType()
        let map = getMapping(of: type)
        guard let pk = map.pk else {
            throw SQLiteError.notSupportedError("Could not delete row without primary key")
        }
        let sql = "DELETE FROM \(map.tableName) WHERE \(pk.name) = ?"
        return try execute(sql, parameters: [pk.value])
    }
 
    /// Delete all table data
    ///
    /// - Parameter type: Type to reflect to a database table.
    /// - Returns: Rows deleted.
    /// - Throws: Exceptions.
    @discardableResult
    public func deleteAll<T: SQLiteCodable>(_ type: T.Type) throws -> Int {
        return try deleteAll(map: getMapping(of: T.self))
    }
    
    @discardableResult
    public func delete<Object: SQLiteCodable>(using predicate: NSPredicate, on table: Object.Type) throws -> Int {
        let map = getMapping(of: table)
        let sql = "DELETE FROM \(map.tableName) WHERE \(predicate.predicateFormat)"
        return try execute(sql)
    }
    
    @discardableResult
    fileprivate func deleteAll(map: TableMapping) throws -> Int {
        let sql = "DELETE FROM \(map.tableName)"
        return try execute(sql)
    }
}
