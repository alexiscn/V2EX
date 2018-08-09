//
//  ScrollViewController.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/8/8.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

public protocol ScrollViewControllerDelegate: class {
    
    func scrollViewController(_ controller: ScrollViewController, didMoveToIndex index: Int)
    
}

public class ScrollViewController: UIViewController {
    
    public var currentIndex: Int = 0
    public weak var delegate: ScrollViewControllerDelegate?
    
    
    fileprivate let tabMenuScrollView = UIScrollView()
    fileprivate let controllerScrollView = UIScrollView()
    
    fileprivate var viewControllers: [UIViewController] = []
    
    public init(viewControllers: [UIViewController], startIndex: Int) {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = viewControllers
        self.currentIndex = startIndex
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func setup() {
        
        controllerScrollView.isPagingEnabled = true
        controllerScrollView.translatesAutoresizingMaskIntoConstraints = false
        controllerScrollView.showsVerticalScrollIndicator = false
        controllerScrollView.showsHorizontalScrollIndicator = false
        controllerScrollView.scrollsToTop = false
        controllerScrollView.delegate = self
        controllerScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(viewControllers.count), height: 0.0)
        
        self.view.addSubview(controllerScrollView)
        
        tabMenuScrollView.translatesAutoresizingMaskIntoConstraints = false
        tabMenuScrollView.showsVerticalScrollIndicator = false
        tabMenuScrollView.showsHorizontalScrollIndicator = false
        tabMenuScrollView.scrollsToTop = false
        tabMenuScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60)
        
        let menuTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTabMenuItemTapped(_:)))
        menuTapGesture.numberOfTapsRequired = 1
        menuTapGesture.numberOfTouchesRequired = 1
        menuTapGesture.delegate = self
        tabMenuScrollView.addGestureRecognizer(menuTapGesture)
        
        for (index, controller) in viewControllers.enumerated() {
            
            if index == currentIndex {
                controller.viewWillAppear(true)
                addViewController(index)
                controller.viewDidAppear(true)
            }
            
        }
    }
    
    @objc fileprivate func handleTabMenuItemTapped(_ gesture: UITapGestureRecognizer) {
        
    }
    
    fileprivate func addViewController(_ index: Int) {
        
        let newViewController = viewControllers[index]
        newViewController.willMove(toParentViewController: self)
        newViewController.view.frame = CGRect(x: view.frame.width * CGFloat(index), y: 0, width: view.frame.width, height: view.frame.height)
        addChildViewController(newViewController)
        controllerScrollView.addSubview(newViewController.view)
        newViewController.didMove(toParentViewController: self)
    }
    
    fileprivate func removeViewController(_ index: Int) {
        let vc = viewControllers[index]
        vc.willMove(toParentViewController: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParentViewController()
        vc.didMove(toParentViewController: nil)
    }
}

extension ScrollViewController: UIGestureRecognizerDelegate {
    
}

extension ScrollViewController: UIScrollViewDelegate {
    
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.isEqual(controllerScrollView) {
            
        }
    }
}
