//
//  OpenSourceViewController.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/6/26.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import SafariServices

fileprivate struct OpenSource {
    let title: String
    let url: String
}

class OpenSourceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    fileprivate var dataSource: [OpenSource] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        dataSource.append(OpenSource(title: "Alamofire", url: "https://github.com/alamofire/alamofire"))
        dataSource.append(OpenSource(title: "CRRefresh", url: "https://github.com/CRAnimation/CRRefresh"))
        dataSource.append(OpenSource(title: "GenericNetworking", url: "https://github.com/alexiscn/GenericNetworking"))
        dataSource.append(OpenSource(title: "Kingfisher", url: "https://github.com/onevcat/Kingfisher"))
        dataSource.append(OpenSource(title: "SlideMenuControllerSwift", url: "https://github.com/dekatotoro/SlideMenuControllerSwift"))
        dataSource.append(OpenSource(title: "SnapKit", url: "https://github.com/snapkit/snapkit"))
        dataSource.append(OpenSource(title: "SwiftSoup", url: "https://github.com/scinfu/SwiftSoup"))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let source = dataSource[indexPath.row]
        let url = URL(string: source.url)!
        let safariController = SFSafariViewController(url: url)
        present(safariController, animated: true, completion: nil)
    }
}
