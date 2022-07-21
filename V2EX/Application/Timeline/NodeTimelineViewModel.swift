//
//  NodeTimelineViewModel.swift
//  V2EX
//
//  Created by alexiscn on 2018/12/28.
//  Copyright © 2018 alexiscn. All rights reserved.
//

import Foundation

class NodeTimelineViewModel: TimelineViewModel {
    
    weak var delegate: TimelineViewModelDelegate?
    
    var node: Node
    
    var title: String?
    
    var dataSource: [Topic] = []
    
    var currentPage: Int = 1
    
    var nodeDetail: NodeDetail?
    
    init(node: Node) {
        self.node = node
        self.title = "#" + node.title
        self.dataSource = []
    }
    
    func loadData(isLoadMore: Bool) {
        
        let totalPage = nodeDetail?.page ?? Int.max
        if currentPage >= totalPage {
            delegate?.setNoMoreData()
            return
        }
        
        currentPage = isLoadMore ? (currentPage + 1): 1
        let endPoint = EndPoint.node(node.name, page: currentPage)
        V2SDK.request(endPoint, parser: NodeTopicsParser.self) { [weak self] (response: V2Response<NodeDetail>) in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.endRefreshing()
            switch response {
            case .success(let nodeDetail):
                strongSelf.nodeDetail = nodeDetail
                if isLoadMore {
                    strongSelf.dataSource.append(contentsOf: nodeDetail.topics)
                } else {
                    strongSelf.dataSource = nodeDetail.topics
                }
                strongSelf.delegate?.reloadData()
                if nodeDetail.topics.count > 0 {
                    strongSelf.delegate?.resetNoMoreData()
                } else {
                    strongSelf.delegate?.setNoMoreData()
                }
            case .error(let error):
                HUD.show(message: error.description)
            }
        }
    }
}
