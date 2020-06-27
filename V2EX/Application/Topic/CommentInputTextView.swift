//
//  CommentInputTextView.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/12/17.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class CommentInputTextView: UITextView {
    
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
        label.text = Strings.DetailCreateNewReply
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
        backgroundColor = .clear
        textContainerInset = UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 12)
        returnKeyType = .send
        enablesReturnKeyAutomatically = true
        textColor = Theme.current.titleColor
        
        addSubview(placeholderLabel)
        
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            placeholderLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func updatePlaceholder(_ text: String) {
        placeholderLabel.text = text
    }
}
