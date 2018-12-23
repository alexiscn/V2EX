//
//  TopicDetail.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/11/17.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import UIKit

struct TopicDetail {
    
    var _rowHeight: CGFloat = 0.0
    
    var title: String?
    
    var author: String?
    
    var authorAvatarURL: URL?
    
    var contentHTML: String?
    
    var small: String?
    
    var likes: String?
    
    var page: Int = 1
    
    var nodeName: String?
    
    var nodeTag: String?
    
    var replyList: [Reply] = []
    
    var csrfToken: String?
    
    var favorited: Bool = false
}
