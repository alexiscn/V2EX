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
import FDFullscreenPopGesture

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
        setNeedsStatusBarAppearanceUpdate()
        registerNotifications()
        setupFullGesture()
        
        ThemeManager.shared.observeThemeUpdated { [weak self] _ in
            self?.updateTheme()
        }
    }
    
    private func setupNavigationBar() {
        configureNavigationBar()
        let menuBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_menu_24x24_"), style: .done, target: self, action: #selector(menuBarButtonItemTapped(_:)))
        navigationItem.leftBarButtonItem = menuBarButtonItem
        
        let searchBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_search_24x24_"), style: .done, target: self, action: #selector(searchBarButtonItemTapped(_:)))
        searchBarButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        let moreBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_more_24x24_"), style: .done, target: self, action: #selector(moreBarButtonItemTapped(_:)))
        navigationItem.rightBarButtonItems = [moreBarButtonItem, searchBarButtonItem]
    }
    
    private func setupFullGesture() {
        navigationController?.fd_fullscreenPopGestureRecognizer.isEnabled = AppSettings.shared.enableFullScreenGesture
    }
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleFullGestureEnableChanged(_:)), name: NSNotification.Name.V2.FullGestureEnableChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserLoginSuccess(_:)), name: NSNotification.Name.V2.LoginSuccess, object: nil)
    }
    
    @objc private func handleFullGestureEnableChanged(_ notification: Notification) {
        setupFullGesture()
    }
    
    @objc private func handleUserLoginSuccess(_ notification: Notification) {
        V2SDK.dailyMission()
    }
    
    @objc private func menuBarButtonItemTapped(_ sender: Any) {
        if let menuVC = SideMenuManager.default.menuLeftNavigationController {
            present(menuVC, animated: true, completion: nil)
        }
    }
    
    @objc private func searchBarButtonItemTapped(_ sender: Any) {
        let searchVC = SearchViewController()
        searchVC.dismissHandler = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
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
        self.rightMenuVC?.updateTab(tab)
        self.title = tab.title
        AppSettings.shared.lastViewedTab = tab.key
        AppSettings.shared.lastViewedNode = nil
    }
    
    private func updateTheme() {
        self.view.backgroundColor = Theme.current.backgroundColor
        self.navigationController?.setNeedsStatusBarAppearanceUpdate()
        configureNavigationBar()
    }
    
    private func setupChildViewController() {
        
        if let lastViewedTab = AppSettings.shared.lastViewedTab {
            if let t = V2Tab.tabs().first(where: { $0.key == lastViewedTab }) {
                tab = t
            }
        }
        
        let timelineViewController = TimelineViewController(tab: tab)
        timelineViewController.view.frame = view.bounds
        view.addSubview(timelineViewController.view)
        addChild(timelineViewController)
        timelineViewController.didMove(toParent: self)
        timelineVC = timelineViewController
        
        timelineVC?.topicSelectionHandler = { [weak self] topic in
            if let topic = topic, let name = topic.nodeName, let title = topic.nodeTitle {
                let node = Node.nodeWithName(name, title: title)
                let controller = TimelineViewController(node: node)
                self?.navigationController?.pushViewController(controller, animated: true)
            }
        }
        timelineVC?.userTappedHandler = { [weak self] username in
            if let name = username {
                let controller = UserProfileViewController(username: name)
                self?.navigationController?.pushViewController(controller, animated: true)
            }
        }
        
        title = tab.title
    }
    
    private func setupSideMenu() {
        let menuController = MenuViewController()
        menuController.currentTab = tab
        menuController.selectionChangedHandler = { [weak self] tab in
            self?.updateTab(tab)
        }
        let menuNav = UISideMenuNavigationController(rootViewController: menuController)
        menuNav.menuWidth = 180.0
        menuNav.isNavigationBarHidden = true
        
        let rightMenuController = RightMenuViewController()
        rightMenuVC = rightMenuController
        rightMenuVC?.nodeDidSelectedHandler = { [weak self] node in
            self?.dismiss(animated: true, completion: nil)
            self?.timelineVC?.updateNode(node)
            self?.title = "#\(node.title)"
        }
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
}
