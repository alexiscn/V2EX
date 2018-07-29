//
//  SQLiteTable.swift
//  SQLiteKit
//
//  Created by xu.shuifeng on 2018/5/24.
//  Copyright © 2018 Meteor. All rights reserved.
//

import Foundation

public class SQLiteTable {
    
    fileprivate let db: SQLiteDatabase
    
    fileprivate let tableName: String
    
    public init(database: SQLiteDatabase, tableName: String) {
        self.db = database
        self.tableName = tableName
    }
    
    // MARK: - Find
    
    func find(_ query: String) {
        
    }
    
    func findOne(_ query: String) {
        
    }
    
    func find(_ query: String? = nil, fields: [SQLiteColumn]? = nil, groupBy: SQLiteColumn? = nil, orderBy: SQLiteColumn? = nil, skip: Int = 0, limit: Int = 0) -> SQLiteRowList {
        var sql = ""
        if let fields = fields, fields.count > 0 {
            let keys = fields.map { return $0.name }
            sql += keys.joined(separator: ",")
        } else {
            sql += "*"
        }
        
        sql += " FROM \(tableName) "
        if let query = query {
            sql += " WHERE \(query)"
        }
        if let groupBy = groupBy {
            sql += " GROUP BY \(groupBy.name)"
        }
        if let orderBy = orderBy {
            sql += " ORDER BY \(orderBy.name)"
        }
        if limit > 0 {
            sql += " LIMIT "
            if skip > 0 {
                sql += " \(skip),"
            }
            sql += "\(limit)"
        }
        
        return db.executeQuery(sql)
    }
    
    // MARK: - Update
    
    func update() {
        
    }
}


// MARK: - Create Related APIs
extension SQLiteTable {
    
    @discardableResult
    public func insert<T: SQLiteModelProtocol>(_ model: T) -> Bool {
        let columns = T.columns
        let fields = columns.map { return $0.name }.joined(separator: ",")
        let placeholders = Array(repeating: "?", count: columns.count).joined(separator: ",")
        let sql = String(format: "INSERT INTO %@ (%@) VALUES (%@);", T.tableName, fields, placeholders)
        dbLog(sql)
        return db.executeUpdate(sql, withArgumentsIn: model.values)
    }
    
    @discardableResult
    public func update<T: SQLiteModelProtocol>(_ model: T) -> Bool {
        return false
    }
}

extension SQLiteTable {
    
    
    /// filter data by query
    ///
    /// - Parameter query: eg: id = '123'
    /// - Returns: results
    public func filter(_ query: String) -> SQLiteRowList? {
        let sql = "SELECT * FROM \(tableName) WHERE \(query)"
        return db.executeQuery(sql)
    }
    
}
