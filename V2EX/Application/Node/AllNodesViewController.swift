//
//  AllNodesViewController.swift
//  V2EX
//
//  Created by xushuifeng on 2018/8/14.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class AllNodesViewController: UIViewController {

    var nodeDidSelectedHandler: ((_ node: Node) -> Void)?
    
    fileprivate var tableView: UITableView!
    
    fileprivate var dataSource: [NodeGroup] = []
    
    fileprivate var cachedSize: [IndexPath: CGSize] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.current.backgroundColor
        title = NSLocalizedString("所有节点", comment: "")
        setupNavigationBar()
        setupTableView()
        DispatchQueue.global(qos: .background).async {
            self.loadAllNodes()
        }
        
    }
    
    private func setupNavigationBar() {
        configureNavigationBar()
        let leftItem = UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(leftNavigationButtonTapped(_:)))
        navigationItem.leftBarButtonItem = leftItem
    }
    
    @objc private func leftNavigationButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.sectionIndexColor = Theme.current.subTitleColor
        tableView.sectionIndexBackgroundColor = .clear
        tableView.sectionIndexTrackingBackgroundColor = Theme.current.backgroundColor
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func loadAllNodes() {
        guard let path = Bundle.main.path(forResource: "allnodes", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
                return
        }
        do {
            var groups: [NodeGroup] = []
            let nodes = try JSONDecoder().decode([Node].self, from: data)
            
            let appleNodes = nodes.filter { $0.letter == "" }
            let otherNodes = nodes.filter { $0.letter != "" && !$0.letter.isLetter }
            let letterNodes = nodes.filter { $0.letter.isLetter }
            
            groups.append(NodeGroup(title: "#", nodes: otherNodes))
            
            let dict = Dictionary(grouping: letterNodes, by: { $0.letter })
            var letters = dict.map { return NodeGroup(title: $0.key, nodes: $0.value.sorted(by: { $0.title < $1.title })) }
            letters.sort(by: { $0.title < $1.title })
            groups.append(contentsOf: letters)
            
            groups.append(NodeGroup(title: "", nodes: appleNodes))
            
            DispatchQueue.main.async {
                self.dataSource = groups
                self.tableView.reloadData()
            }
        } catch {
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension AllNodesViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.textLabel?.textColor = Theme.current.titleColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource[section].title
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return dataSource.map { return $0.title }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = dataSource[indexPath.section]
        let node = group.nodes[indexPath.row]
        nodeDidSelectedHandler?(node)
    }
}
