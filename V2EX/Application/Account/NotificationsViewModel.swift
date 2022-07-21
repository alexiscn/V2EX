//
//  NotificationsViewModel.swift
//  V2EX
//
//  Created by alexiscn on 2018/12/14.
//  Copyright © 2018 alexiscn. All rights reserved.
//

import UIKit

class NotificationsViewModel: ListViewModel {
    
    typealias DataType = MessageNotification
    
    var dataSouce: [MessageNotification] = []
    
    var title: String? { return Strings.Notifications }
    
    var cellClass: UITableViewCell.Type { return NotificationViewCell.self }
    
    var currentPage: Int = 1
    
    var endPoint: EndPoint { return EndPoint.notifications(page: currentPage) }
    
    var htmlParser: HTMLParser.Type { return NotificationParser.self }
    
    func heightForRowAt(_ indexPath: IndexPath) -> CGFloat {
        var message = dataSouce[indexPath.row]
        return NotificationViewCell.heightForNotification(&message)
    }
    
    func didSelectRowAt(_ indexPath: IndexPath, navigationController: UINavigationController?) {
        let message = dataSouce[indexPath.row]
        guard let topicID = message.topicID else { return }
        let url = URL(string: "https://www.v2ex.com/t/\(topicID)")
        let controller = TopicDetailViewController(url: url, title: message.title)
        navigationController?.pushViewController(controller, animated: true)
    }
}
