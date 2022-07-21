//
//  MyNodesViewCell.swift
//  V2EX
//
//  Created by alexiscn on 2018/12/22.
//  Copyright © 2018 alexiscn. All rights reserved.
//

import UIKit

class MyNodesViewCell: UITableViewCell, ListViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        textLabel?.textColor = Theme.current.titleColor
        detailTextLabel?.textColor = Theme.current.subTitleColor
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = Theme.current.cellHighlightColor
        selectedBackgroundView = backgroundView
        
        contentView.backgroundColor = Theme.current.cellBackgroundColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame = CGRect(x: 15, y: 10, width: 40, height: 40)
        if let f = textLabel?.frame {
            textLabel?.frame = f.insetBy(dx: -20, dy: 0)
        }
        if let f = detailTextLabel?.frame {
            detailTextLabel?.frame = f.insetBy(dx: -20, dy: 0)
        }
    }
    
    func update(_ model: DataType) {
        guard let myNode = model as? MyNode else { return }
        imageView?.kf.setImage(with: myNode.logoURL, placeholder: nil, options: nil, progressBlock: nil) { [weak self] _ in
            self?.setNeedsLayout()
        }
        textLabel?.text = myNode.title
        detailTextLabel?.text = "共有\(myNode.count)个主题"
    }
}
