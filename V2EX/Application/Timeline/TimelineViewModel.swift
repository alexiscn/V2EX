//
//  TimelineViewModel.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/12/25.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation

protocol TimelineViewModelDelegate: class {
    func reloadData()
    func setNoMoreData()
    func resetNoMoreData()
    func endRefreshing()
}

protocol TimelineViewModel {
    
    var title: String? { get }
    
    var dataSource: [Topic] { get set }
    
    var currentPage: Int { get set }
    
    func loadData(isLoadMore: Bool)
}
