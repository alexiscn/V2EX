//
//  BalanceViewModel.swift
//  V2EX
//
//  Created by xushuifeng on 2018/12/14.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class BalanceViewModel: ListViewModel {
    
    typealias T = Balance
    
    var dataSouce: [Balance] = []
    
    var cellClass: UITableViewCell.Type { return BalanceViewCell.self }
    
    var currentPage: Int = 1
    
    var endPoint: EndPoint { return EndPoint.balance(page: currentPage) }
    
    var apiParser: HTMLParser.Type { return BalanceParser.self }
    
}
