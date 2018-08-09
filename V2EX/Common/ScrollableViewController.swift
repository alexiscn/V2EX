//
//  ScrollViewController.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/8/8.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class ScrollableViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    fileprivate let cellIdentifier = "ScrollableListViewCellIdentifier"
    
    fileprivate var collectionView: UICollectionView!
    fileprivate var viewControllers: [UIViewController]
    fileprivate var currentPage: Int = 0
    
    public var scrollViewControllerPageWillChange: ((_ newIndex: Int) -> Void)?
    
    public var scrollViewControllerPageDidChanged: ((_ newIndex: Int) -> Void)?
    
    public var scrollViewControllerDidScroll: ((_ contentOffset: CGPoint) -> Void)?
    
    init(frame: CGRect, viewControllers: [UIViewController], startIndex: Int = 0) {
        self.currentPage = startIndex
        self.viewControllers = viewControllers
        super.init(nibName: nil, bundle: nil)
        view.frame = frame
        self.setupCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func scrollToIndex(_ index: Int, animated: Bool = true) {
        let pageWidth = self.collectionView.frame.size.width
        let offset = pageWidth * CGFloat(index)
        self.collectionView.setContentOffset(CGPoint(x: offset, y: 0), animated: animated)
        currentPage = index
        self.setNeedsStatusBarAppearanceUpdate()
        self.scrollViewControllerPageDidChanged?(index)
    }
    
    public func setScrollViewEnable(_ enabled: Bool) {
        self.collectionView.isScrollEnabled = enabled
    }
    
    private func setupCollectionView() {
        let collectionFrame = self.view.bounds
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.itemSize = view.bounds.size
        layout.scrollDirection = .horizontal
        
        self.collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: layout)
        self.collectionView.register(ScrollableListViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        self.collectionView.isPagingEnabled = true
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        //self.collectionView.bounces = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.collectionView.scrollsToTop = false
        
        self.view.addSubview(self.collectionView)
        
        self.collectionView.reloadData()
        
        if currentPage > 0 {
            let pageWidth = view.frame.size.width
            let offset = pageWidth * CGFloat(currentPage)
            self.collectionView.setContentOffset(CGPoint(x: offset, y: 0), animated: false)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ScrollableListViewCell
        cell.containerViewController = self
        cell.viewController = viewControllers[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? ScrollableListViewCell {
            cell.viewController = nil
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? ScrollableListViewCell {
            cell.viewController = viewControllers[indexPath.item]
            self.scrollViewControllerPageWillChange?(indexPath.item)
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = collectionView.frame.size.width
        let page = Int(collectionView.contentOffset.x / pageWidth)
        
        currentPage = page
        self.setNeedsStatusBarAppearanceUpdate()
        self.scrollViewControllerPageDidChanged?(page)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollViewControllerDidScroll?(scrollView.contentOffset)
    }
    
    override var childViewControllerForStatusBarStyle: UIViewController? {
        return currentViewController()
    }
    
    override var childViewControllerForStatusBarHidden: UIViewController? {
        return currentViewController()
    }
    
    private func currentViewController() -> UIViewController? {
        if 0..<viewControllers.count ~= currentPage {
            return viewControllers[currentPage]
        }
        return nil
    }
}

fileprivate class ScrollableListViewCell: UICollectionViewCell {
    public weak var containerViewController: UIViewController?
    
    public weak var viewController: UIViewController? {
        willSet {
            self.viewController?.willMove(toParentViewController: nil)
            self.viewController?.view.removeFromSuperview()
            self.viewController?.removeFromParentViewController()
        }
        didSet {
            if let controller = self.viewController, let container = self.containerViewController {
                container.addChildViewController(controller)
                controller.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
                controller.view.frame = self.contentView.bounds
                self.contentView.addSubview(controller.view)
                controller.didMove(toParentViewController: container)
                container.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    
}
