//
//  RightMenuViewController.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/11/20.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import FDFullscreenPopGesture

class RightMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var nodeDidSelectedHandler: ((_ node: Node) -> Void)?
    var allNodesHandler: RelayCommand?
    
    private var tableView: UITableView!
    private var dataSource: [NodeGroup] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.current.backgroundColor
        
        setupHeader()
        setupTableView()
        setupFooter()
        
        self.fd_prefersNavigationBarHidden = true
        
        V2DataManager.shared.hotNodesChangesCommand = { [weak self] in
            DispatchQueue.main.async {
                self?.dataSource = V2DataManager.shared.loadHotNodes()
                self?.tableView.reloadData()
            }
        }
        dataSource = V2DataManager.shared.loadHotNodes()
        tableView.reloadData()
    }
    
    private func setupHeader() {
        let headerLabel = UILabel(frame: .zero)
        headerLabel.text = NSLocalizedString("节点导航", comment: "")
        headerLabel.textColor = Theme.current.titleColor
        headerLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        view.addSubview(headerLabel)
        
        headerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(14)
            make.trailing.equalToSuperview()
            make.height.equalTo(25)
            make.top.equalToSuperview().offset(65)
        }
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.bottom.equalToSuperview().offset(-100)
        }
    }
    
    private func setupFooter() {
        let allNodesButton = UIButton(type: .system)
        allNodesButton.setTitle(NSLocalizedString("所有节点", comment: ""), for: .normal)
        allNodesButton.backgroundColor = Theme.current.cellBackgroundColor
        allNodesButton.setTitleColor(Theme.current.titleColor, for: .normal)
        allNodesButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        allNodesButton.layer.cornerRadius = 20
        view.addSubview(allNodesButton)
        allNodesButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(tableView.snp.bottom).offset(20)
            make.height.equalTo(40)
            make.width.equalTo(110)
        }
        allNodesButton.addTarget(self, action: #selector(handleAllNodesTapped(_:)), for: .touchUpInside)
    }
    
    @objc private func handleAllNodesTapped(_ sender: Any) {
        let controller = AllNodesViewController()
        controller.nodeDidSelectedHandler = { [weak self] node in
            self?.dismiss(animated: true, completion: nil)
            self?.nodeDidSelectedHandler?(node)
        }
        let nav = SettingsNavigationController(rootViewController: controller)
        present(nav, animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].nodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let group = dataSource[indexPath.section]
        let node = group.nodes[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.textLabel?.text = node.title
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.textLabel?.textColor = Theme.current.titleColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource[section].title
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: 44)))
        header.backgroundColor = Theme.current.cellBackgroundColor
        let label = UILabel(frame: .zero)
        label.text = dataSource[section].title
        label.textColor = Theme.current.subTitleColor
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        header.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.000001
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = dataSource[indexPath.section]
        let node = group.nodes[indexPath.row]
        nodeDidSelectedHandler?(node)
    }
}
