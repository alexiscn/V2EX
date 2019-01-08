//
//  NewTopicNodesView.swift
//  V2EX
//
//  Created by xu.shuifeng on 2019/1/8.
//  Copyright © 2019 shuifeng.me. All rights reserved.
//

import UIKit

class NewTopicNode {
    let title: String
    let name: String
    var size: CGSize? = nil
    
    init(title: String, name: String) {
        self.title = title
        self.name = name
    }
}

class NewTopicNodesView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var allNodesHandler: RelayCommand?
    
    var nodeSelectionHandler: ((NewTopicNode) -> Void)?
    
    private let collectionView: UICollectionView
    
    private var dataSource: [NewTopicNode] = []
    
    override init(frame: CGRect) {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionViewFrame = CGRect(origin: .zero, size: frame.size)
        collectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        super.init(frame: frame)
        
        addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(NewTopicNodesViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(NewTopicNodesViewCell.self))
        setupDataSource()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDataSource() {
        dataSource.append(NewTopicNode(title: "全部节点", name: "all"))
        dataSource.append(NewTopicNode(title: "问与答", name: "qna"))
        dataSource.append(NewTopicNode(title: "酷工作", name: "jobs"))
        dataSource.append(NewTopicNode(title: "分享发现", name: "share"))
        dataSource.append(NewTopicNode(title: "程序员", name: "programmer"))
        dataSource.append(NewTopicNode(title: "macOS", name: "macos"))
        dataSource.append(NewTopicNode(title: "分享创造", name: "create"))
        dataSource.append(NewTopicNode(title: "Python", name: "python"))
        dataSource.append(NewTopicNode(title: "Apple", name: "apple"))
        dataSource.append(NewTopicNode(title: "Android", name: "android"))
        dataSource.append(NewTopicNode(title: "iPhone", name: "iphone"))
        dataSource.append(NewTopicNode(title: "宽带症候群", name: "bb"))
        dataSource.append(NewTopicNode(title: "职场话题", name: "career"))
        dataSource.append(NewTopicNode(title: "求职", name: "cv"))
        dataSource.append(NewTopicNode(title: "全球工单系统", name: "gts"))
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(NewTopicNodesViewCell.self), for: indexPath) as! NewTopicNodesViewCell
        let node = dataSource[indexPath.row]
        cell.update(node)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            allNodesHandler?()
        } else {
            let node = dataSource[indexPath.row]
            nodeSelectionHandler?(node)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let node = dataSource[indexPath.row]
        if let size = node.size {
            return size
        }
        let size = node.title.size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)])
        node.size = size
        return CGSize(width: size.width + 20, height: collectionView.bounds.height)
    }
}

fileprivate class NewTopicNodesViewCell: UICollectionViewCell {
    
    private let titleLabel: UILabel
    
    override init(frame: CGRect) {
        
        titleLabel = UILabel()
        titleLabel.textColor = Theme.current.titleColor
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        
        super.init(frame: frame)
        
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            titleLabel.alpha = isHighlighted ? 0.5: 1.0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ node: NewTopicNode) {
        titleLabel.text = node.title
    }
}
