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
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        optionView.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.width.equalTo(120)
        }
        
        sumupButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.equalTo(59)
            make.top.bottom.equalToSuperview()
        }
        
        separator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(2)
        }
        
        createdTimeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.width.equalTo(59)
            make.top.bottom.equalToSuperview()
        }
        
        sumupButton.addTarget(self, action: #selector(handleOptionButtonTapped(_:)), for: .touchUpInside)
        createdTimeButton.addTarget(self, action: #selector(handleOptionButtonTapped(_:)), for: .touchUpInside)
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
