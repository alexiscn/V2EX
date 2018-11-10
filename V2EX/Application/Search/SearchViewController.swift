//
//  SearchViewController.swift
//  V2EX
//
//  Created by xushuifeng on 2018/8/13.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.title = "搜索"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let nodeViewController = NodeListViewController()
        addChild(nodeViewController)
        view.addSubview(nodeViewController.view)
        nodeViewController.view.frame = view.bounds
        nodeViewController.didMove(toParent: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}