//
//  MainViewController.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/8/9.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import SideMenu

class MainViewController: UIViewController {
    
    private var menuVC: MenuViewController?
    private var timelineVC: TimelineViewController?
    
    var tab: V2Tab = .hotTab
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupChildViewController()
        setupSideMenu()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundColor(Theme.current.navigationBarBackgroundColor, textColor: .white)
        let menuBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_menu_24x24_"), style: .done, target: self, action: #selector(handleLeftBarButtonItemTapped(_:)))
        navigationItem.leftBarButtonItem = menuBarButtonItem
    }
    
    @objc private func handleLeftBarButtonItemTapped(_ sender: Any) {
        
    }
    
    private func updateTab(_ tab: V2Tab) {
        timelineVC?.updateTab(tab)
        title = tab.title
        
        dismiss(animated: true, completion: nil)
    }
    
    private func setupChildViewController() {
        
        let timelineViewController = TimelineViewController(tab: .hotTab)
        timelineViewController.view.frame = view.bounds
        view.addSubview(timelineViewController.view)
        addChild(timelineViewController)
        timelineViewController.didMove(toParent: self)
        timelineVC = timelineViewController
        
        title = V2Tab.hotTab.title
    }
    
    private func setupSideMenu() {
        let menuController = MenuViewController()
        menuController.selectionChangedHandler = { [weak self] tab in
            self?.updateTab(tab)
        }
        menuVC = menuController
        let menuNav = UISideMenuNavigationController(rootViewController: menuController)
        menuNav.isNavigationBarHidden = true
        SideMenuManager.default.menuLeftNavigationController = menuNav
        
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
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
        return .lightContent
    }
}
