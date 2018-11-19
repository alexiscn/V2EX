//
//  SettingsViewController.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/6/26.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class SettingsNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

class SettingsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "设置"
        view.backgroundColor = Theme.current.backgroundColor
        setupNavigationBar()
        //tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundColor(Theme.current.navigationBarBackgroundColor, textColor: .white)
        
        let leftItem = UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(leftNavigationButtonTapped(_:)))
        navigationItem.leftBarButtonItem = leftItem
    }
    
    @objc private func leftNavigationButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
