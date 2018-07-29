//
//  SQLiteModelProtocol.swift
//  SQLiteKit
//
//  Created by xu.shuifeng on 2018/5/28.
//  Copyright © 2018 Meteor. All rights reserved.
//

import Foundation

/// Represent a table in MFDB
public protocol SQLiteModelProtocol: Codable {
    
    static var tableName: String { get }
    
    static var columns: [SQLiteColumn] { get }
    
    var values: [Any] { get }
}
