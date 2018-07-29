//
//  SQLiteDatabase.swift
//  SQLiteKit
//
//  Created by xu.shuifeng on 2018/5/24.
//  Copyright © 2018 Meteor. All rights reserved.
//

import Foundation
import SQLite3
import FMDB

func dbLog(_ text: String) {
    if SQLiteDatabase.enableLog {
        print("********************************************")
        print(text)
        print("********************************************")
    }
}

///
/// let path = your_path_of_db_file
/// let db = SQLiteDatabase(path: path)
///
///
public class SQLiteDatabase {
    
    public static var enableLog = false
    
    fileprivate var dbQueue: FMDatabaseQueue
    fileprivate var enableDebugLog: Bool = false
    fileprivate var transactionCounter: Int = 0
    fileprivate var collectionCache: NSMutableDictionary = NSMutableDictionary(capacity: 20)
    fileprivate var lock = Lock()
    
    public init(path: String) {
        let flags = SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FILEPROTECTION_NONE
        dbQueue = FMDatabaseQueue(path: path, flags: flags)
        dbQueue.inDatabase { (db) in
            db.traceExecution = enableDebugLog
            db.logsErrors = enableDebugLog
        }
    }
    
    deinit {
        collectionCache.removeAllObjects()
    }
    
    public func table(_ tableName: String) -> SQLiteTable? {
        lock.lock()
        var coll = collectionCache.object(forKey: tableName) as? SQLiteTable
        lock.unlock()
        if coll == nil {
            let collection = SQLiteTable(database: self, tableName: tableName)
            coll = collection
            lock.lock()
            collectionCache.setObject(collection, forKey: tableName as NSCopying)
            lock.unlock()
        }
        return coll
    }
    
    // MARK: - Error
    
    public var lastError: Error? {
        var error: Error? = nil
        dbQueue.inDatabase { db in
            error = db.lastError()
        }
        return error
    }

    // MARK: - Query
    
    public func executeQuery(_ sql: String, values: [Any]? = nil) -> SQLiteRowList {
        var result: SQLiteRowList = []
        dbQueue.inDatabase { db in
            if let resultSet = try? db.executeQuery(sql, values: values) {
                while (resultSet.next()) {
                    if let dict = resultSet.resultDictionary {
                        let row = SQLiteRow(dictionary: dict)
                        result.append(row)
                    }
                }
            }
        }
        return result
    }
    
    public func executeQuery(_ sql: String, withVAList list: CVaListPointer) -> SQLiteRowList {
        var result: SQLiteRowList = []
        dbQueue.inDatabase { db in
            if let resultSet = db.executeQuery(sql, withVAList: list) {
                while (resultSet.next()) {
                    if let dict = resultSet.resultDictionary {
                        let row = SQLiteRow(dictionary: dict)
                        result.append(row)
                    }
                }
            }
        }
        return result
    }
    
    public func executeQuery(_ sql: String, withParameterDictionary dict: [AnyHashable: Any]) -> SQLiteRowList {
        var result: SQLiteRowList = []
        dbQueue.inDatabase { db in
            if let resultSet = db.executeQuery(sql, withParameterDictionary: dict) {
                while (resultSet.next()) {
                    if let dict = resultSet.resultDictionary {
                        let row = SQLiteRow(dictionary: dict)
                        result.append(row)
                    }
                }
            }
        }
        return result
    }
    
    
    // MARK: - Update
    @discardableResult
    public func executeUpdate(_ sql: String) -> Bool {
        var result = false
        dbQueue.inDatabase { db in
            result = db.executeStatements(sql)
            
        }
        return result
    }
    
    @discardableResult
    public func executeUpdate(_ sql: String, withArgumentsIn arguments: [Any]) -> Bool {
        var result = false
        dbQueue.inDatabase { db in
            result = db.executeUpdate(sql, withArgumentsIn: arguments)
        }
        return result
    }
    
    @discardableResult
    public func executeUpdate(_ sql: String, withParameterDictionary parameter: [AnyHashable: Any]) -> Bool {
        var result = false
        dbQueue.inDatabase { db in
            result = db.executeUpdate(sql, withParameterDictionary: parameter)
        }
        return result
    }
    
    @discardableResult
    public func executeUpdates(_ sqls: [String]) -> Bool {
        beginTransaction()
        let sql = sqls.joined(separator: ";")
        var result = false
        dbQueue.inDatabase { db in
            result = db.executeStatements(sql)
        }
        commitTransaction()
        return result
    }
}



// MARK: - Transcation
extension SQLiteDatabase {
    
    public func beginTransaction() {
        dbQueue.inDatabase { db in
            transactionCounter += 1
            if !db.isInTransaction {
                db.beginTransaction()
            }
        }
    }
    
    public func rollback() {
        dbQueue.inDatabase { db in
            transactionCounter -= 1
            if db.isInTransaction {
                db.rollback()
            }
        }
    }
    
    public func commitTransaction() {
        dbQueue.inDatabase { db in
            transactionCounter -= 1
            if transactionCounter == 0 {
                if db.isInTransaction {
                    db.commit()
                }
            }
        }
    }
}

// MARK: - Create & Exists & Drop
extension SQLiteDatabase {
    
    /// Check if table exists in database
    ///
    /// - Parameter tableName: name of table
    /// - Returns: exists
    public func exists(_ tableName: String) -> Bool {
        let sql = "SELECT COUNT(*) COUNT FROM SQLITE_MASTER WHERE NAME=? AND TYPE='table'"
        let rows = executeQuery(sql, values: [tableName])
        if let row = rows.first {
            if let count = row.dataDict["COUNT"] as? Int {
                return count > 0
            }
        }
        return false
    }
    
    public func createTable<T: SQLiteModelProtocol>(_ table: T.Type) {
        let tableName = table.tableName
        if exists(tableName) {
            return
        }
        var columns = table.columns
        var rowid = SQLiteColumn(name: "_rowid", dataType: .int)
        rowid.autoIncrement = true
        rowid.primaryKey = true
        
        columns.insert(rowid, at: 0)
        
        // create table
        var createSQL = "CREATE TABLE \(tableName) ("
        for col in columns {
            createSQL += col.description + ", "
        }
        createSQL = String(createSQL.dropLast(2))
        createSQL += ");"
        executeUpdate(createSQL)
        dbLog(createSQL)
        
        // create indexes
        let indexColumns = columns.filter { return $0.createIndex }
        if indexColumns.count > 0 {
            beginTransaction()
            for column in indexColumns {
                let sql = String(format: "CREATE INDEX index_%@ on %@ (%@);", column.name, tableName, column.name)
                executeUpdate(sql)
            }
            commitTransaction()
        }
    }
    
    // MARK: - Drop
    @discardableResult
    public func drop(_ tableName: String) -> Bool {
        let sql = "DROP TABLE \(tableName)"
        var success = false
        dbQueue.inDatabase { (db) in
            db.closeOpenResultSets()
            success = db.executeStatements(sql)
        }
        return success
    }
}

fileprivate class Lock {
    
    private var un_fair_lock = os_unfair_lock()
    
    func lock() {
        os_unfair_lock_lock(&un_fair_lock)
    }
    
    func unlock() {
        os_unfair_lock_unlock(&un_fair_lock)
    }
}
