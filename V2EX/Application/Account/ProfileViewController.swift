//
//  ProfileViewController.swift
//  V2EX
//
//  Created by xushuifeng on 2018/8/13.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.current.backgroundColor
        navigationItem.title = "我的"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func balance() {
        
        let viewModel = BalanceViewModel()
        let controller = ListViewController(vm: viewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func notifications() {
        let vm = NotificationsViewModel()
        let controller = ListViewController(vm: vm)
        navigationController?.pushViewController(controller, animated: true)
    }
}
