//
//  NodeListViewController.swift
//  V2EX
//
//  Created by xushuifeng on 2018/8/14.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import V2SDK

class NodeListViewController: UIViewController {

    fileprivate var collectionView: UICollectionView!
    
    fileprivate var dataSource: [V2NodeGroup] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NodeListViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(NodeListViewCell.self))
        view.addSubview(collectionView)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension NodeListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let group = dataSource[section]
        return group.nodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(NodeListViewCell.self), for: indexPath) as! NodeListViewCell
        return cell
    }
    
}
