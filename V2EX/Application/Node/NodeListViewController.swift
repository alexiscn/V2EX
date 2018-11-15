//
//  NodeListViewController.swift
//  V2EX
//
//  Created by xushuifeng on 2018/8/14.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class NodeListViewController: UIViewController {

    fileprivate var collectionView: UICollectionView!
    
    fileprivate var dataSource: [V2NodeGroup] = []
    
    fileprivate var cachedSize: [IndexPath: CGSize] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 6
        layout.minimumInteritemSpacing = 10
        layout.estimatedItemSize = CGSize(width: 100, height: 30)
        layout.scrollDirection = .vertical
        layout.headerReferenceSize = CGSize(width: view.bounds.width, height: 30)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NodeListViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(NodeListViewCell.self))
        collectionView.register(NodeListSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(NodeListSectionHeaderView.self))
        view.addSubview(collectionView)
        // Do any additional setup after loading the view.
        
        if V2DataManager.shared.nodeGroups.count == 0 {
            
        } else {
            dataSource = V2DataManager.shared.nodeGroups
            collectionView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension NodeListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let group = dataSource[section]
        return group.nodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(NodeListViewCell.self), for: indexPath) as! NodeListViewCell
        let group = dataSource[indexPath.section]
        let node = group.nodes[indexPath.row]
        cell.update(node)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NSStringFromClass(NodeListSectionHeaderView.self), for: indexPath) as! NodeListSectionHeaderView
            let group = dataSource[indexPath.section]
            headerView.update(group.title)
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let group = dataSource[indexPath.section]
        let node = group.nodes[indexPath.row]        
        if let size = cachedSize[indexPath] {
            return size
        }
    
        let size = (node.title as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: 16)])
        cachedSize[indexPath] = size
        return size
    }
}
