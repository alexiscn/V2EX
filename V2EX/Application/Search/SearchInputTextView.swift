//
//  SearchInputTextView.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/12/19.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class SearchInputTextView: UITextView {
    
    override var text: String! {
        didSet {
            placeholderLabel.isHidden = !text.isEmpty
            NotificationCenter.default.post(name: UITextView.textDidChangeNotification, object: self)
        }
    }
    
    var placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.current.subTitleColor
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = Strings.SearchPlaceholder
        return label
    }()
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        font = UIFont.systemFont(ofSize: 15)
        
        allowsEditingTextAttributes = false
        isScrollEnabled = false
        backgroundColor = Theme.current.cellBackgroundColor
        textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 13, right: 12)
        returnKeyType = .search
        enablesReturnKeyAutomatically = true
        textColor = Theme.current.titleColor
        
        addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
    }
    
    func updatePlaceholder(_ text: String) {
        placeholderLabel.text = text
    }
}
