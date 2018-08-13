//
//  MainHeaderView.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/8/9.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import V2SDK
import SnapKit

class MainHeaderView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {

    private let collectionView: UICollectionView
    
    private var dataSource: [V2Tab]
    
    init(frame: CGRect, tabs: [V2Tab]) {
        dataSource = tabs
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: frame.height, height: frame.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView = UICollectionView(frame: CGRect(origin: .zero, size: frame.size), collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(MainMenuItemCell.self, forCellWithReuseIdentifier: NSStringFromClass(MainMenuItemCell.self))
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        super.init(frame: frame)
        
        addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(MainMenuItemCell.self), for: indexPath) as! MainMenuItemCell
        let tab = dataSource[indexPath.row]
        cell.update(tab)
        return cell
    }
    
    func select(at index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
    }
}
