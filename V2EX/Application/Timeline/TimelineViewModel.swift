//
//  TimelineViewModel.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/12/25.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation

// TODO: Refactor

enum Timeline {
    case node(Node)
    case tab(V2Tab)
}

protocol TimelineViewModel {
    
    var title: String? { get }
    
    var dataSource: [Topic] { get set }
    
    
}
