//
//  MyFollowingViewModel.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/12/24.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class MyFollowingViewModel: ListViewModel {
    
    typealias T = Topic
    
    var title: String? { return "我的特别关注" }
    
    var dataSouce: [Topic] = []
    
    var cellClass: UITableViewCell.Type { return TimelineViewCell.self }
    
    var currentPage: Int = 1
    
    var endPoint: EndPoint { return EndPoint.myFollowing() }
    
    var htmlParser: HTMLParser.Type { return TabParser.self }
    
    func heightForRowAt(_ indexPath: IndexPath) -> CGFloat {
        return 0.0
    }
    
    func didSelectRowAt(_ indexPath: IndexPath, navigationController: UINavigationController?) {
        let topic = dataSouce[indexPath.row]
        let detailVC = TopicDetailViewController(url: topic.url, title: topic.title)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
