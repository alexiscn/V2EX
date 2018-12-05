//
//  V2SDK+Nodes.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/6/22.
//

import Foundation
import GenericNetworking
import SwiftSoup

extension V2SDK {
    
    // has performance issue
    class func parseHotNodes(_ doc: Document) {
        do {
            var groups: [NodeGroup] = []
            let cells = try doc.select("div.cell")
            for cell in cells {
                let table = try cell.select("table")
                if table.isEmpty() {
                    continue
                }
                let name = try cell.select("span.fade").text()
                if name.isEmpty {
                    continue
                }
                var nodes: [Node] = []
                let nodeElements = try cell.select("a")
                for node in nodeElements {
                    let title = try node.text()
                    let nodeName = try node.attr("href").replacingOccurrences(of: "/go/", with: "")
                    nodes.append(Node(name: nodeName, title: title, letter: name))
                }
                let group = NodeGroup(title: name, nodes: nodes)
                groups.append(group)
            }
            V2DataManager.shared.hotNodesChangesCommand?()
            let allNodes = groups.flatMap { return $0.nodes }
            V2DataManager.shared.saveHotNodes(allNodes)
        } catch {
            print(error)
        }
        
    }
}
