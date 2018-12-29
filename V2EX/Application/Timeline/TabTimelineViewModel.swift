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
    
    weak var coordinator: TimelineCoordinator?
    
    var title: String?
    
    var dataSource: [Topic] = []
    
    var currentPage: Int = 1
    
    required init(source: TimelineSource) {
        self.source = source
        self.title = source.tab?.title
    }
    
    func loadData(isLoadMore: Bool, completion: @escaping (() -> Void)) {
        guard let tab = source.tab else { return }
        currentPage = isLoadMore ? (currentPage + 1): 1
        
        DispatchQueue.global().async {
            let topics = V2DataManager.shared.loadTopics(forTab: tab.key)
            DispatchQueue.main.async {
                if topics.count > 0 {
                    self.dataSource = topics
                    self.coordinator?.reloadData()
                }
            }
            let key = tab.key
            let isRecent = tab == V2Tab.recentTab
            let endPoint = isRecent ? EndPoint.recent(self.currentPage): EndPoint.tab(key)
            V2SDK.request(endPoint, parser: TabParser.self, completion: { [weak self] (response: V2Response<[Topic]>) in
                DispatchQueue.main.async {
                    guard let strongSelf = self else { return }
                    strongSelf.coordinator?.endRefreshing()
                    switch response {
                    case .success(let topics):
                        if isLoadMore {
                            for topic in topics {
                                if !strongSelf.dataSource.contains(where: { $0.url == topic.url }) {
                                    strongSelf.dataSource.append(topic)
                                }
                            }
                        } else {
                            strongSelf.dataSource = topics
                        }
                        strongSelf.coordinator?.reloadData()
                        if tab == V2Tab.recentTab {
                            
                        } else {
                            strongSelf.coordinator?.setNoMoreData()
                        }
                        //                    if strongSelf.tab == V2Tab.recentTab {
                        //                        strongSelf.tableView.mj_footer.resetNoMoreData()
                        //                    } else {
                        //                        strongSelf.setNoMoreData()
                        //                    }
                        topics.forEach { $0.tab = key }
                        V2DataManager.shared.saveTopics(topics, forTab: key)
                    case .error(let error):
                        
                        HUD.show(message: error.description)
                    }
                }
            })
        }
    }
}
