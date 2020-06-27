//
//  NewTopicAccessoryView.swift
//  V2EX
//
//  Created by xushuifeng on 2018/12/23.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class NewTopicAccessoryView: UIView {
    
    var allNodesHandler: RelayCommand?
    
    var keyboardButtonHandler: RelayCommand?
    
    private let containerView: UIView
    
    private let nodesView: NewTopicNodesView
    
    private let nodeButton: UIButton
    
    private let keyboardButton: UIButton
    
    var currentNode: NewTopicNode?
    
    override init(frame: CGRect) {
        
        let nodesFrame = CGRect(x: 0, y: 0, width: frame.width, height: 44)
        nodesView = NewTopicNodesView(frame: nodesFrame)
        nodesView.alpha = 0.0
        nodesView.backgroundColor = Theme.current.cellBackgroundColor
        
        nodeButton = UIButton(type: .custom)
        nodeButton.setTitle(Strings.TopicSelectNode, for: .normal)
        nodeButton.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        nodeButton.setTitleColor(Theme.current.subTitleColor, for: .normal)
        nodeButton.layer.cornerRadius = 12
        nodeButton.layer.borderWidth = 1
        nodeButton.tintColor = Theme.current.subTitleColor
        nodeButton.layer.borderColor = Theme.current.subTitleColor.cgColor
        nodeButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        nodeButton.setImage(UIImage(named: "new_topic_arrow_12x12_")?.withRenderingMode(.alwaysTemplate), for: .normal)
        
        containerView = UIView()
        containerView.backgroundColor = Theme.current.cellBackgroundColor
        
        keyboardButton = UIButton(type: .system)
        keyboardButton.setImage(UIImage(named: "ic_keyboard_hide_24x24_"), for: .normal)
        keyboardButton.tintColor = Theme.current.subTitleColor
        
        super.init(frame: frame)
        
        addSubview(nodesView)
        addSubview(containerView)
        containerView.addSubview(nodeButton)
        containerView.addSubview(keyboardButton)
        
        nodeButton.addTarget(self, action: #selector(handleNodeButtonTapped(_:)), for: .touchUpInside)
        keyboardButton.addTarget(self, action: #selector(handleKeyboardButtonTapped(_:)), for: .touchUpInside)
        nodesView.nodeSelectionHandler = { [weak self] node in
            self?.currentNode = node
            self?.nodeButton.setTitle(node.title, for: .normal)
            self?.hideNodesView()
        }
        nodesView.allNodesHandler = { [weak self] in
            self?.allNodesHandler?()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        nodeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nodeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            nodeButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            nodeButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        keyboardButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            keyboardButton.widthAnchor.constraint(equalToConstant: 24),
            keyboardButton.heightAnchor.constraint(equalToConstant: 24),
            keyboardButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            keyboardButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12)
        ])
    }
    
    func updateNode(_ node: Node) {
        nodeButton.setTitle(node.title, for: .normal)
        currentNode = NewTopicNode(title: node.title, name: node.name)
        hideNodesView()
    }
    
    @objc private func handleKeyboardButtonTapped(_ sender: Any) {
        keyboardButtonHandler?()
    }
    
    @objc private func handleNodeButtonTapped(_ sender: Any) {
        if nodesView.alpha == 0.0 {
            showNodesView()
        } else {
            hideNodesView()
        }
    }
    
    func hideNodesView() {
        UIView.animate(withDuration: 0.2) {
            self.nodesView.alpha = 0.0
        }
    }
    
    func showNodesView() {
        UIView.animate(withDuration: 0.2) {
            self.nodesView.alpha = 1.0
        }
    }
}
