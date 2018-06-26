//
//  TopicDetailViewController.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/6/26.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import V2SDK

class TopicDetailViewController: UIViewController {

    fileprivate var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TopicCommentViewCell.self, forCellReuseIdentifier: NSStringFromClass(TopicCommentViewCell.self))
        
    }
}


extension TopicDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(TopicCommentViewCell.self), for: indexPath)
        return cell
    }
    
}
