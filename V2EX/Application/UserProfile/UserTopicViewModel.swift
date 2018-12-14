//
//  UserTopicViewModel.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/12/14.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class UserTopicViewModel: ListViewModel {
    
    typealias T = Topic
    
    var title: String? { return Strings.ProfileHisTopics }
    
    var dataSouce: [Topic] = []
    
    var cellClass: UITableViewCell.Type { return TimelineViewCell.self }
    
    var currentPage: Int = 1
    
    var endPoint: EndPoint { return EndPoint.memberTopics(username, page: currentPage) }
    
    var apiParser: HTMLParser.Type { return UserTopicsParser.self }
    
    func heightForRowAt(_ indexPath: IndexPath) -> CGFloat {
        var topic = dataSouce[indexPath.row]
        return TimelineViewCell.heightForRowWithTopic(&topic)
    }
    
    func didSelectRowAt(_ indexPath: IndexPath) {
        
    }
    
    let username: String
    
    init(username: String, avatarURL: URL?) {
        self.username = username
        UserTopicsParser.avatarURL = nil
        UserTopicsParser.avatarURL = avatarURL
    }
}
