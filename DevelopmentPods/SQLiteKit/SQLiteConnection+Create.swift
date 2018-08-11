//
//  SQLiteConnection+Create.swift
//  SQLiteKit
//
//  Created by xu.shuifeng on 2018/8/9.
//

import Foundation

extension SQLiteConnection {
 
    /// Executes a "create table if not exists" on the database. It also
    /// creates any specified indexes on the columns of the table. It uses
    /// a schema automatically generated from the specified type. You can
    /// later access this schema by calling GetMapping.
    ///
    /// - Parameters:
    ///   - type: Type to reflect to a database table
    ///   - createFlags: Optional flags allowing implicit PK and indexes based on naming conventions
    /// - Returns: Whether the table was created or migrated.
    /// - Throws: throws exception
    @discardableResult
    public func createTable<T: SQLiteCodable>(_ type: T.Type, createFlags: CreateFlags = .none) throws -> CreateTableResult {
        let map = getMapping(of: type, createFlags: createFlags)
        if map.columns.count == 0 {
            return CreateTableResult.noneColumnsFound
        }
        
        let result: CreateTableResult
        let existingCols = getExistingColumns(tableName: map.tableName)
        if existingCols.count == 0 {
            let fts3: Bool = (createFlags.rawValue & CreateFlags.fullTextSearch3.rawValue) != 0
            let fts4: Bool = (createFlags.rawValue & CreateFlags.fullTextSearch4.rawValue) != 0
            let fts5: Bool = (createFlags.rawValue & CreateFlags.fullTextSearch5.rawValue) != 0
            let fts = fts3 || fts4 || fts5
            let virtual = fts ? "VIRTUAL ": ""
            
            var using = ""
            if fts3 {
                using = "USING FTS3"
            } else if fts4 {
                using = "USING FTS4"
            } else if fts5 {
                using = "USING FTS5"
            }
            var sql = "CREATE \(virtual)TABLE IF NOT EXISTS \(map.tableName) \(using)("
            let declarationList = map.columns.map { return $0.declaration }
            let declaration = declarationList.joined(separator: ",")
            sql += declaration
            sql += ")"
            if map.withoutRowId {
                sql += " WITHOUT ROWID"
            }
            try execute(sql)
            result = .created
        } else {
            // do the migration
            try migrateTable(map, existingCols: existingCols)
            result = .migrated
        }
        // create index
        for column in map.columns {
            if column.isIndexed {
                
            }
        }
        
        return result
    }
    
    
    /// Inserts the given object (and updates its auto incremented primary key if it has one).
    /// The return value is the number of rows added to the table.
    ///
    /// - Parameter obj: The object to insert.
    /// - Returns: The number of rows added to the table.
    /// - Throws: Exceptions.
    @discardableResult
    public func insert<Object: SQLiteCodable>(_ obj: Object?) throws -> Int {
        return try insert(obj, extra: "")
    }
    
    
    /// Inserts the given object (and updates its auto incremented primary key if it has one).
    /// The return value is the number of rows added to the table.
    /// If a UNIQUE constraint violation occurs with some pre-existing object, this function deletes the old objects
    ///
    /// - Parameter obj: The object to insert.
    /// - Returns: The number of rows modified.
    /// - Throws: Exceptions.
    @discardableResult
    public func insertOrReplace<Object: SQLiteCodable>(_ obj: Object?) throws -> Int {
        return try insert(obj, extra: "OR REPLACE")
    }
    
    
    /// Inserts the given object (and updates its
    /// auto incremented primary key if it has one).
    /// The return value is the number of rows added to the table.
    ///
    /// - Parameters:
    ///   - obj: The object to insert.
    ///   - extra: Literal SQL code that gets placed into the command. INSERT {extra} INTO ...
    /// - Returns: The number of rows added to the table.
    /// - Throws: Exceptions.
    @discardableResult
    public func insert<Object: SQLiteCodable>(_ obj: Object?, extra: String) throws -> Int {
        guard let object = obj else {
            return 0
        }
        let type: Object.Type = object.mapType()
        let map = getMapping(of: type)
        let isReplacing = extra.uppercased() == "OR REPLACE"
        let columns = isReplacing ? map.insertOrReplaceColumns: map.insertColumns
        
        let values: [Any] = columns.map { return $0.getValue(of: object) }
        let cmd = getInsertCommand(map: map, extra: extra)
        let rows = try cmd.executeNonQuery(values)
        if map.hasAutoIncPK {
            let id = SQLite3.lastInsertRowid(handle)
            map.setAutoIncPK(id)
        }
        return rows
    }
    
    
    /// Inserts all specified objects.
    ///
    /// - Parameters:
    ///   - objects: Objects to insert.
    ///   - inTranscation: A boolean indicating if the inserts should be wrapped in a transaction.
    /// - Returns: The number of rows added to the table.
    /// - Throws: Exceptions
    @discardableResult
    public func insertAll<Object: SQLiteCodable>(_ objects: [Object], inTranscation: Bool = false) throws -> Int {
        var result = 0
        if inTranscation {
            
        } else {
            for obj in objects {
                result += try insert(obj)
            }
        }
        return result
    }
}


