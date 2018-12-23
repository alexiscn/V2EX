//
//  NewTopicViewController.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/12/21.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class NewTopicViewController: UIViewController {

    private var titleTextField: UITextField!
    private var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = Theme.current.backgroundColor
        title = "创作新主题"
        setupNavigationBar()
        setupTitleTextField()
    }
    
    private func setupNavigationBar() {
        let helpBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_help_24x24_"), style: .done, target: self, action: #selector(helpBarButtonItemTapped(_:)))
        helpBarButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        
        let sendBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_send_24x24_"), style: .done, target: self, action: #selector(sendBarButtonItemTapped(_:)))
        navigationItem.rightBarButtonItems = [sendBarButtonItem, helpBarButtonItem]
    }
    
    private func setupTitleTextField() {
        titleTextField = UITextField()
        titleTextField.placeholder = "输入主题标题(0-120)"
        titleTextField.textColor = Theme.current.titleColor
        view.addSubview(titleTextField)
        titleTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.top.equalToSuperview().offset(2)
            make.height.equalTo(44)
        }
        
        let line = UIView()
        line.backgroundColor = Theme.current.titleColor
        view.addSubview(line)
        line.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.top.equalTo(titleTextField.snp.bottom)
            make.height.equalTo(0.5)
        }
    }
}

extension NewTopicViewController {
    
    @objc fileprivate func helpBarButtonItemTapped(_ sender: Any) {
        let url = URL(string: "https://shuifeng.me/v2ex/new_topic_help.html")!
        presentSafariViewController(url: url)
    }
    
    @objc fileprivate func sendBarButtonItemTapped(_ sender: Any) {
        
    }
}
