//
//  OpenSourceViewController.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/6/26.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import SafariServices

fileprivate struct OpenSource: Codable {
    let title: String
    let subTitle: String
    let url: String
}

fileprivate class OpenSourceViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = Theme.current.cellHighlightColor
        selectedBackgroundView = backgroundView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class OpenSourceViewController: UITableViewController {

    fileprivate var dataSource: [OpenSource] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = Strings.SettingsOpenSource
        tableView.register(OpenSourceViewCell.self, forCellReuseIdentifier: NSStringFromClass(OpenSourceViewCell.self))
        tableView.backgroundColor = Theme.current.backgroundColor
        tableView.separatorColor = Theme.current.cellBackgroundColor
        tableView.tableFooterView = UIView()
        
        if let path = Bundle.main.path(forResource: "opensource", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            if let list = try? JSONDecoder().decode([OpenSource].self, from: data) {
                dataSource = list
                dataSource.sort(by: { $0.title < $1.title })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(OpenSourceViewCell.self), for: indexPath)
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = Theme.current.titleColor
        cell.detailTextLabel?.textColor = Theme.current.subTitleColor
        cell.accessoryType = .disclosureIndicator
        
        let source = dataSource[indexPath.row]
        cell.textLabel?.text = source.title
        cell.detailTextLabel?.text = source.subTitle
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let source = dataSource[indexPath.row]
        let url = URL(string: source.url)!
        let safariController = SFSafariViewController(url: url)
        present(safariController, animated: true, completion: nil)
    }
}
