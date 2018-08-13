//
//  MainMenuItemCell.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/8/13.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import V2SDK

class MainMenuItemCell: UICollectionViewCell {
    
    let titleButton: UIButton
    
    override var isSelected: Bool {
        didSet {
            
            if isSelected {
                UIView.animate(withDuration: 0.1) {
                    self.titleButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
                }
            } else {
                UIView.animate(withDuration: 0.1) {
                    self.titleButton.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        
        titleButton = UIButton(type: .system)
        titleButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        titleButton.setTitleColor(.black, for: .normal)
        titleButton.isUserInteractionEnabled = false
        
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
