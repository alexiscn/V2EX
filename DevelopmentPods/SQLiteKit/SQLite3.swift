//
//  SQLite3.swift
//  SQLiteKit
//
//  Created by xu.shuifeng on 2018/7/14.
//

import Foundation
import SQLite3

internal typealias SQLiteStatement = OpaquePointer

internal typealias SQLiteDatabaseHandle = OpaquePointer

internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

internal class SQLite3 {
    
    internal enum Result: Int32 {
        case ok = 0
        case error = 1
        case `internal` = 2
        case perm = 3
        case abort = 4
        case busy = 5
        case locked = 6
        case noMemory = 7
        case readOnly = 8
        case interrupt = 9
        case iOError = 10
        case corrupt = 11
        case notFound = 12
        case full = 13
        case cannotOpen = 14
        case lockErr = 15
        case empty = 16
        case schemaChngd = 17
        case tooBig = 18
        case constraint = 19
        case mismatch = 20
        case misuse = 21
        case notImplementedLFS = 22
        case accessDenied = 23
        case format = 24
        case range = 25
        case nonDBFile = 26
        case notice = 27
        case warning = 28
        case row = 100
        case done = 101
    }
    
    enum ColumnType: Int32 {
        case Integer = 1
        case Float = 2
        case Text = 3
        case Blob = 4
        case Null = 5
    }
    
    @discardableResult
    static func open(filename: String, db: inout SQLiteDatabaseHandle?, flags: SQLiteConnection.OpenFlags) -> Result? {
        return Result(rawValue: sqlite3_open_v2(filename, &db, flags.rawValue , nil))
    }
    
    @discardableResult
    static func close(_ handle: SQLiteDatabaseHandle) -> Result? {
        return Result(rawValue: sqlite3_close_v2(handle))
    }
    
    @discardableResult
    static func busyTimeout(_ db: SQLiteDatabaseHandle, milliseconds: Int) -> Result? {
        return Result(rawValue: sqlite3_busy_timeout(db, Int32(milliseconds)))
    }
    
    static func changes(_ db: SQLiteDatabaseHandle) -> Int {
        return Int(sqlite3_changes(db))
    }
    
    static func prepare(_ db: OpaquePointer, SQL: String) -> SQLiteStatement? {
        var stmt: SQLiteStatement? = nil
        let _ = sqlite3_prepare_v2(db, SQL, -1, &stmt, nil)
        return stmt
    }
    
    @discardableResult
    static func step(_ stmt: SQLiteStatement) -> Result? {
        return Result(rawValue: sqlite3_step(stmt))
    }
    
    @discardableResult
    static func reset(_ stmt: SQLiteStatement) -> Result? {
        return Result(rawValue: sqlite3_reset(stmt))
    }
    
    @discardableResult
    static func finalize(_ stmt: SQLiteStatement) -> Result? {
        return Result(rawValue: sqlite3_finalize(stmt))
    }
    
    static func lastInsertRowid(_ db: SQLiteDatabaseHandle) -> Int64 {
        return sqlite3_last_insert_rowid(db)
    }
    
    static func getErrorMessage(_ db: SQLiteDatabaseHandle) -> String {
        return String(cString: sqlite3_errmsg(db))
    }
    
    // MARK: - Bind Begin
    @discardableResult
    static func bindParameterIndex(_ stmt: SQLiteStatement, name: String) -> Int {
        return Int(sqlite3_bind_parameter_index(stmt, name))
    }
    
    @discardableResult
    static func bindNull(_ stmt: SQLiteStatement, index: Int) -> Int {
        return Int(sqlite3_bind_null(stmt, Int32(index)))
    }
    
    @discardableResult
    static func bindInt(_ stmt: SQLiteStatement, index: Int, value: Int) -> Int {
        return Int(sqlite3_bind_int(stmt, Int32(index), Int32(value)))
    }
    
    @discardableResult
    static func bindInt64(_ stmt: SQLiteStatement, index: Int, value: Int64) -> Int {
        return Int(sqlite3_bind_int64(stmt, Int32(index), value))
    }
    
    @discardableResult
    static func bindDouble(_ stmt: SQLiteStatement, index: Int, value: Double) -> Int {
        return Int(sqlite3_bind_double(stmt, Int32(index), value))
    }
    
    @discardableResult
    static func bindText(_ stmt: SQLiteStatement, index: Int, value: String) -> Int {
        return Int(sqlite3_bind_text(stmt, Int32(index), value, -1, SQLITE_TRANSIENT))
    }
    
    @discardableResult
    static func bindBlob(_ stmt: SQLiteStatement, index: Int, value: Data) -> Int {
        let r = value.withUnsafeBytes { bytes in
            sqlite3_bind_blob(stmt, Int32(index), bytes, Int32(value.count), SQLITE_TRANSIENT)
        }
        return Int(r)
    }
    
    // MARK: - Column
    
    static func columnCount(_ stmt: SQLiteStatement) -> Int {
        return Int(sqlite3_column_count(stmt))
    }
    
    static func columnName(_ stmt: SQLiteStatement, index: Int) -> String {
        return String(cString: sqlite3_column_name(stmt, Int32(index))!)
    }
    
    static func columnType(_ stmt: SQLiteStatement, index: Int) -> ColumnType {
        return ColumnType(rawValue: sqlite3_column_type(stmt, Int32(index)))!
    }
    
    static func columnInt(_ stmt: SQLiteStatement, index: Int) -> Int {
        return Int(sqlite3_column_int(stmt, Int32(index)))
    }
    
    static func columnInt64(_ stmt: SQLiteStatement, index: Int) -> Int64 {
        return Int64(sqlite3_column_int64(stmt, Int32(index)))
    }
    
    static func columnDouble(_ stmt: SQLiteStatement, index: Int) -> Double {
        return Double(sqlite3_column_double(stmt, Int32(index)))
    }
    
    static func columnText(_ stmt: SQLiteStatement, index: Int) -> String {
        return String(cString: sqlite3_column_text(stmt, Int32(index))!)
    }
    
    static func columnBlob(_ stmt: SQLiteStatement, index: Int) -> Data? {
        if let bytes = sqlite3_column_blob(stmt, Int32(index)) {
            let count = Int(sqlite3_column_bytes(stmt, Int32(index)))
            return Data(bytes: bytes, count: count)
        }
        return nil
    }
    
    static func libVersionNumber() -> Int {
        return Int(sqlite3_libversion_number())
    }
    
    static func libVersion() -> String {
        return String(cString: sqlite3_libversion())
    }
}
