//
//  TabTimelineViewModel.swift
//  V2EX
//
//  Created by alexiscn on 2018/12/28.
//  Copyright © 2018 alexiscn. All rights reserved.
//

import Foundation

class TabTimelineViewModel: TimelineViewModel {
    
    weak var delegate: TimelineViewModelDelegate?
    
    var tab: V2Tab
    
    var title: String?
    
    var dataSource: [Topic] = []
    
    var currentPage: Int = 1
    
    init(tab: V2Tab) {
        self.tab = tab
        self.title = tab.title
        self.dataSource = []
    }
    
    func loadData(isLoadMore: Bool) {
        
        currentPage = isLoadMore ? (currentPage + 1): 1
        
        DispatchQueue.global().async {
            let topics = V2DataManager.shared.loadTopics(forTab: self.tab.key)
            DispatchQueue.main.async {
                if topics.count > 0 {
                    self.dataSource = topics
                    self.delegate?.reloadData()
                }
            }
            let key = self.tab.key
            let isRecent = self.tab == V2Tab.recentTab
            let endPoint = isRecent ? EndPoint.recent(self.currentPage): EndPoint.tab(key)
            V2SDK.request(endPoint, parser: TabParser.self, completion: { [weak self] (response: V2Response<[Topic]>) in
                DispatchQueue.main.async {
                    guard let strongSelf = self else { return }
                    strongSelf.delegate?.endRefreshing()
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
                        strongSelf.delegate?.reloadData()
                        if strongSelf.tab == V2Tab.recentTab {
                            strongSelf.delegate?.resetNoMoreData()
                        } else {
                            strongSelf.delegate?.setNoMoreData()
                        }
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
