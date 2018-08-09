//
//  SQLiteTable.swift
//  SQLiteKit
//
//  Created by xu.shuifeng on 2018/5/24.
//

import Foundation

public protocol RootCodable { }

public protocol SQLiteCodingKeyBase: CodingKey {
    var rootType: RootCodable.Type { get }
}

public protocol SQLiteCodingKey: SQLiteCodingKeyBase, Hashable, EnumCollection, RawRepresentable where RawValue == String {
    associatedtype root: RootCodable
}

public protocol EnumCollection {
//    associatedtype AllCases: Collection where AllCases.Element == Self
    static var allCases: [Self] { get }
}

public extension EnumCollection where Self: Hashable {
    
    public static var allCases: [Self] {
        return [Self](AnySequence { () -> AnyIterator<Self> in
            var raw = 0
            var first: Self?
            return AnyIterator {
                let current = withUnsafeBytes(of: &raw) { $0.load(as: Self.self) }
                if raw == 0 {
                    first = current
                } else if current == first {
                    return nil
                }
                raw += 1
                return current
            }
        })
    }
}

extension SQLiteCodingKey {
    public var rootType: RootCodable.Type {
        return root.self
    }
    
    /// Return all keys of CodingKeys
    static var allKeys: [String] {
        typealias S = Self
        var keys: [String] = []
        var raw = 0
        while true {
            guard let key = (withUnsafePointer(to: &raw) {
                return $0.withMemoryRebound(to: S?.self, capacity: 1, { return $0.pointee })
            }) else {
                break
            }
            print(key)
            keys.append(key.stringValue)
            raw += 1
        }
        return keys
    }
}


/// Type to reflect to a database table
public protocol SQLiteCodable: Codable, RootCodable where CodingKeys.root == Self {

    associatedtype CodingKeys: SQLiteCodingKey
    typealias Columns = CodingKeys
    
    /// Specifiy column attributes of a table, eg: isPK
    ///
    /// - Returns: column attributes
    static func attributes() -> [SQLiteAttribute]
    
    init()

}

extension SQLiteCodable {

    /// Return mapping type of SQLiteTable
    internal func mapType<T: SQLiteCodable>() -> T.Type {
        let mirror = Mirror(reflecting: self)
        return mirror.subjectType as! T.Type
    }
}
