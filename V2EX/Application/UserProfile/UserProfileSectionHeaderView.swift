//
//  UserProfileSectionHeaderView.swift
//  V2EX
//
//  Created by alexiscn on 2020/6/27.
//  Copyright © 2020 alexiscn. All rights reserved.
//

import UIKit

class UserProfileSectionHeaderView: UITableViewHeaderFooterView {

    class var identifier: String { return "UserProfileSectionHeaderView" }
    
    var viewAllButtonHandler: ((Int) -> Void)?
    
    private let titleLabel: UILabel
    
    private let viewAllButton: UIButton
    
    private var section: Int?
    
    override init(reuseIdentifier: String?) {
        
        titleLabel = UILabel()
        titleLabel.textColor = Theme.current.subTitleColor
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        viewAllButton = UIButton(type: .system)
        viewAllButton.setTitle(Strings.ProfileViewMore, for: .normal)
        viewAllButton.setTitleColor(Theme.current.titleColor, for: .normal)
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(viewAllButton)
        
        let background = UIView()
        background.backgroundColor = Theme.current.backgroundColor
        backgroundView = background
        
        configureConstraints()
        
        viewAllButton.addTarget(self, action: #selector(handleViewAllButtonTapped(_:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        viewAllButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewAllButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            viewAllButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
    }
    
    @objc private func handleViewAllButtonTapped(_ sender: UIButton) {
        guard let section = section else { return }
        viewAllButtonHandler?(section)
    }
    
    func update(title: String?, section: Int) {
        titleLabel.text = title
        self.section = section
    }
}
