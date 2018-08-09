//
//  SQLiteConnection+Update.swift
//  SQLiteKit
//
//  Created by xu.shuifeng on 2018/8/9.
//

import Foundation

extension SQLiteConnection {
    
    /// Updates all of the columns of a table using the specified object
    /// except for its primary key.
    /// The object is required to have a primary key.
    ///
    /// - Parameter obj: The object to update. It must have a primary key designated using the Attribute.isPK.
    /// - Returns: The number of rows updated.
    /// - Throws: Exceptions
    @discardableResult
    public func update<Object: SQLiteCodable>(_ obj: Object) throws -> Int {
        let map = getMapping(of: Object.self)
        guard let pk = map.pk else {
            throw SQLiteError.notSupportedError("Could not update table without primary key")
        }
        let cols = map.columns.filter { return $0.isPK == false }
        let sets = cols.map { return "\($0.name) = ?" }.joined(separator: ",")
        var values: [Any] = cols.map { return $0.getValue(of: obj) }
        values.append(pk.getValue(of: obj))
        let sql = String(format: "UPDATE %@ SET %@ WHERE %@ = ?", map.tableName, sets, pk.name)
        return try execute(sql, parameters: values)
    }
    
    @discardableResult
    public func upsert<Object: SQLiteCodable>(_ obj: Object) throws -> Int {
        if SQLiteConnection.libVersionNumber > 3024000 {
            // TODO
        } else {
            // create two statements
            let result = try insert(obj, extra: "OR IGNORE")
            if result == 0 {
                return try update(obj)
            }
            return result
        }
        return 0
    }
}
