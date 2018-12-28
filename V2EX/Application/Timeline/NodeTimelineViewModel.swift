//
//  NodeTimelineViewModel.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/12/28.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation

class NodeTimelineViewModel: TimelineViewModel {
    
    var source: TimelineSource
    
    var title: String?
    
    var dataSource: [Topic] = []
    
    var currentPage: Int = 1
    
    var nodeDetail: NodeDetail?
    
    required init(source: TimelineSource) {
        self.source = source
    }
    
    func loadData(isLoadMore: Bool) {
        guard let node = source.node else { return }
        let totalPage = nodeDetail?.page ?? Int.max
        if currentPage >= totalPage {
            //setNoMoreData()
            return
        }
        
        currentPage = isLoadMore ? (currentPage + 1): 1
        let endPoint = EndPoint.node(node.name, page: currentPage)
        V2SDK.request(endPoint, parser: NodeTopicsParser.self) { [weak self] (response: V2Response<NodeDetail>) in
            guard let strongSelf = self else { return }
            switch response {
            case .success(let nodeDetail):
                strongSelf.nodeDetail = nodeDetail
                if isLoadMore {
                    strongSelf.dataSource.append(contentsOf: nodeDetail.topics)
                } else {
                    strongSelf.dataSource = nodeDetail.topics
                }
//                strongSelf.tableView.reloadData()
//                strongSelf.tableView.mj_header.endRefreshing()
//                strongSelf.tableView.mj_footer.endRefreshing()
//
//                if nodeDetail.topics.count > 0 {
//                    strongSelf.tableView.mj_footer.resetNoMoreData()
//                } else {
//                    strongSelf.setNoMoreData()
//                }
            case .error(let error):
//                strongSelf.tableView.mj_header.endRefreshing()
//                strongSelf.tableView.mj_footer.endRefreshing()
                HUD.show(message: error.description)
            }
        }
    }
}
