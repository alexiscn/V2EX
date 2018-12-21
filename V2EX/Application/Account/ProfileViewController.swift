//
//  ProfileViewController.swift
//  V2EX
//
//  Created by xushuifeng on 2018/8/13.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.current.backgroundColor
        setupNavigationBar()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        let moreBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_more_24x24_"), style: .done, target: self, action: #selector(moreBarButtonItemTapped(_:)))
        navigationItem.rightBarButtonItem = moreBarButtonItem
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView.backgroundColor = .clear
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.showsHorizontalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        
        let header = ProfileHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 300))
        tableView.tableHeaderView = header
        header.update()
    }
    
    @objc private func moreBarButtonItemTapped(_ sender: Any) {
        let actionSheet = ActionSheet(title: nil, message: nil)
        actionSheet.addAction(Action(title: Strings.SettingsLogout, style: .default, handler: { _ in
            
        }))
        
        actionSheet.addAction(Action(title: Strings.Cancel, style: .cancel, handler: { _ in
            
        }))
        actionSheet.show()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func balance() {
        
        let viewModel = BalanceViewModel()
        let controller = ListViewController(viewModel: viewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func notifications() {
        let viewModel = NotificationsViewModel()
        let controller = ListViewController(viewModel: viewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
