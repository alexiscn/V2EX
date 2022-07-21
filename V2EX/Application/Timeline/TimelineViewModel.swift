//
//  TimelineViewModel.swift
//  V2EX
//
//  Created by alexiscn on 2018/12/25.
//  Copyright © 2018 alexiscn. All rights reserved.
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
