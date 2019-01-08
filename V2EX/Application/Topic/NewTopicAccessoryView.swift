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
    
    private let nodesView: NewTopicNodesView
    
    private let nodeButton: UIButton
    
    private let keyboardButton: UIButton
    
    var currentNode: NewTopicNode?
    
    override init(frame: CGRect) {
        
        let nodesFrame = CGRect(x: 0, y: 0, width: frame.width, height: 44)
        nodesView = NewTopicNodesView(frame: nodesFrame)
        nodesView.alpha = 0.0
        
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
        
        let containerView = UIView()
        
        keyboardButton = UIButton(type: .system)
        keyboardButton.setImage(UIImage(named: "ic_keyboard_hide_24x24_"), for: .normal)
        keyboardButton.tintColor = Theme.current.subTitleColor
        
        super.init(frame: frame)
        
        addSubview(nodesView)
        nodesView.backgroundColor = Theme.current.cellBackgroundColor
        containerView.backgroundColor = Theme.current.cellBackgroundColor
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
        
        containerView.addSubview(nodeButton)
        nodeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.height.equalTo(24)
        }
        
        containerView.addSubview(keyboardButton)
        keyboardButton.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-12)
        }
        
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
