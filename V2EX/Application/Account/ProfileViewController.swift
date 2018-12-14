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
        
        let button = UIButton(type: .system)
        button.setTitle("Balance", for: .normal)
        button.setTitleColor(Theme.current.titleColor, for: .normal)
        view.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        button.addTarget(self, action: #selector(balance), for: .touchUpInside)
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
