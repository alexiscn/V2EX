//
//  TabTimelineViewModel.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/12/28.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation

class TabTimelineViewModel: TimelineViewModel {
    
    var source: TimelineSource
    
    var title: String?
    
    var dataSource: [Topic] = []
    
    var currentPage: Int = 1
    
    required init(source: TimelineSource) {
        self.source = source
    }
    
    func loadData(isLoadMore: Bool) {
        //        recentPage = isLoadMore ? (recentPage + 1): 1
        //
        //        DispatchQueue.global().async {
        //            let topics = V2DataManager.shared.loadTopics(forTab: self.tab.key)
        //            DispatchQueue.main.async {
        //                if topics.count > 0 {
        //                    self.dataSource = topics
        //                    self.tableView.reloadData()
        //                }
        //            }
        //            let key = self.tab.key
        //            let isRecent = self.tab == V2Tab.recentTab
        //            let endPoint = isRecent ? EndPoint.recent(self.recentPage): EndPoint.tab(key)
        //            V2SDK.request(endPoint, parser: TabParser.self, completion: { [weak self] (response: V2Response<[Topic]>) in
        //                guard let strongSelf = self else { return }
        //                switch response {
        //                case .success(let topics):
        //                    if isLoadMore {
        //                        for topic in topics {
        //                            if !strongSelf.dataSource.contains(where: { $0.url == topic.url }) {
        //                                strongSelf.dataSource.append(topic)
        //                            }
        //                        }
        //                    } else {
        //                        strongSelf.dataSource = topics
        //                    }
        //                    strongSelf.tableView.reloadData()
        //                    strongSelf.tableView.mj_header.endRefreshing()
        //                    if strongSelf.tab == V2Tab.recentTab {
        //                        strongSelf.tableView.mj_footer.resetNoMoreData()
        //                    } else {
        //                        strongSelf.setNoMoreData()
        //                    }
        //                    topics.forEach { $0.tab = key }
        //                    V2DataManager.shared.saveTopics(topics, forTab: key)
        //                case .error(let error):
        //                    strongSelf.tableView.mj_header.endRefreshing()
        //                    HUD.show(message: error.description)
        //                }
        //            })
        //        }
    }
}
