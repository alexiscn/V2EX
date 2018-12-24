//
//  MyNodesViewModel.swift
//  V2EX
//
//  Created by xushuifeng on 2018/12/22.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class MyNodesViewModel: ListViewModel {
    
    typealias T = MyNode
    
    var title: String? { return "我收藏的节点" }
    
    var dataSouce: [MyNode] = []
    
    var cellClass: UITableViewCell.Type { return MyNodesViewCell.self }
    
    var currentPage: Int = 1
    
    var endPoint: EndPoint { return EndPoint.myNodes() }
    
    var htmlParser: HTMLParser.Type { return MyNodesParser.self }
    
    func heightForRowAt(_ indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func didSelectRowAt(_ indexPath: IndexPath, navigationController: UINavigationController?) {
        let node = dataSouce[indexPath.row]
        if let name = node.nodeName, let title = node.title {
            let timelineVC = TimelineViewController(node: Node(name: name, title: title, letter: ""))
            navigationController?.pushViewController(timelineVC, animated: true)
        }
    }
}
