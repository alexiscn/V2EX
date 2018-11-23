//
//  MainViewController.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/8/9.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import SideMenu
import MJRefresh

class MainViewController: UIViewController {
    
    private var rightMenuVC: RightMenuViewController?
    private var timelineVC: TimelineViewController?
    
    var tab: V2Tab = .hotTab
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.current.backgroundColor
        setupNavigationBar()
        setupChildViewController()
        setupSideMenu()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundColor(Theme.current.navigationBarBackgroundColor,
                                                               textColor: Theme.current.navigationBarTextColor)
        let menuBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_menu_24x24_"), style: .done, target: self, action: #selector(menuBarButtonItemTapped(_:)))
        navigationItem.leftBarButtonItem = menuBarButtonItem
        
        let searchBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_search_24x24_"), style: .done, target: self, action: #selector(searchBarButtonItemTapped(_:)))
        searchBarButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        let moreBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_more_24x24_"), style: .done, target: self, action: #selector(moreBarButtonItemTapped(_:)))
        navigationItem.rightBarButtonItems = [moreBarButtonItem, searchBarButtonItem]
    }
    
    @objc private func menuBarButtonItemTapped(_ sender: Any) {
        if let menuVC = SideMenuManager.default.menuLeftNavigationController {
            present(menuVC, animated: true, completion: nil)
        }
    }
    
    @objc private func searchBarButtonItemTapped(_ sender: Any) {
        let searchVC = SearchViewController()
        let nav = SettingsNavigationController(rootViewController: searchVC)
        present(nav, animated: true, completion: nil)
    }
    
    @objc private func moreBarButtonItemTapped(_ sender: Any) {
        if let vc = SideMenuManager.default.menuRightNavigationController {
            present(vc, animated: true, completion: nil)
        }
    }
    
    private func updateTab(_ tab: V2Tab) {
        dismiss(animated: true, completion: nil)
        self.timelineVC?.updateTab(tab)
        self.title = tab.title
        rightMenuVC?.updateDataSource(tab.subTabs)
    }
    
    private func setupChildViewController() {
        
        let timelineViewController = TimelineViewController(tab: .hotTab)
        timelineViewController.view.frame = view.bounds
        view.addSubview(timelineViewController.view)
        addChild(timelineViewController)
        timelineViewController.didMove(toParent: self)
        timelineVC = timelineViewController
        
        timelineVC?.topicSelectionHandler = { [weak self] topic in
            if let topic = topic, let node = topic.nodeName, let name = topic.nodeTitle {
                let controller = TimelineViewController(node: node, nodeName: name)
                self?.navigationController?.pushViewController(controller, animated: true)
            }
        }
        
        title = V2Tab.hotTab.title
    }
    
    private func setupSideMenu() {
        let menuController = MenuViewController()
        menuController.selectionChangedHandler = { [weak self] tab in
            self?.updateTab(tab)
        }
        let menuNav = UISideMenuNavigationController(rootViewController: menuController)
        menuNav.isNavigationBarHidden = true
        
        let rightMenuController = RightMenuViewController()
        rightMenuVC = rightMenuController
        let rightNav = UISideMenuNavigationController(rootViewController: rightMenuController)
        rightNav.isNavigationBarHidden = true
        
        SideMenuManager.default.menuLeftNavigationController = menuNav
        SideMenuManager.default.menuRightNavigationController = rightNav
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.view)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.default.menuWidth = 150.0
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuPresentMode = .viewSlideOut
        SideMenuManager.default.menuBlurEffectStyle = nil
        SideMenuManager.default.menuAnimationFadeStrength = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.current.statusBarStyle
    }
}
