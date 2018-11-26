//
//  RightMenuViewController.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/11/20.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class RightMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var nodeDidSelectedHandler: ((_ node: Node) -> Void)?
    
    private var tableView: UITableView!
    private var dataSource: [NodeGroup] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.current.backgroundColor
        setupTableView()
        
        DispatchQueue.global(qos: .background).async {
            self.loadAllNodes()
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
            
            groups.append(NodeGroup(nodes: otherNodes, title: "#"))
            
            let dict = Dictionary(grouping: letterNodes, by: { $0.letter })
            var letters = dict.map { return NodeGroup(nodes: $0.value.sorted(by: { $0.title < $1.title }), title: $0.key) }
            letters.sort(by: { $0.title < $1.title })
            groups.append(contentsOf: letters)
            
            groups.append(NodeGroup(nodes: appleNodes, title: ""))
            
            DispatchQueue.main.async {
                self.dataSource = groups
                self.tableView.reloadData()
            }
        } catch {
            print(error)
        }
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
            make.top.equalToSuperview().offset(100)
            make.bottom.equalToSuperview()
        }
        tableView.reloadData()
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
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return dataSource.map { return $0.title }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = dataSource[indexPath.section]
        let node = group.nodes[indexPath.row]
        nodeDidSelectedHandler?(node)
    }
}
