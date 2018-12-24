//
//  MessageTextView.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/12/24.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class MessageTextView: UITextView, UITextViewDelegate {
    
    override var delegate: UITextViewDelegate? {
        get { return self }
        set {}
    }
    
    override var text: String! {
        didSet {
            placeholderLabel.isHidden = !text.isEmpty
            NotificationCenter.default.post(name: UITextView.textDidChangeNotification, object: self)
        }
    }
    
    var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = placeholderLabel.bounds.size
        placeholderLabel.frame = CGRect(x: textContainerInset.left, y: textContainerInset.top, width: size.width, height: size.height)
    }
    
    private func commonInit() {
        font = UIFont.systemFont(ofSize: 15)
        textColor = Theme.current.titleColor
        
        allowsEditingTextAttributes = false
        isScrollEnabled = false
        backgroundColor = .clear
        textContainerInset = UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 12)
        returnKeyType = .send
        enablesReturnKeyAutomatically = true
        
        placeholderLabel.backgroundColor = .clear
    }
    
    func updatePlaceholderVisibility() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        updatePlaceholderVisibility()
    }
}
