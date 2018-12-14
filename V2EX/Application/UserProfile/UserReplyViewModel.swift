//
//  UserReplyViewModel.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/12/14.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class UserReplyViewModel: ListViewModel {
    
    typealias T = UserProfileComment
    
    var title: String? { return Strings.ProfileHisComments }
    
    var dataSouce: [UserProfileComment] = []
    
    var cellClass: UITableViewCell.Type { return UserCommentViewCell.self }
    
    var currentPage: Int = 1
    
    var endPoint: EndPoint { return EndPoint.memberReplies(username, page: currentPage) }
    
    var apiParser: HTMLParser.Type { return UserRepliesParser.self }
    
    func heightForRowAt(_ indexPath: IndexPath) -> CGFloat {
        var comment = dataSouce[indexPath.row]
        return UserCommentViewCell.heightForComment(&comment)
    }
    
    func didSelectRowAt(_ indexPath: IndexPath) {
        
    }
    
    let username: String
    
    init(username: String, avatarURL: URL?) {
        self.username = username
        
        UserRepliesParser.username = username
        UserRepliesParser.avatarURL = avatarURL
    }
    
}
