//
//  V2DataManager.swift
//  V2EX
//
//  Created by xushuifeng on 2018/7/28.
//

import Foundation
import AVFoundation
import WCDBSwift

class V2DataManager {
    
    struct Tables {
        static let topic = "tb_topic"
        static let reply = "tb_reply"
        static let nodes = "tb_hot_nodes"
    }
    
    static let shared = V2DataManager()
    
    var hotNodesChangesCommand: RelayCommand?
    
    fileprivate let database: Database
    
    fileprivate let queue = DispatchQueue(label: "com.v2ex.datamanager")
    
    private init() {
        let path = NSHomeDirectory().appending("/Documents/v2.sqlite")
        //try? FileManager.default.removeItem(atPath: path)
        database = Database(withPath: path)
        do {
            try database.create(table: Tables.topic, of: Topic.self)
            try database.create(table: Tables.reply, of: Reply.self)
            try database.create(table: Tables.nodes, of: Node.self)
        } catch {
            print(error)
        }
    }
    
    func loadTopics(forTab tab: String) -> [Topic] {
        do {
            let condition = Topic.Properties.tab == tab
            let objects: [Topic] = try database.getObjects(fromTable: Tables.topic, where: condition)
            return objects
        } catch {
            print(error)
        }
        return []
    }
    
    func saveTopics(_ topics: [Topic], forTab tab: String) {
        queue.async {
            do {
                let condition = Topic.Properties.tab == tab
                try self.database.delete(fromTable: Tables.topic, where: condition)
                try self.database.insert(objects: topics, intoTable: Tables.topic)
            } catch {
                print(error)
            }
        }
    }
    
    func loadHotNodes() -> [NodeGroup] {
        do {
            let objects: [Node] = try database.getObjects(fromTable: Tables.nodes)
            let dict = Dictionary(grouping: objects, by: { $0.letter })
            let groups = dict.map { return NodeGroup(title: $0.key, nodes: $0.value.sorted { $0.title < $1.title }) }
            return groups
        } catch {
            print(error)
        }
        return []
    }
    
    func saveHotNodes(_ nodes: [Node]) {
        do {
            try database.delete(fromTable: Tables.nodes)
            try database.insert(objects: nodes, intoTable: Tables.nodes)
        } catch {
            print(error)
        }
    }
}

