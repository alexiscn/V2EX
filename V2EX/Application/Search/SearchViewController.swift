//
//  SearchViewController.swift
//  V2EX
//
//  Created by xushuifeng on 2018/8/13.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchControllerDelegate {

    private var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.current.backgroundColor
        configureNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
