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
}


class MainMenuItemCell: UICollectionViewCell {
    
    let titleButton: UIButton
    
    override var isSelected: Bool {
        didSet {
            titleButton.isSelected = isSelected
        }
    }
    
    override init(frame: CGRect) {
        
        titleButton = UIButton(type: .system)
        titleButton.setBackgroundImage(UIColor.black.toImage(), for: .selected)
        titleButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        titleButton.setTitleColor(.black, for: .normal)
        titleButton.setTitleColor(.white, for: .selected)
        
        super.init(frame: frame)
        
        contentView.addSubview(titleButton)
        
        titleButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.width.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ tab: V2Tab) {
        titleButton.setTitle(tab.title, for: .normal)
    }
}

extension UIColor {
    
    func toImage()-> UIImage? {
        let size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        self.setFill()
        UIRectFill(CGRect(origin: CGPoint.zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}
