//
//  TableMapping.swift
//  SQLiteKit
//
//  Created by xu.shuifeng on 2018/7/16.
//

import Foundation

enum SQLiteDataType: String {
    case INTEGER
    case REAL
    case TEXT
    case BLOB
    case NULL
}

struct TableMapping {
    
    let tableName: String
    
    let createFlags: SQLiteConnection.CreateFlags
    
    let columns: [Column]
    
    private(set) var insertColumns: [Column]
    
    private(set) var insertOrReplaceColumns: [Column]
    
    let queryByPrimaryKeySQL: String
    
    var pk: Column?
    
    var autoIncPK: Column?
    
    var withoutRowId: Bool = false
    
    var hasAutoIncPK: Bool {
        return autoIncPK != nil
    }
    
    init<T: SQLiteCodable>(type: T.Type, createFlags: SQLiteConnection.CreateFlags = .none) {
        let attributes = type.attributes()
        
        if let nameAttribute = attributes.first(where: { $0.attribute == .tableName }) {
            tableName = nameAttribute.name
        } else {
            tableName = String(describing: type.self)
        }
        self.createFlags = createFlags
        
        // TODO
        let codingKeys = T.CodingKeys.allKeys
        
        for key in T.CodingKeys.allCases {
            print(key)
        }
        
        
        var cols: [Column] = []
        let mirror = Mirror(reflecting: type.init())
        for child in mirror.children {
            let col = Column(propertyInfo: child, attributes: attributes)
            cols.append(col)
            // TODO: If we support nested table model, we should check
            //let m = Mirror(reflecting: child.value)
            //print(m.displayStyle)
        }
        columns = cols
        insertColumns = columns.filter { return $0.isAutoInc == false }
        insertOrReplaceColumns = columns
        
        for c in cols {
            if c.isPK && c.isAutoInc {
                autoIncPK = c
            }
            if c.isPK {
                pk = c
            }
        }
        if let pk = pk {
            queryByPrimaryKeySQL = "SELECT * FROM \(tableName) WHERE \(pk.name) = ?"
        } else {
            queryByPrimaryKeySQL = "SELECT * FROM \(tableName) LIMIT 1"
        }
        withoutRowId = false
    }
    
    func findColumn(with name: String) -> Column? {
        return columns.first(where: { $0.name == name })
    }
    
    func setAutoIncPK(_ rowID: Int64) {
        // TODO: - Use reflection to set primary key value
    }
    
    class Column {
        
        let name: String
        
        let value: Any
        
        let isNullable: Bool
        
        let isPK: Bool
        
        let isAutoInc: Bool
        
        let isIndexed: Bool
        
        let columnType: Any.Type
        
        init(propertyInfo: Mirror.Child, attributes: [SQLiteAttribute]) {
            let columnName = propertyInfo.label!
            name = columnName
            value = propertyInfo.value
            isNullable = true
            let columnAttr = attributes.filter { $0.name == columnName }
            isPK = columnAttr.contains(where: { $0.attribute == Attribute.isPK })
            isAutoInc = columnAttr.contains(where: { $0.attribute == Attribute.autoInc })
            isIndexed = columnAttr.contains(where: { $0.attribute == Attribute.indexed })
            columnType = type(of: propertyInfo.value)
            print(columnType)
        }
        
        
        /// Using Mirror to refect object value
        ///
        /// - Parameter object: object
        /// - Returns: object value of the column
        func getValue<Object: SQLiteCodable>(of object: Object) -> Any {
            let mirror = Mirror(reflecting: object)
            return mirror.children.first(where: { $0.label == name })!.value
        }
        
    }
    
}

extension TableMapping.Column {
    
    var declaration: String {
        var decl = "'\(name)' \(SQLType) "
        if isPK {
            decl += "PRIMARY KEY "
        }
        if isAutoInc && SQLType == SQLiteDataType.INTEGER.rawValue {
            decl += "AUTOINCREMENT "
        }
        if !isNullable {
            decl += "NOT NULL"
        }
        return decl
    }
    
    fileprivate var SQLType: String {
        let mappings: [String: [Any.Type]] = [
            "INTEGER": [
                Int.self, Int?.self,
                Int64.self, Int64?.self,
                Bool.self, Bool?.self
            ],
            "REAL": [
                Float.self, Float?.self,
                Double.self, Double?.self,
                Date.self, Date?.self,
                CGFloat.self, CGFloat?.self
            ],
            "TEXT": [
                String.self, String?.self,
                URL.self, URL?.self
            ],
            "BLOB": [
                Data.self, Data?.self,
                [UInt8].self, [UInt8]?.self
            ]
        ]
        
        let type = columnType
        for map in mappings {
            if map.value.contains(where: { type == $0 }) {
                return map.key
            }
        }
        return ""
    }
}
