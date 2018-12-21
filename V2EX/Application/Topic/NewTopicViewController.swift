//
//  NewTopicViewController.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/12/21.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class NewTopicViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "创作新主题"
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let sendBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_send_24x24_"), style: .done, target: self, action: #selector(sendBarButtonItemTapped(_:)))
        navigationItem.rightBarButtonItem = sendBarButtonItem
    }

    @objc private func sendBarButtonItemTapped(_ sender: Any) {
        
    }
}
