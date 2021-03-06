//
//  ListViewModel.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/12/13.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import UIKit

protocol DataType { }

protocol ListViewCell {
    func update(_ model: DataType)
}

protocol ListViewModel: class {
    
    /// model 类型
    associatedtype T: DataType
    
    /// 页面标题
    var title: String? { get }
    
    /// tableView的数据源
    var dataSouce: [T] { get set }
    
    /// tableView 注册的UITableViewCell的类型
    var cellClass: UITableViewCell.Type { get }
    
    /// 当前页码，默认为1
    var currentPage: Int { get set }
    
    var endPoint: EndPoint { get }
    
    var htmlParser: HTMLParser.Type { get }
    
    func heightForRowAt(_ indexPath: IndexPath) -> CGFloat
    
    func didSelectRowAt(_ indexPath: IndexPath, navigationController: UINavigationController?)
}

extension ListViewModel {
    
    func loadData(isLoadMore: Bool, completion: @escaping ((ListDataInfo) -> Void)) {
        currentPage = isLoadMore ? (currentPage + 1): 1
        
        V2SDK.request(endPoint, parser: htmlParser) { [weak self] (response: V2Response<ListResponse<T>>) in
            guard let strongSelf = self else { return }
            var info = ListDataInfo(isLoadMore: isLoadMore, canLoadMore: true)
            switch response {
            case .success(let result):
                if isLoadMore {
                    strongSelf.dataSouce.append(contentsOf: result.list)
                } else {
                    strongSelf.dataSouce = result.list
                }
                info.canLoadMore = strongSelf.currentPage < result.page
            case .error(let error):
                HUD.show(message: error.description)
            }
            completion(info)
        }
    }
}

struct ListDataInfo {
    var isLoadMore: Bool
    var canLoadMore: Bool
}

struct ListResponse<T: DataType> {
    var list: [T] = []
    var page: Int = 1
}
