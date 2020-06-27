//
//  NewTopicViewController.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/12/21.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class NewTopicViewController: UIViewController {

    private var topLine: UIView!
    private var titleLabel: UILabel!
    private var titleLine: UIView!
    private var titleTextFieldLine: UIView!
    private var titleTextField: UITextField!
    private var titleCountLabel: UILabel!
    private var contentLabel: UILabel!
    private var contentLabelLine: UIView!
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
        configureConstraints()
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
        sendBarButton = UIBarButtonItem(image: UIImage(named: "nav_send_24x24_"), style: .done, target: self, action: #selector(sendBarButtonItemTapped(_:)))
        navigationItem.rightBarButtonItem = sendBarButton
    }
    
    private func checkButtonEnable() {
        if let text = titleTextField.text, !text.isEmpty {
            sendBarButton.isEnabled = true
        } else {
            sendBarButton.isEnabled = false
        }
    }
    
    private func setupSubviews() {
        
        topLine = lineView()
        view.addSubview(topLine)
        
        titleLabel = infoLabel(title: Strings.TopicTitleTitle)
        view.addSubview(titleLabel)

        titleCountLabel = counterLabel(count: 120)
        view.addSubview(titleCountLabel)
        
        titleLine = lineView()
        view.addSubview(titleLine)
        
        titleTextField = UITextField()
        titleTextField.font = UIFont.systemFont(ofSize: 14)
        titleTextField.attributedPlaceholder = NSAttributedString(string: Strings.TopicTitlePlaceholder, attributes: [.foregroundColor : Theme.current.subTitleColor])
        titleTextField.textColor = Theme.current.titleColor
        view.addSubview(titleTextField)
        
        titleTextField.addTarget(self, action: #selector(titleFieldEditingChanged(_:)), for: .editingChanged)
        
        titleTextFieldLine = lineView()
        view.addSubview(titleTextFieldLine)
        
        contentLabel = infoLabel(title: Strings.TopicBodyTitle)
        view.addSubview(contentLabel)

        contentCountLabel = counterLabel(count: 20000)
        view.addSubview(contentCountLabel)
        
        contentLabelLine = lineView()
        view.addSubview(contentLabelLine)
    
        contentTextView = NewTopicTextView()
        contentTextView.delegate = self
        contentTextView.keyboardDismissMode = .onDrag
        view.addSubview(contentTextView)
        
        titleTextField.becomeFirstResponder()
    }
    
    private func configureConstraints() {
        
        topLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topLine.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            topLine.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            topLine.topAnchor.constraint(equalTo: self.view.topAnchor),
            topLine.heightAnchor.constraint(equalToConstant: LineHeight)
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -12),
            titleLabel.heightAnchor.constraint(equalToConstant: 36),
            titleLabel.topAnchor.constraint(equalTo: topLine.bottomAnchor)
        ])
        
        titleCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleCountLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            titleCountLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -12)
        ])
        
        titleLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLine.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            titleLine.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            titleLine.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            titleLine.heightAnchor.constraint(equalToConstant: LineHeight)
        ])
        
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 12),
            titleTextField.topAnchor.constraint(equalTo: titleLine.bottomAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -12),
            titleTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        titleTextFieldLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleTextFieldLine.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            titleTextFieldLine.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            titleTextFieldLine.topAnchor.constraint(equalTo: titleTextField.bottomAnchor),
            titleTextFieldLine.heightAnchor.constraint(equalToConstant: LineHeight)
        ])
        
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 12),
            contentLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -12),
            contentLabel.topAnchor.constraint(equalTo: titleTextFieldLine.bottomAnchor),
            contentLabel.heightAnchor.constraint(equalToConstant: 36),
        ])
        
        contentCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentCountLabel.centerYAnchor.constraint(equalTo: contentLabel.centerYAnchor),
            contentCountLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -12)
        ])
        
        contentLabelLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentLabelLine.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            contentLabelLine.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            contentLabelLine.topAnchor.constraint(equalTo: contentLabel.bottomAnchor),
            contentLabelLine.heightAnchor.constraint(equalToConstant: LineHeight)
        ])
        
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentTextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            contentTextView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            contentTextView.topAnchor.constraint(equalTo: contentLabelLine.bottomAnchor),
            contentTextView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -view.keyWindowSafeAreaInsets.bottom)
        ])
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
