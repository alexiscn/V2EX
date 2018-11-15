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
        titleLabel.textColor = UIColor(white: 240.0/255, alpha: 1.0)
        lineView = UIView(frame: .zero)
        lineView.backgroundColor = .red
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(3)
            make.height.equalTo(44)
        }
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
    }

    public func updateMenu(_ menu: V2Tab) {
        
        titleLabel.text = menu.title
        
    }
}
