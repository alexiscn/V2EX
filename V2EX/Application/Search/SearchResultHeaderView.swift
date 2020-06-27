//
//  SearchResultHeaderView.swift
//  V2EX
//
//  Created by xushuifeng on 2018/12/19.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class SearchResultHeaderView: UIView {
    
    var optionChangedHandler: ((SearchOptions.Sort) -> Void)?
    
    private let titleLabel: UILabel
    
    private var optionView: UIView
    
    private let sumupButton: UIButton
    
    private let separator: UIView
    
    private let createdTimeButton: UIButton
    
    private var currentTag: Int = 0
    
    override init(frame: CGRect) {
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.textColor = Theme.current.titleColor
        
        optionView = UIView()
        
        sumupButton = UIButton(type: .system)
        sumupButton.tag = 0
        sumupButton.tintColor = .clear
        sumupButton.isSelected = true
        sumupButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        sumupButton.setTitle(Strings.SearchOptionsSumup, for: .normal)
        sumupButton.setTitleColor(Theme.current.subTitleColor, for: .normal)
        sumupButton.setTitleColor(Theme.current.titleColor, for: .selected)
        
        separator = UIView()
        separator.backgroundColor = Theme.current.subTitleColor
        
        createdTimeButton = UIButton(type: .system)
        createdTimeButton.tag = 1
        createdTimeButton.tintColor = .clear
        createdTimeButton.backgroundColor = .clear
        createdTimeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        createdTimeButton.setTitle(Strings.SearchOptionCreatedTime, for: .normal)
        createdTimeButton.setTitleColor(Theme.current.subTitleColor, for: .normal)
        createdTimeButton.setTitleColor(Theme.current.titleColor, for: .selected)
        
        super.init(frame: frame)
        
        addSubview(titleLabel)
        addSubview(optionView)
        
        optionView.addSubview(sumupButton)
        optionView.addSubview(separator)
        optionView.addSubview(createdTimeButton)
        
        configureConstraints()
        
        sumupButton.addTarget(self, action: #selector(handleOptionButtonTapped(_:)), for: .touchUpInside)
        createdTimeButton.addTarget(self, action: #selector(handleOptionButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func configureConstraints() {
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        optionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            optionView.topAnchor.constraint(equalTo: self.topAnchor),
            optionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            optionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            optionView.widthAnchor.constraint(equalToConstant: 120)
        ])
        
        sumupButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sumupButton.leadingAnchor.constraint(equalTo: optionView.leadingAnchor),
            sumupButton.topAnchor.constraint(equalTo: optionView.topAnchor),
            sumupButton.bottomAnchor.constraint(equalTo: optionView.bottomAnchor),
            sumupButton.widthAnchor.constraint(equalToConstant: 59)
        ])
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separator.centerXAnchor.constraint(equalTo: optionView.centerXAnchor),
            separator.centerYAnchor.constraint(equalTo: optionView.centerYAnchor),
            separator.widthAnchor.constraint(equalToConstant: 2),
            separator.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        createdTimeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            createdTimeButton.trailingAnchor.constraint(equalTo: optionView.trailingAnchor),
            createdTimeButton.topAnchor.constraint(equalTo: optionView.topAnchor),
            createdTimeButton.bottomAnchor.constraint(equalTo: optionView.bottomAnchor),
            createdTimeButton.widthAnchor.constraint(equalToConstant: 59)
        ])
    }
    
    @objc private func handleOptionButtonTapped(_ sender: UIButton) {
        
        if sender.tag == currentTag {
            return
        }
        currentTag = sender.tag
        if sender.tag == 0 {
            sumupButton.isSelected = true
            createdTimeButton.isSelected = false
        } else {
            sumupButton.isSelected = false
            createdTimeButton.isSelected = true
        }
        
        let sort: SearchOptions.Sort = sender.tag == 0 ? .sumup: .created
        optionChangedHandler?(sort)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateText(_ text: String) {
        titleLabel.text = text
    }
}
