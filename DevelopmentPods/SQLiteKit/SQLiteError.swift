//
//  SQLiteError.swift
//  SQLiteKit
//
//  Created by xu.shuifeng on 2018/7/17.
//

import Foundation


/// SQLite Errors that maybe throwed by SQLiteKit
///
/// - openDataBaseError: Can not open the database file to operate. With Error Message and error.
/// - executeError: Execute statement occurs exception.
/// - notNullConstraintViolation: Insert or Update not null column with null value.
/// - prepareError: Prepare statement error.
/// - jsonDecoderError: JSONDecoder error. Could not decode data read from database.
/// - notSupportedError: SQLiteKit do not support
public enum SQLiteError: Error {
    case openDataBaseError(String)
    case executeError(Int, String)
    case notNullConstraintViolation(Int, String)
    case prepareError(String)
    case jsonDecoderError(Error)
    case notSupportedError(String)
}
