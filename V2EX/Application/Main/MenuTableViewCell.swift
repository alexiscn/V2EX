//
//  MenuTableViewCell.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/11/9.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    let lineView: UIView
    
    let titleLabel: UILabel
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        titleLabel = UILabel()
        titleLabel.textColor = Theme.current.titleColor
        lineView = UIView(frame: .zero)
        lineView.backgroundColor = .red
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(lineView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        lineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lineView.widthAnchor.constraint(equalToConstant: 3),
            lineView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            lineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        lineView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        lineView.isHidden = !selected
        
        if isSelected {
            contentView.backgroundColor = Theme.current.cellBackgroundColor
        } else {
            contentView.backgroundColor = Theme.current.backgroundColor
        }
    }

    public func updateMenu(_ menu: V2Tab) {
        titleLabel.text = menu.title
    }
    
    func updateTheme() {
        titleLabel.textColor = Theme.current.titleColor
        if isSelected {
            contentView.backgroundColor = Theme.current.cellBackgroundColor
        } else {
            contentView.backgroundColor = Theme.current.backgroundColor
        }
    }
}
