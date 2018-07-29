//
//  AtomicInteger.swift
//  SQLiteKit
//
//  Created by xu.shuifeng on 2018/7/21.
//

import Foundation

class AtomicInteger {
    
    private let semaphore = DispatchSemaphore(value: 1)
    private var value: Int = 0
    
    public func get() -> Int {
        semaphore.wait()
        defer { semaphore.signal() }
        return value
    }
    
    public func incrementAndGet() -> Int {
        semaphore.wait()
        defer { semaphore.signal() }
        value += 1
        return value
    }
    
    public func decrementAndGet() -> Int {
        semaphore.wait()
        defer { semaphore.signal() }
        value -= 1
        return value
    }
}
