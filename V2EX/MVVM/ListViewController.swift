//
//  ListViewController.swift
//  V2EX
//
//  Created by alexiscn on 2018/12/13.
//  Copyright © 2018 alexiscn. All rights reserved.
//

import UIKit
import MJRefresh

/// 通用分页页面，复用View逻辑
class ListViewController<T: ListViewModel>: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var tableView: UITableView!
    
    private var viewModel: T

    init(viewModel: T) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.current.backgroundColor
        title = viewModel.title
        setupTableView()
        tableView.mj_header?.beginRefreshing()
    }
    
    fileprivate func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.register(viewModel.cellClass, forCellReuseIdentifier: NSStringFromClass(viewModel.cellClass))
        view.addSubview(tableView)
        tableView.mj_header = V2RefreshHeader { [weak self] in
            self?.loadData(isLoadMore: false)
        }
        tableView.mj_footer = V2RefreshFooter { [weak self] in
            self?.loadData(isLoadMore: true)
        }
    }
    
    private func loadData(isLoadMore: Bool) {
        
        viewModel.loadData(isLoadMore: isLoadMore) { [weak self] (info) in
            if info.isLoadMore {
                self?.tableView.mj_footer?.endRefreshing()
            } else {
                self?.tableView.mj_header?.endRefreshing()
            }
            if info.canLoadMore {
                 self?.tableView.mj_footer?.resetNoMoreData()
            } else {
               self?.tableView.mj_footer?.endRefreshingWithNoMoreData()
            }
            self?.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSouce.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = NSStringFromClass(viewModel.cellClass)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.backgroundColor = .clear
        let model = viewModel.dataSouce[indexPath.row]
        if let listCell = cell as? ListViewCell {
            listCell.update(model)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightForRowAt(indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        viewModel.didSelectRowAt(indexPath, navigationController: navigationController)
    }
}
