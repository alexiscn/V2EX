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
    private var composeButton: UIButton!
    
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
        setupComposeButton()
        
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
    
    private func setupComposeButton() {
        composeButton = UIButton(type: .system)
        composeButton.layer.cornerRadius = 22.0
        composeButton.backgroundColor = Theme.current.subTitleColor
        composeButton.tintColor = Theme.current.backgroundColor
        composeButton.setImage(UIImage(named: "icon_pen_24x24_"), for: .normal)
        view.addSubview(composeButton)
        composeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            composeButton.heightAnchor.constraint(equalToConstant: 44),
            composeButton.widthAnchor.constraint(equalToConstant: 44),
            composeButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            composeButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20 - view.keyWindowSafeAreaInsets.bottom)
        ])
        composeButton.addTarget(self, action: #selector(composeButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func setupFullGesture() {
        navigationController?.fd_fullscreenPopGestureRecognizer.isEnabled = AppSettings.shared.enableFullScreenGesture
    }
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleFullGestureEnableChanged(_:)), name: NSNotification.Name.V2.FullGestureEnableChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserLoginSuccess(_:)), name: NSNotification.Name.V2.LoginSuccess, object: nil)
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
        composeButton.backgroundColor = Theme.current.subTitleColor
        composeButton.tintColor = Theme.current.backgroundColor
        configureNavigationBar()
    }
    
    private func setupChildViewController() {
        
        if let lastViewedTab = AppSettings.shared.lastViewedTab {
            if let t = V2Tab.tabs().first(where: { $0.key == lastViewedTab }) {
                tab = t
            }
        }
        
        let viewModel = TabTimelineViewModel(tab: tab)
        let timelineViewController = TimelineViewController(viewModel: viewModel)
        timelineViewController.view.frame = view.bounds
        view.addSubview(timelineViewController.view)
        addChild(timelineViewController)
        timelineViewController.didMove(toParent: self)
        timelineVC = timelineViewController
        title = tab.title
    }
    
    private func setupSideMenu() {
        let menuController = MenuViewController()
        menuController.currentTab = tab
        menuController.selectionChangedHandler = { [weak self] tab in
            self?.updateTab(tab)
        }
        let menuNav = SideMenuNavigationController(rootViewController: menuController)
        menuNav.menuWidth = 180.0
        menuNav.presentationStyle = .viewSlideOut
        menuNav.blurEffectStyle = nil
        menuNav.statusBarEndAlpha = 0.0
        menuNav.isNavigationBarHidden = true
        
        let rightMenuController = RightMenuViewController()
        rightMenuVC = rightMenuController
        rightMenuVC?.nodeDidSelectedHandler = { [weak self] node in
            self?.dismiss(animated: true, completion: nil)
            self?.timelineVC?.updateNode(node)
            self?.title = "#\(node.title)"
        }
        let rightNav = SideMenuNavigationController(rootViewController: rightMenuController)
        rightNav.menuWidth = 150
        rightNav.presentationStyle = .viewSlideOut
        rightNav.blurEffectStyle = nil
        rightNav.statusBarEndAlpha = 0.0
        rightNav.isNavigationBarHidden = true
        
        SideMenuManager.default.leftMenuNavigationController = menuNav
        SideMenuManager.default.rightMenuNavigationController = rightNav
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MainViewController {
    
    @objc private func composeButtonTapped(_ sender: Any) {
        if AppContext.current.isLogined {
            let newTopicVC = NewTopicViewController()
            navigationController?.pushViewController(newTopicVC, animated: true)
        } else {
            let loginVC = UIStoryboard.main.instantiateViewController(ofType: LoginViewController.self)
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: true, completion: nil)
        }
    }
    
    @objc private func handleFullGestureEnableChanged(_ notification: Notification) {
        setupFullGesture()
    }
    
    @objc private func handleUserLoginSuccess(_ notification: Notification) {
        V2SDK.dailyMission()
    }
    
    @objc private func menuBarButtonItemTapped(_ sender: Any) {
        if let menuVC = SideMenuManager.default.leftMenuNavigationController {
            present(menuVC, animated: true, completion: nil)
        }
    }
    
    @objc private func searchBarButtonItemTapped(_ sender: Any) {
        let searchVC = SearchViewController()
        searchVC.dismissHandler = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        let nav = SettingsNavigationController(rootViewController: searchVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc private func moreBarButtonItemTapped(_ sender: Any) {
        if let vc = SideMenuManager.default.rightMenuNavigationController {
            present(vc, animated: true, completion: nil)
        }
    }
}
