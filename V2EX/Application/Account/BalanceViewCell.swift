//
//  BalanceViewCell.swift
//  V2EX
//
//  Created by alexiscn on 2018/12/12.
//  Copyright © 2018 alexiscn. All rights reserved.
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
        descLabel.numberOfLines = 0
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
        
        configureConstraints()
        
        contentView.backgroundColor = Theme.current.cellBackgroundColor
        let backgroundView = UIView()
        backgroundView.backgroundColor = Theme.current.cellHighlightColor
        selectedBackgroundView = backgroundView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            amountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            amountLabel.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30)
        ])
        
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -80)
        ])
    }
    
    func update(_ model: DataType) {
        guard let balance = model as? Balance else { return }
        
        amountLabel.text = balance.value
        titleLabel.text = balance.title
        descLabel.text = balance.desc
        timeAgoLabel.text = balance.time
    }
    
    class func heightForBalance(_ balance: Balance) -> CGFloat {
        let width = UIScreen.main.bounds.width - 15 - 80
        var height: CGFloat = 35.0
        if let desc = balance.desc {
            let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
            let size = desc.boundingRectWithSize(maxSize, attributes: [.font: UIFont.systemFont(ofSize: 12)])
            height += size.height
        }
        height += 15.0
        return height
    }
}
