//
//  SQLiteConnection.swift
//  SQLiteKit
//
//  Created by xu.shuifeng on 2018/7/14.
//

import Foundation
import SQLite3

/// An open connection to a SQLite database.
public class SQLiteConnection {

    public enum ConnectionString {
        case inMemory
        case URL(URL)
    }
    
    public enum Ordering {
        case ASC(String)
        case DESC(String)
        var declaration: String {
            switch self {
            case .ASC(let name):
                return "\(name) ASC"
            case .DESC(let name):
                return "\(name) DESC"
            }
        }
    }
    
    /// The ON CONFLICT clause is a non-standard extension specific to SQLite that can appear in many other SQL commands.
    ///
    /// - rollback: When an applicable constraint violation occurs, the ROLLBACK resolution algorithm aborts the current SQL statement with an SQLITE_CONSTRAINT error and rolls back the current transaction. If no transaction is active (other than the implied transaction that is created on every command) then the ROLLBACK resolution algorithm works the same as the ABORT algorithm.
    /// - abort: When an applicable constraint violation occurs, the ABORT resolution algorithm aborts the current SQL statement with an SQLITE_CONSTRAINT error and backs out any changes made by the current SQL statement; but changes caused by prior SQL statements within the same transaction are preserved and the transaction remains active. This is the default behavior and the behavior specified by the SQL standard.
    /// - fail: When an applicable constraint violation occurs, the FAIL resolution algorithm aborts the current SQL statement with an SQLITE_CONSTRAINT error. But the FAIL resolution does not back out prior changes of the SQL statement that failed nor does it end the transaction. For example, if an UPDATE statement encountered a constraint violation on the 100th row that it attempts to update, then the first 99 row changes are preserved but changes to rows 100 and beyond never occur.
    /// - ignore: When an applicable constraint violation occurs, the IGNORE resolution algorithm skips the one row that contains the constraint violation and continues processing subsequent rows of the SQL statement as if nothing went wrong. Other rows before and after the row that contained the constraint violation are inserted or updated normally. No error is returned when the IGNORE conflict resolution algorithm is used.
    /// - replace: When a UNIQUE or PRIMARY KEY constraint violation occurs, the REPLACE algorithm deletes pre-existing rows that are causing the constraint violation prior to inserting or updating the current row and the command continues executing normally. If a NOT NULL constraint violation occurs, the REPLACE conflict resolution replaces the NULL value with the default value for that column, or if the column has no default value, then the ABORT algorithm is used. If a CHECK constraint violation occurs, the REPLACE conflict resolution algorithm always works like ABORT.
    public enum OnConflict: String {
        case rollback = "ROLLBACK"
        case abort = "ABORT"
        case fail = "FAIL"
        case ignore = "IGNORE"
        case replace = "REPLACE"
    }
    
    /// Flags to create a SQLite database
    ///
    /// - none: Use the default creation options
    /// - implicitPK: Create a primary key index for a property called 'Id' (case-insensitive). This avoids the need for the [PrimaryKey] attribute.
    /// - implicitIndex: Create indices for properties ending in 'Id' (case-insensitive).
    /// - allImplicit: Create a primary key for a property called 'Id' and create an indices for properties ending in 'Id' (case-insensitive).
    /// - autoIncPK: Force the primary key property to be auto incrementing. This avoids the need for the [AutoIncrement] attribute. The primary key property on the class should have type int or long.
    /// - fullTextSearch3: Create virtual table using FTS3
    /// - fullTextSearch4: Create virtual table using FTS4
    /// - fullTextSearch5: Create virtual table using FTS5
    public enum CreateFlags: Int {
        case none = 0x000
        case implicitPK = 0x001
        case implicitIndex = 0x002
        case allImplicit = 0x003
        case autoIncPK = 0x004
        case fullTextSearch3 = 0x100
        case fullTextSearch4 = 0x200
        case fullTextSearch5 = 0x300
    }
    
    public struct OpenFlags: OptionSet {

        public let rawValue: Int32
        public init(rawValue: Int32) {
            self.rawValue = rawValue
        }
        
        public static let readOnly = OpenFlags(rawValue: 1)
        public static let readWrite = OpenFlags(rawValue: 2)
        public static let create = OpenFlags(rawValue: 4)
        public static let noMutex = OpenFlags(rawValue: 0x8000)
        public static let fullMutex = OpenFlags(rawValue: 0x10000)
        public static let sharedCache = OpenFlags(rawValue: 0x20000)
        public static let privateCache = OpenFlags(rawValue: 0x40000)
        public static let protectionComplete = OpenFlags(rawValue: 0x00100000)
        public static let protectionCompleteUnlessOpen = OpenFlags(rawValue: 0x00200000)
        public static let protectionCompleteUntilFirstUserAuthentication = OpenFlags(rawValue: 0x00300000)
        public static let protectionNone = OpenFlags(rawValue: 0x00400000)
    }
    
    /// Result of create table
    ///
    /// - created: Table is successfully created
    /// - migrated: Table is migrated. New columns are added.
    /// - noneColumnsFound: Table have no columns.
    public enum CreateTableResult {
        case created
        case migrated
        case noneColumnsFound
    }
    
    /// Whether trace debug information
    public var debugTrace: Bool = false
    public var traceHandler: ((String) -> Void)?
    
    fileprivate let dbPath: String
    fileprivate let _open: Bool
    fileprivate var un_fair_lock = os_unfair_lock()
    fileprivate let openFlags: OpenFlags
    fileprivate var _mappings: [String: TableMapping] = [:]
    fileprivate var _insertCommandMap: [String: PreparedSqliteInsertCommand] = [:]
    fileprivate var _transactionDepth: Int = 0
    fileprivate var _transcationCounter: AtomicInteger = AtomicInteger()
    
    internal let handle: SQLiteDatabaseHandle
    
    /// Sets a busy handler to sleep the specified amount of time when a table is locked.
    public var busyTimeout: Int = 200 {
        didSet {
            SQLite3.busyTimeout(handle, milliseconds: busyTimeout)
        }
    }
    
    /// SQLite libray version number.
    public static var libVersion: String {
        return SQLite3.libVersion()
    }
    
    /// SQLite libray version number.
    public static var libVersionNumber: Int {
        return SQLite3.libVersionNumber()
    }
    
    /// Create a in-memory database
    /// - Throws: throws exception
    public convenience init() throws {
        let databasePath = ":memory:"
        try self.init(databasePath: databasePath)
    }
    
    /// Constructs a new SQLiteConnection and opens a SQLite database specified by databasePath.
    ///
    /// - Parameter databasePath: Specifies the path to the database file.
    /// - Throws: throws exception
    public convenience init(databasePath: String) throws {
        try self.init(databasePath: databasePath, openFlags: [.readWrite, .create])
    }
    
    /// Constructs a new SQLiteConnection and opens a SQLite database specified by databasePath.
    ///
    /// - Parameters:
    ///   - databasePath: Specifies the path to the database file.
    ///   - openFlags: Flags controlling how the connection should be opened.
    /// - Throws: throws exception
    public init(databasePath: String, openFlags: OpenFlags) throws {
        self.dbPath = databasePath
        self.openFlags = openFlags
        var dbHandle: SQLiteDatabaseHandle?
        let r = SQLite3.open(filename: dbPath, db: &dbHandle, flags: openFlags)
        if r != SQLite3.Result.ok {
            throw SQLiteError.openDataBaseError("Could not open database file at path: \(databasePath), result code: \(r?.rawValue ?? 0)")
        }
        handle = dbHandle!
        _open = true
    }
    
    deinit {
        SQLite3.close(handle)
    }
    
    /// Close the connection
    public func close() {
        SQLite3.close(handle)
    }

    /// Executes a "drop table" on the database.  This is non-recoverable.
    ///
    /// - Parameter type: Type to reflect to a database table.
    /// - Returns: Whether the table was dropped
    /// - Throws: throws exception
    @discardableResult
    public func dropTable<T: SQLiteCodable>(_ type: T.Type) throws -> Int {
        let map = getMapping(of: type)
        let sql = "drop table if exists \(map.tableName)"
        return try execute(sql)
    }
    
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
    
    // MARK: - Index
    
    /// Creates an index for the specified table and columns.
    ///
    /// - Parameters:
    ///   - indexName: Name of the index to create
    ///   - tableName: Name of the database table
    ///   - columnName: Name of the column to index
    ///   - unique: Whether the index should be unique
    /// - Returns: result of create index
    /// - Throws: throws exception
    @discardableResult
    public func createIndex(_ indexName: String, tableName: String, columnName: String, unique: Bool = false) throws -> Int {
        return try createIndex(indexName, tableName: tableName, columnNames: [columnName], unique: unique)
    }
    
    /// Creates an index for the specified table and columns.
    ///
    /// - Parameters:
    ///   - indexName: Name of the index to create
    ///   - tableName: Name of the database table
    ///   - columnNames: Name of the columns to index
    ///   - unique: Whether the index should be unique
    /// - Returns: result of create index
    /// - Throws: throws exception
    @discardableResult
    public func createIndex(_ indexName: String, tableName: String, columnNames: [String], unique: Bool = false) throws -> Int {
        let columns = columnNames.joined(separator: ",")
        let u = unique ? "UNIQUE": ""
        let sql = String(format: "CREATE %@ INDEX IF NOT EXISTS %@ ON %@(%@)", columns, indexName, u, tableName)
        return try execute(sql)
    }
    
    public func dropIndex(_ indexName: String, tableName: String) throws -> Int {
        let sql = "DROP INDEX \(indexName)"
        return try execute(sql)
    }
    
    /// Creates a SQLiteCommand given the command text (SQL) with arguments. Place a '?'
    /// in the command text for each of the arguments and then executes that command.
    /// Use this method instead of Query when you don't expect rows back. Such cases include
    /// INSERTs, UPDATEs, and DELETEs.
    ///
    /// - Parameters:
    ///   - query: The fully escaped SQL.
    ///   - parameters: Arguments to substitute for the occurences of '?' in the query.
    /// - Returns: The number of rows modified in the database as a result of this execution.
    @discardableResult
    public func execute(_ query: String, parameters: [Any] = []) throws -> Int {
        let cmd = createCommand(query, parameters: parameters)
        return try cmd.executeNonQuery()
    }
    
    // MARK: - Query
    
    public func query<T>(_ query: String, parameters: [Any] = []) -> [T] where T: SQLiteCodable {
        let cmd = createCommand(query, parameters: parameters)
        return cmd.executeQuery()
    }
    
    
    /// Find objects using primary key value
    ///
    /// - Parameter pk: Value of table primary key
    /// - Returns: Object that match the primary. `nil` will return if not found.
    public func find<Object: SQLiteCodable>(_ pk: Any) -> Object? {
        let map = getMapping(of: Object.self)
        return query(map.queryByPrimaryKeySQL, parameters: [pk]).first
    }
    
    /// Attempts to retrieve the first object that matches the query from the table associated with the specified type.
    ///
    /// - Parameters:
    ///   - sql: The fully escaped SQL.
    ///   - parameters: Arguments to substitute for the occurences of '?' in the query.
    /// - Returns: The object that matches the given predicate or `nil` if not found.
    public func findWithQuery<T: SQLiteCodable>(_ sql: String, parameters: [Any]) -> T? {
        return query(sql, parameters: parameters).first
    }
    
    /// Returns a queryable interface to the table represented by the given type.
    ///
    /// - Returns: A queryable object that is able to translate Where, OrderBy, and Take queries into native SQL.
    public func table<T>() -> SQLiteTableQuery<T> where T: SQLiteCodable {
        let map = getMapping(of: T.self)
        return SQLiteTableQuery<T>(connection: self, table: map)
    }
    
    
    /// Returns a queryable interface to the table represented by the given type.
    ///
    /// - Parameter Type to reflect to a database table
    /// - Returns: A queryable object that is able to translate Where, OrderBy, and Take queries into native SQL.
    public func table<T: SQLiteCodable>(of type: T.Type) -> SQLiteTableQuery<T> where T: SQLiteCodable {
        let map = getMapping(of: type)
        return SQLiteTableQuery<T>(connection: self, table: map)
    }
    
    // MARK: - Transcation
    
    public var isInTranscation: Bool {
        return _transactionDepth > 0
    }
    
    public func beginTranscation() {
        
    }
    
    public func rollback() {
        rollback(to: nil)
    }
    
    public func rollback(to savePoint: String?) {
        guard let savePoint = savePoint, savePoint.count > 0 else {
            return
        }
        do {
            // TODO
            try execute("rollback")
        } catch {
            
        }
        
    }
    
    func saveTranscationPoint() -> String {
        let depth = _transcationCounter.incrementAndGet() - 1
        let ret = "S_" + UUID().uuidString + "_" + String(depth)
        do {
            try execute("savepoint \(ret)")
        } catch {
            print(error)
        }
        return ret
    }
    
    public func commitTranscation() {
        
    }
    
    public func runInTranscation(_ block: () -> Void) {
        
    }
    
    // MARK: - Insert
    
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
    
    
    
    /// Creates a SQLiteCommand given the command text (SQL) with arguments. Place a '?'
    /// in the command text for each of the arguments and then executes that command.
    /// Use this method when return primitive values.
    /// You can set the Trace or TimeExecution properties of the connection to profile execution.
    ///
    /// - Parameters:
    ///   - query: The fully escaped SQL.
    ///   - parameters: Arguments to substitute for the occurences of '?' in the query.
    /// - Returns: The number of rows modified in the database as a result of this execution.
    /// - Throws: Exceptions
    public func executeScalar<T: SQLiteCodable>(_ query: String, parameters: [Any] = []) throws -> T? {
        let cmd = createCommand(query, parameters: parameters)
        let t: T? = try cmd.executeScalar()
        return t
    }
}

extension SQLiteConnection {
    
    func getMapping<T: SQLiteCodable>(of type: T.Type, createFlags: CreateFlags = .none) -> TableMapping {
        let key = String(describing: type)
        var map: TableMapping
        lock()
        if let oldMap = _mappings[key] {
            if createFlags != .none && createFlags != oldMap.createFlags {
                map = TableMapping(type: type, createFlags: createFlags)
                _mappings[key] = map
            } else {
                map = oldMap
            }
        } else {
            map = TableMapping(type: type)
            _mappings[key] = map
        }
        unlock()
        return map
    }
    
    fileprivate func migrateTable(_ map: TableMapping, existingCols: [_ColumnInfo]) throws {
        var newCols: [TableMapping.Column] = []
        for column in map.columns {
            if let _ = existingCols.first(where: { $0.name == column.name }) {
                continue
            }
            newCols.append(column)
        }
        for p in newCols {
            let sql = "ALTER TABLE \(map.tableName) ADD COLUMN \(p.declaration)"
            try execute(sql)
        }
    }
    
    fileprivate func getExistingColumns(tableName: String) -> [_ColumnInfo] {
        let sql = String(format: "pragma table_info(%@)", tableName)
        return query(sql)
    }
    
    func createCommand(_ cmdText: String, parameters: [Any]) -> SQLiteCommand {
        let cmd = SQLiteCommand(connection: self)
        cmd.commandText = cmdText
        for param in parameters {
            cmd.bind(param)
        }
        return cmd
    }
    
    fileprivate func getInsertCommand(map: TableMapping, extra: String) -> PreparedSqliteInsertCommand {
        var columns = map.insertColumns
        let sql: String
        if columns.count == 0 && map.columns.count == 1 && map.columns.first?.isAutoInc == true {
            sql = "INSERT \(extra) INTO \(map.tableName) DEFAULT VALUES"
        } else {
            if extra.uppercased() == "OR REPLACE" {
                columns = map.insertOrReplaceColumns
            }
            let keys = columns.map { return $0.name }.joined(separator: ",")
            let values = [String].init(repeating: "?", count: columns.count).joined(separator: ",")
            sql = "INSERT \(extra) INTO \(map.tableName) (\(keys)) VALUES (\(values))"
        }
        return PreparedSqliteInsertCommand(connection: self, commandText: sql)
    }
    
    fileprivate func lock() {
        os_unfair_lock_lock(&un_fair_lock)
    }
    
    fileprivate func unlock() {
        os_unfair_lock_unlock(&un_fair_lock)
    }
}

fileprivate class _ColumnInfo: SQLiteCodable {
    
    enum CodingKeys: String, SQLiteCodingKey {
        typealias root = _ColumnInfo
        case name
        case notnull
    }
    
    static func attributes() -> [SQLiteAttribute] {
        return []
    }
    
    let name: String
    
    let notnull: Int
    
    required init() {
        name = ""
        notnull = 0
    }
}
