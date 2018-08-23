//
//  Encoder.swift
//  SQLiteKit
//
//  Created by xu.shuifeng on 2018/8/3.
//

import Foundation

internal class TableEncoder {
    
    private var encoder = _TableEncoder()
    
    func encode<T: Encodable>(_ value: T) throws -> [String: Any] {
        try value.encode(to: encoder)
        return encoder.values
    }
}

fileprivate class _TableEncoder: Encoder {
    
    var values: [String: Any] = [:]
    
    var codingPath: [CodingKey] = []
    
    var userInfo: [CodingUserInfoKey : Any] = [:]
    
    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        let container = _SQLiteKeyedEncodingContainer<Key>(encoder: self, codingPath: codingPath)
        return KeyedEncodingContainer(container)
    }
    
    func unkeyedContainer() -> UnkeyedEncodingContainer {
        return _SQLiteEncodingContainer(encoder: self, codingPath: codingPath, count: 0)
    }
    
    func singleValueContainer() -> SingleValueEncodingContainer {
        return _SQLiteEncodingContainer(encoder: self, codingPath: codingPath, count: 0)
    }
    
}

fileprivate struct _SQLiteEncodingContainer: UnkeyedEncodingContainer, SingleValueEncodingContainer {
    
    var encoder: Encoder
    
    var codingPath: [CodingKey] = []
    
    var count: Int = 0
    
    mutating func encodeNil() throws { }
    
    mutating func encode<T>(_ value: T) throws where T : Encodable {
        
    }
    
    mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        return encoder.container(keyedBy: keyType)
    }
    
    mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        return encoder.unkeyedContainer()
    }
    
    mutating func superEncoder() -> Encoder {
        return encoder
    }
}

fileprivate struct _SQLiteKeyedEncodingContainer<K: CodingKey>: KeyedEncodingContainerProtocol {
    
    typealias Key = K
    
    var encoder: _TableEncoder
    
    var codingPath: [CodingKey]
    
    mutating func encodeNil(forKey key: K) throws {
        
    }
    
    mutating func encode<T>(_ value: T, forKey key: K) throws where T : Encodable {
        switch value {
        case let v as Data:
            encoder.values[key.stringValue] = v.base64EncodedString()
        case let v as URL:
            encoder.values[key.stringValue] = v.absoluteString
        case let v as UUID:
            encoder.values[key.stringValue] = v.uuidString
        case let v as Date:
            encoder.values[key.stringValue] = v.timeIntervalSinceReferenceDate
        default:
            encoder.values[key.stringValue] = value
        }
    }
    
    mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: K) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        return encoder.container(keyedBy: keyType)
    }
    
    mutating func nestedUnkeyedContainer(forKey key: K) -> UnkeyedEncodingContainer {
        return encoder.unkeyedContainer()
    }
    
    mutating func superEncoder() -> Encoder {
        return _TableEncoder()
    }
    
    mutating func superEncoder(forKey key: K) -> Encoder {
        return _TableEncoder()
    }
}
