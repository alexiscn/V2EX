//
//  NewTopicViewController.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/12/21.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class NewTopicViewController: UIViewController {

    private var titleLabel: UILabel!
    private var titleTextField: UITextField!
    private var titleCountLabel: UILabel!
    private var contentLabel: UILabel!
    private var contentCountLabel: UILabel!
    private var contentTextView: NewTopicTextView!
    private var previewBarButton: UIBarButtonItem!
    private var sendBarButton: UIBarButtonItem!
    private var accessoryView: NewTopicAccessoryView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = Theme.current.backgroundColor
        title = Strings.TopicCreateNewTopic
        setupNavigationBar()
        setupSubviews()
        checkButtonEnable()
    }
    
    override var inputAccessoryView: UIView? {
        if accessoryView == nil {
            let frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 88)
            accessoryView = NewTopicAccessoryView(frame: frame)
            accessoryView?.keyboardButtonHandler = { [weak self] in
                self?.titleTextField.endEditing(true)
                self?.contentTextView.endEditing(true)
            }
            accessoryView?.allNodesHandler = { [weak self] in
                self?.showAllNodes()
            }
        }
        return accessoryView
    }
    
    private func setupNavigationBar() {
//        previewBarButton = UIBarButtonItem(image: UIImage(named: "nav_preview_24x24_"), style: .done, target: self, action: #selector(previewBarButtonItemTapped(_:)))
//        previewBarButton.imageInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        
        sendBarButton = UIBarButtonItem(image: UIImage(named: "nav_send_24x24_"), style: .done, target: self, action: #selector(sendBarButtonItemTapped(_:)))
        navigationItem.rightBarButtonItem = sendBarButton
//        navigationItem.rightBarButtonItems = [sendBarButton, previewBarButton]
    }
    
    private func checkButtonEnable() {
        if let text = titleTextField.text, !text.isEmpty {
            sendBarButton.isEnabled = true
//            previewBarButton.isEnabled = true
        } else {
            sendBarButton.isEnabled = false
//            previewBarButton.isEnabled = false
        }
    }
    
    private func setupSubviews() {
        
        let topLine = lineView()
        view.addSubview(topLine)
        topLine.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(LineHeight)
        }
        
        titleLabel = infoLabel(title: Strings.TopicTitleTitle)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.top.equalTo(topLine.snp.bottom)
            make.height.equalTo(36)
        }
        
        titleCountLabel = counterLabel(count: 120)
        view.addSubview(titleCountLabel)
        titleCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-12)
        }
        
        let titleLine = lineView()
        view.addSubview(titleLine)
        titleLine.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(LineHeight)
        }
        
        titleTextField = UITextField()
        titleTextField.font = UIFont.systemFont(ofSize: 14)
        titleTextField.attributedPlaceholder = NSAttributedString(string: Strings.TopicTitlePlaceholder, attributes: [.foregroundColor : Theme.current.subTitleColor])
        titleTextField.textColor = Theme.current.titleColor
        view.addSubview(titleTextField)
        titleTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.top.equalTo(titleLine.snp.bottom)
            make.height.equalTo(44)
        }
        titleTextField.addTarget(self, action: #selector(titleFieldEditingChanged(_:)), for: .editingChanged)
        
        let titleTextFieldLine = lineView()
        view.addSubview(titleTextFieldLine)
        titleTextFieldLine.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(titleTextField.snp.bottom)
            make.height.equalTo(LineHeight)
        }
        
        contentLabel = infoLabel(title: Strings.TopicBodyTitle)
        view.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.top.equalTo(titleTextFieldLine.snp.bottom)
            make.height.equalTo(36)
        }
        
        contentCountLabel = counterLabel(count: 20000)
        view.addSubview(contentCountLabel)
        contentCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentLabel)
            make.trailing.equalToSuperview().offset(-12)
        }
        
        let contentLabelLine = lineView()
        view.addSubview(contentLabelLine)
        contentLabelLine.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(contentLabel.snp.bottom)
            make.height.equalTo(LineHeight)
        }
    
        contentTextView = NewTopicTextView()
        contentTextView.delegate = self
        contentTextView.keyboardDismissMode = .onDrag
        view.addSubview(contentTextView)
        contentTextView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(contentLabelLine)
            make.bottom.equalToSuperview().offset(-view.keyWindowSafeAreaInsets.bottom)
        }
        
        titleTextField.becomeFirstResponder()
    }
    
    func showAllNodes() {
        let controller = AllNodesViewController()
        controller.nodeDidSelectedHandler = { [weak self] node in
            self?.dismiss(animated: true, completion: nil)
            self?.accessoryView?.updateNode(node)
            self?.titleTextField.becomeFirstResponder()
        }
        let nav = SettingsNavigationController(rootViewController: controller)
        present(nav, animated: true, completion: nil)
    }
    
    func lineView() -> UIView {
        let line = UIView()
        line.backgroundColor = Theme.current.subTitleColor
        line.alpha = 0.8
        return line
    }
    
    func infoLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = Theme.current.subTitleColor
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }
    
    func counterLabel(count: Int) -> UILabel {
        let countLabel = UILabel()
        countLabel.text = String(count)
        countLabel.font = UIFont.systemFont(ofSize: 11)
        countLabel.textColor = Theme.current.subTitleColor
        return countLabel
    }
}

extension NewTopicViewController {
    
    @objc fileprivate func titleFieldEditingChanged(_ sender: Any) {
        checkButtonEnable()
        
        let count = titleTextField.text?.count ?? 0
        let remain = 120 - count
        titleCountLabel.text = String(remain)
        if remain > 0 {
            titleCountLabel.textColor = Theme.current.subTitleColor
        } else {
            titleCountLabel.textColor = .red
        }
    }
    
    @objc fileprivate func previewBarButtonItemTapped(_ sender: Any) {
        let helpVC = UIStoryboard.main.instantiateViewController(ofType: NewTopicHelpViewController.self)
        helpVC.modalTransitionStyle = .crossDissolve
        helpVC.modalPresentationStyle = .overCurrentContext
        present(helpVC, animated: true, completion: nil)
    }
    
    @objc fileprivate func sendBarButtonItemTapped(_ sender: Any) {
        
        guard let title = titleTextField.text, !title.isEmpty else {
            HUD.show(message: Strings.TopicTitleEmptyTips)
            return
        }
        
        guard let node = accessoryView?.currentNode?.name else {
            HUD.show(message: Strings.TopicNodeEmptyTips)
            return
        }
        
        let body = contentTextView.text
        
        func requestOnceToken() {
            let endPoint = EndPoint.createTopicOnce(node)
            V2SDK.request(endPoint, parser: CreateTopicOnceParser.self) { (response: V2Response<String>) in
                switch response {
                case .success(let once):
                    createTopic(once: once)
                case .error(let error):
                    HUD.show(message: error.description)
                }
            }
        }
        
        func createTopic(once: String) {
            let endPoint = EndPoint.createTopic(node, title: title, once: once, body: body)
            V2SDK.request(endPoint, parser: CreateTopicParser.self) { (response: V2Response<Bool>) in
                switch response {
                case .success(_):
                    HUD.show(message: "主题发布成功")
                    self.navigationController?.popViewController(animated: true)
                case .error(let error):
                    HUD.show(message: error.description)
                }
            }
        }
    }
}

extension NewTopicViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let count = textView.text.count
        let remain = 20000 - count
        contentCountLabel.text = String(remain)
        if remain > 0 {
            contentCountLabel.textColor = Theme.current.subTitleColor
        } else {
            contentCountLabel.textColor = .red
        }
    }
}
