//
//  BalanceViewCell.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/12/12.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class BalanceViewCell: UITableViewCell, ListViewCell {
    
    private let amountLabel: UILabel
    
    private let titleLabel: UILabel
    
    private let descLabel: UILabel
    
    private let timeAgoLabel: UILabel
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        amountLabel = UILabel()
        amountLabel.textAlignment = .center
        amountLabel.textColor = Theme.current.titleColor
        amountLabel.font = UIFont.systemFont(ofSize: 22)
        
        titleLabel = UILabel()
        titleLabel.textColor = Theme.current.titleColor
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        
        descLabel = UILabel()
        descLabel.textColor = Theme.current.subTitleColor
        descLabel.font = UIFont.systemFont(ofSize: 12)
        
        timeAgoLabel = UILabel()
        timeAgoLabel.textColor = Theme.current.subTitleColor
        timeAgoLabel.font = UIFont.systemFont(ofSize: 11)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(amountLabel)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(descLabel)
        contentView.addSubview(timeAgoLabel)
        
        amountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview()
        }

        descLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.trailing.equalToSuperview()
        }
        contentView.backgroundColor = Theme.current.cellBackgroundColor
        let backgroundView = UIView()
        backgroundView.backgroundColor = Theme.current.cellHighlightColor
        selectedBackgroundView = backgroundView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ model: DataType) {
        guard let balance = model as? Balance else { return }
        
        amountLabel.text = balance.value
        titleLabel.text = balance.title
        descLabel.text = balance.desc
        timeAgoLabel.text = balance.time
    }
}
