//
//  SQLiteCommand.swift
//  SQLiteKit
//
//  Created by xu.shuifeng on 2018/7/14.
//

import Foundation

class SQLiteCommand {
    
    struct Binding {
        public let name: String?
        public let value: Any?
        public var index: Int = 0
        
        init(name: String?, value: Any?) {
            self.name = name
            self.value = value
            self.index = 0
        }
    }
    
    fileprivate let conn: SQLiteConnection
    
    fileprivate var _bindings: [Binding] = []
    
    var commandText: String = ""
    
    init(connection: SQLiteConnection) {
        conn = connection
    }
    
    func bind(_ name: String?, value: Any) {
        let binding = Binding(name: name, value: value)
        _bindings.append(binding)
    }
    
    func bind(_ value: Any) {
        bind(nil, value: value)
    }
    
    func bindAll(_ stmt: SQLiteStatement) throws {
        var index = 1
        for var bind in _bindings {
            if let name = bind.name {
                bind.index = SQLite3.bindParameterIndex(stmt, name: name)
            } else {
                index += 1
                bind.index = index
            }
            try SQLiteCommand.bindParameter(stmt, index: index, value: bind.value)
        }
    }
    
    @discardableResult
    static func bindParameter(_ stmt: SQLiteStatement, index: Int, value: Any?) throws -> Int {
        let code: Int
        if let value = value {
            switch value {
            case let v as String:
                code = SQLite3.bindText(stmt, index: index, value: v)
            case let v as Bool:
                code = SQLite3.bindInt(stmt, index: index, value: v ? 1 : 0)
            case let v as Int:
                code = SQLite3.bindInt(stmt, index: index, value: v)
            case let v as Float:
                code = SQLite3.bindDouble(stmt, index: index, value: Double(v))
            case let v as Double:
                code = SQLite3.bindDouble(stmt, index: index, value: v)
            case let v as CGFloat:
                code = SQLite3.bindDouble(stmt, index: index, value: Double(v))
            case let v as Date:
                let interval = v.timeIntervalSince1970
                code = SQLite3.bindDouble(stmt, index: index, value: interval)
            case let v as URL:
                code = SQLite3.bindText(stmt, index: index, value: v.absoluteString)
            case let v as Data:
                code = SQLite3.bindBlob(stmt, index: index, value: v)
            default:
                throw SQLiteError.notSupportedError("Unsupported parameter type")
            }
        } else {
            code = SQLite3.bindNull(stmt, index: index)
        }
        return code
    }
    
    func readColumn(_ stmt: SQLiteStatement, index: Int, columnType: SQLite3.ColumnType, type: Any.Type) -> Any? {
        switch columnType {
        case .Text:
            return SQLite3.columnText(stmt, index: index)
        case .Integer:
            let value = SQLite3.columnInt(stmt, index: index)
            if type is Bool.Type {
                return value == 1
            }
            return value
        case .Float:
            return SQLite3.columnDouble(stmt, index: index)
        case .Blob:
            return SQLite3.columnBlob(stmt, index: index)
        case .Null:
            return nil
        }
    }
    
    func prepare() throws -> SQLiteStatement {
        guard let stmt = SQLite3.prepare(conn.handle, SQL: commandText) else {
            let msg = SQLite3.getErrorMessage(conn.handle)
            throw SQLiteError.prepareError(msg)
        }
        try bindAll(stmt)
        return stmt
    }
    
    func executeScalar<T>() throws -> T? {
        let stmt = try prepare()
        guard let r = SQLite3.step(stmt) else {
            return nil
        }
        
        if r == SQLite3.Result.row || r == SQLite3.Result.done {
            let colType = SQLite3.columnType(stmt, index: 0)
            let value = readColumn(stmt, index: 0, columnType: colType, type: T.self) as? T
            SQLite3.finalize(stmt)
            return value
        } else {
            let msg = SQLite3.getErrorMessage(conn.handle)
            throw SQLiteError.executeError(Int(r.rawValue), msg)
        }
    }
    
    @discardableResult
    func executeNonQuery() throws -> Int {
        let stmt = try prepare()
        guard let r = SQLite3.step(stmt) else {
            return 0
        }
        SQLite3.finalize(stmt)
        if r == SQLite3.Result.done {
            let rowsAffected = SQLite3.changes(conn.handle)
            return rowsAffected
        } else if r == SQLite3.Result.error {
            let msg = SQLite3.getErrorMessage(conn.handle)
            throw SQLiteError.executeError(Int(r.rawValue), msg)
        } else if r == SQLite3.Result.constraint {
            let msg = SQLite3.getErrorMessage(conn.handle)
            throw SQLiteError.notNullConstraintViolation(Int(r.rawValue), msg)
        }
        throw SQLiteError.executeError(Int(r.rawValue), "")
    }
    
    func executeQuery<T: SQLiteTable>() -> [T] {
        let map = conn.getMapping(of: T.self)
        do {
            return try executeDeferredQuery(map)
        } catch {
            print(error)
            return []
        }
    }
    
    func executeDeferredQuery<T: SQLiteTable>(_ map: TableMapping) throws -> [T] {
        let stmt = try prepare()
        let columnCount = SQLite3.columnCount(stmt)
        var cols: [TableMapping.Column?] = []
        for i in 0..<columnCount {
            let name = SQLite3.columnName(stmt, index: i)
            let column = map.findColumn(with: name)
            cols.append(column)
        }
        
        var result: [T] = []
        while SQLite3.step(stmt) == SQLite3.Result.row {
            // currently use JSONSerialization and JSONDecoder to ORM mapping
            var dict: [String: Any?] = [:]
            for i in 0..<columnCount {
                if let col = cols[i] {
                    let colType = SQLite3.columnType(stmt, index: i)
                    let value = readColumn(stmt, index: i, columnType: colType, type: col.columnType)
                    dict[col.name] = value
                }
            }
            do {
                let data = try JSONSerialization.data(withJSONObject: dict, options: [])
                let obj = try JSONDecoder().decode(T.self, from: data)
                result.append(obj)
            } catch {
                throw SQLiteError.jsonDecoderError(error)
            }
        }
        SQLite3.finalize(stmt)
        return result
    }
}

class PreparedSqliteInsertCommand {
    
    private let conn: SQLiteConnection
    
    private let commandText: String
    
    private var statement: SQLiteStatement?
    
    init(connection: SQLiteConnection, commandText: String) {
        self.conn = connection
        self.commandText = commandText
    }
    
    deinit {
        if let stmt = statement {
            SQLite3.finalize(stmt)
        }
    }
    
    func executeNonQuery(_ args: [Any]) throws -> Int {
        guard let stmt = SQLite3.prepare(conn.handle, SQL: commandText) else {
            return 0
        }
        for (index, arg) in args.enumerated() {
            try SQLiteCommand.bindParameter(stmt, index: index + 1, value: arg)
        }
        let r = SQLite3.step(stmt)
        if r == SQLite3.Result.done {
            let rows = SQLite3.changes(conn.handle)
            return rows
        }
        return 0
    }
    
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter
}()
