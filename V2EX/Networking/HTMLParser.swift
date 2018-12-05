//
//  HTMLParser.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/12/5.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import SwiftSoup

protocol HTMLParser {
    static func handle<T>(_ doc: Document) -> (T?, Error?)
}

struct TabParser: HTMLParser {
    
    static func handle<T>(_ doc: Document) -> (T?, Error?) {
        do {
            let cells = try doc.select("div")
            var topics: [Topic] = []
            for cell in cells {
                if !cell.hasClass("cell item") {
                    continue
                }
                let topic = V2SDK.parseTopicListCell(cell)
                topics.append(topic)
            }
            return (topics as? T, nil)
        } catch {
            print(error)
            return (nil, error)
        }
    }
}
