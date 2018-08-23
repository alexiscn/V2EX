//
//  Decoder.swift
//  SQLiteKit
//
//  Created by xu.shuifeng on 2018/8/3.
//

import Foundation

internal class SQLiteDecoder {
    
    static func decode<T: SQLiteCodable>(_ type: T.Type) {
        let decoder = _TableDecoder(codingPath: [])
        let _ = try? type.init(from: decoder)
        print(decoder.properties)
    }
    
}

fileprivate class _TableDecoder: Decoder {
    
    var codingPath: [CodingKey]
    
    var properties: [String: Any] = [:]
    
    var userInfo: [CodingUserInfoKey : Any] = [:]
    
    fileprivate init(codingPath: [CodingKey] = []) {
        self.codingPath = codingPath
    }
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        return KeyedDecodingContainer<Key>(_KeyedDecodingContainer<Key>(decoder: self))
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        return _UnKeyedDecodingContainer(decoder: self)
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        return _SingleValueDecodingContainer(decoder: self)
    }
    
}

fileprivate class _KeyedDecodingContainer<K: CodingKey>: KeyedDecodingContainerProtocol {
    
    typealias Key = K
    
    var codingPath: [CodingKey] {
        return []
    }
    
    private let decoder: _TableDecoder
    
    fileprivate init(decoder: _TableDecoder) {
        self.decoder = decoder
    }
    
    fileprivate var allKeys: [K] { return [] }
    
    func contains(_ key: K) -> Bool {
        return true
    }
    
    func decodeNil(forKey key: K) throws -> Bool {
        
        decoder.properties[key.stringValue] = NSNull.self
        return true
    }
    
    func decode(_ type: Bool.Type, forKey key: K) throws -> Bool {
        decoder.properties[key.stringValue] = Bool.self
        return false
    }
    
    func decode(_ type: String.Type, forKey key: K) throws -> String {
        decoder.properties[key.stringValue] = String.self
        return ""
    }
    
    func decode(_ type: Double.Type, forKey key: K) throws -> Double {
        decoder.properties[key.stringValue] = Double.self
        return 0
    }
    
    func decode(_ type: Float.Type, forKey key: K) throws -> Float {
        decoder.properties[key.stringValue] = Float.self
        return 0
    }
    
    func decode(_ type: Int.Type, forKey key: K) throws -> Int {
        decoder.properties[key.stringValue] = Int.self
        return 0
    }
    
    func decode(_ type: Int8.Type, forKey key: K) throws -> Int8 {
        decoder.properties[key.stringValue] = Int8.self
        return 0
    }
    
    func decode(_ type: Int16.Type, forKey key: K) throws -> Int16 {
        decoder.properties[key.stringValue] = Int16.self
        return 0
    }
    
    func decode(_ type: Int32.Type, forKey key: K) throws -> Int32 {
        decoder.properties[key.stringValue] = Int32.self
        return 0
    }
    
    func decode(_ type: Int64.Type, forKey key: K) throws -> Int64 {
        decoder.properties[key.stringValue] = Int64.self
        return 0
    }
    
    func decode(_ type: UInt.Type, forKey key: K) throws -> UInt {
        decoder.properties[key.stringValue] = UInt.self
        return 0
    }
    
    func decode(_ type: UInt8.Type, forKey key: K) throws -> UInt8 {
        decoder.properties[key.stringValue] = UInt8.self
        return 0
    }
    
    func decode(_ type: UInt16.Type, forKey key: K) throws -> UInt16 {
        decoder.properties[key.stringValue] = UInt16.self
        return 0
    }
    
    func decode(_ type: UInt32.Type, forKey key: K) throws -> UInt32 {
        decoder.properties[key.stringValue] = UInt32.self
        return 0
    }
    
    func decode(_ type: UInt64.Type, forKey key: K) throws -> UInt64 {
        decoder.properties[key.stringValue] = UInt32.self
        return 0
    }
    
    func decode<T>(_ type: T.Type, forKey key: K) throws -> T where T : Decodable {
        throw SQLiteError.notSupportedError(".....")
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: K) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        return KeyedDecodingContainer<NestedKey>(_KeyedDecodingContainer<NestedKey>(decoder: decoder))
    }
    
    func nestedUnkeyedContainer(forKey key: K) throws -> UnkeyedDecodingContainer {
        return _UnKeyedDecodingContainer(decoder: decoder)
    }
    
    func superDecoder() throws -> Decoder {
        return decoder
    }
    
    func superDecoder(forKey key: K) throws -> Decoder {
        return decoder
    }
    
    
}

fileprivate class _SingleValueDecodingContainer : SingleValueDecodingContainer {
    
    var codingPath: [CodingKey] {
        return []
    }
    
    var decoder: _TableDecoder
    
    fileprivate init(decoder: _TableDecoder){
        self.decoder = decoder
    }
    
    public func decodeNil() -> Bool {
        return true
    }
    
    public func decode<T: Decodable>(_ type: T.Type) throws -> T {
        let child = _TableDecoder()
        let result = try T(from: child)
        return result
    }
}

fileprivate class _UnKeyedDecodingContainer: UnkeyedDecodingContainer {
    
    var codingPath: [CodingKey] {
        return decoder.codingPath
    }
    
    public var count: Int? {
        return 1
    }
    
    var isAtEnd: Bool = true
    
    public var currentIndex: Int = 0
    
    private let decoder: _TableDecoder
    
    fileprivate init(decoder: _TableDecoder){
        self.decoder = decoder
    }
    
    public func decodeNil() -> Bool {
        return true
    }
    
    public func decode<T: Decodable>(_ type: T.Type) throws -> T {
        return try T(from: decoder)
    }
    
    public func nestedContainer<NestedKey>(keyedBy: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> {
        return KeyedDecodingContainer<NestedKey>(_KeyedDecodingContainer<NestedKey>(decoder: decoder))
    }
    
    public func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        return self
    }
    
    public func superDecoder() throws -> Decoder {
        return decoder
    }
}
