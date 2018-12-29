//
//  TimelineViewModel.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/12/25.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation

enum TimelineSource {
    case node(Node)
    case tab(V2Tab)
    
    var node: Node? {
        switch self {
        case .node(let n):
            return n
        default:
            return nil
        }
    }
    
    var tab: V2Tab? {
        switch self {
        case .tab(let t):
            return t
        default:
            return nil
        }
    }
}

protocol TimelineCoordinator: class {
    func reloadData()
    func setNoMoreData()
    func endRefreshing()
}

protocol TimelineViewModel {
    
    var source: TimelineSource { get set }
    
    var title: String? { get }
    
    var dataSource: [Topic] { get set }
    
    var currentPage: Int { get set }
    
    init(source: TimelineSource)
 
    func loadData(isLoadMore: Bool, completion: @escaping (() -> Void))
}

extension TimelineViewModel {
    
    func update(source: TimelineSource) {
        
    }
}
