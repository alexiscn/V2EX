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
        setupContentTextView()
    }
    
    private func setupNavigationBar() {
        //let helpBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_help_24x24_"), style: .done, target: self, action: #selector(helpBarButtonItemTapped(_:)))
        //helpBarButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        
        let sendBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_send_24x24_"), style: .done, target: self, action: #selector(sendBarButtonItemTapped(_:)))
        navigationItem.rightBarButtonItem = sendBarButtonItem
        //navigationItem.rightBarButtonItems = [sendBarButtonItem, helpBarButtonItem]
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
            make.height.equalTo(LineHeight)
        }
    }
    
    private func setupContentTextView() {
        contentTextView = UITextView()
        view.addSubview(contentTextView)
    }
}

extension NewTopicViewController {
    
    @objc fileprivate func helpBarButtonItemTapped(_ sender: Any) {
        let helpVC = UIStoryboard.main.instantiateViewController(ofType: NewTopicHelpViewController.self)
        helpVC.modalTransitionStyle = .crossDissolve
        helpVC.modalPresentationStyle = .overCurrentContext
        present(helpVC, animated: true, completion: nil)
    }
    
    @objc fileprivate func sendBarButtonItemTapped(_ sender: Any) {
        
        func requestOnceToken() {
            let endPoint = EndPoint.createTopicOnce("xxx")
            V2SDK.request(endPoint, parser: CreateTopicOnceParser.self) { (response: V2Response<String>) in
                switch response {
                case .success(let once):
                    print(once)
                case .error(let error):
                    HUD.show(message: error.description)
                }
            }
        }
        
        func createTopic(once: String) {
            let endPoint = EndPoint.createTopic("xxx", title: "xxx", once: once, body: "xxx")
            V2SDK.request(endPoint, parser: CreateTopicParser.self) { (response: V2Response<Bool>) in
                switch response {
                case .success(_):
                    print("success")
                case .error(let error):
                    HUD.show(message: error.description)
                }
            }
        }
    }
}
