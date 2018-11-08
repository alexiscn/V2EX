//
//  MainViewController.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/8/9.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import V2SDK

class MainViewController: UIViewController {

    private var headerView: MainHeaderView!
    
    private var scrollViewController: ScrollableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let statusBarHeight = isXScreenLayout ? view.keyWindowSafeAreaInsets.top: 20
        headerView = MainHeaderView(frame: CGRect(x: 0, y: statusBarHeight, width: view.bounds.width, height: 60), tabs: V2Tab.tabs())
        view.addSubview(headerView)
        
        var viewControllers: [UIViewController] = []
        for tab in V2Tab.tabs() {
            viewControllers.append(TimelineViewController(tab: tab))
        }
        let frame = CGRect(x: 0, y: 60 + statusBarHeight, width: view.bounds.width, height: view.bounds.height - 60 - statusBarHeight)
        scrollViewController = ScrollableViewController(frame: frame, viewControllers: viewControllers, startIndex: 0)
        addChild(scrollViewController)
        view.addSubview(scrollViewController.view)
        scrollViewController.didMove(toParent: self)
        scrollViewController.scrollViewControllerPageDidChanged = { [weak self] index in
            self?.headerView.select(at: index)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
}
