//
//  Reflection.swift
//  SQLiteKit
//
//  Created by xu.shuifeng on 2018/7/20.
//

import Foundation

fileprivate var cachedProperties = [HashedType : Array<Property.Description>]()

fileprivate struct Property {
    let key: String
    let value: Any
    
    /// An instance property description
    struct Description {
        let key: String
        let type: Any.Type
        let offset: Int
        func write(_ value: Any, to storage: UnsafeMutableRawPointer) throws {
            return extensions(of: type).write(value, to: storage.advanced(by: offset))
        }
    }
}

fileprivate struct HashedType: Hashable {
    let hashValue: Int
    init(_ type: Any.Type) {
        hashValue = unsafeBitCast(type, to: Int.self)
    }
    init<T>(_ pointer: UnsafePointer<T>) {
        hashValue = pointer.hashValue
    }
}

fileprivate var is64BitPlatform: Bool {
    return MemoryLayout.size(ofValue: Int.self) == MemoryLayout.size(ofValue: Int64.self)
}

struct ClassMetadata {
    var type: Any.Type
}

struct ProtocolTypeContainer {
    let type: Any.Type
    let witnessTable: Int
}

func withClassValuePointer<Value, Result>(of value: inout Value, _ body: (UnsafeMutableRawPointer) -> Result) -> Result {
    return withUnsafePointer(to: &value) {
        let pointer = $0.withMemoryRebound(to: UnsafeMutableRawPointer.self, capacity: 1) { $0.pointee }
        return body(pointer)
    }
}

class Reflection {
    
    class func set<T: SQLiteCodable>(_ value: Any, key: String, for instance: inout T) {
        withClassValuePointer(of: &instance) { pointer in
            let valuePointer = pointer.advanced(by: 1) // TODO
            let sets = reflectable(of: T.self)
            sets.set(value: value, pointer: valuePointer)
        }
    }
}

func set<T>(_ value: Any, key: String, for instance: inout T) {
    
}

fileprivate func properties(_ type: Any.Type) -> [Property.Description] {
    let hashedType = HashedType(type)
    if let properties = cachedProperties[hashedType] {
        return properties
    } else {
        let pointer = unsafeBitCast(type, to: UnsafePointer<Int>.self)
        //let min = pointer.withMemoryRebound(to: <#T##T.Type#>, capacity: <#T##Int#>, <#T##body: (UnsafePointer<T>) throws -> Result##(UnsafePointer<T>) throws -> Result#>)
    }
    return []
}

// MARK: - AnyReflectable

fileprivate protocol AnyReflectable { }

fileprivate extension AnyReflectable {
    static func get(from pointer: UnsafeRawPointer) -> Any {
        return pointer.assumingMemoryBound(to: self).pointee
    }
    
    static func set(value: Any, pointer: UnsafeMutableRawPointer) {
        if let value = value as? Self {
            pointer.assumingMemoryBound(to: self).initialize(to: value)
        }
    }
}

fileprivate func reflectable(of type: Any.Type) -> AnyReflectable.Type {
    let container = ProtocolTypeContainer(type: type, witnessTable: 0)
    return unsafeBitCast(container, to: AnyReflectable.Type.self)
}

// MARK: - Extension

fileprivate protocol AnyExtensions {}

extension AnyExtensions {
    static func write(_ value: Any, to storage: UnsafeMutableRawPointer) {
        if let this = value as? Self {
            storage.assumingMemoryBound(to: self).initialize(to: this)
        }
    }
}

fileprivate func extensions(of type: Any.Type) -> AnyExtensions.Type {
    struct Extensions : AnyExtensions {}
    var extensions: AnyExtensions.Type = Extensions.self
    withUnsafePointer(to: &extensions) { pointer in
        UnsafeMutableRawPointer(mutating: pointer).assumingMemoryBound(to: Any.Type.self).pointee = type
    }
    return extensions
}

fileprivate func extensions(of value: Any) -> AnyExtensions {
    struct Extensions : AnyExtensions {}
    var extensions: AnyExtensions = Extensions()
    withUnsafePointer(to: &extensions) { pointer in
        UnsafeMutableRawPointer(mutating: pointer).assumingMemoryBound(to: Any.self).pointee = value
    }
    return extensions
}
