//
//  NewTopicTextView.swift
//  V2EX
//
//  Created by xu.shuifeng on 2019/1/8.
//  Copyright © 2019 shuifeng.me. All rights reserved.
//

import UIKit

class NewTopicTextView: UITextView {
    
    override var text: String! {
        didSet {
            placeholderLabel.isHidden = !text.isEmpty
            NotificationCenter.default.post(name: UITextView.textDidChangeNotification, object: self)
        }
    }
    
    var placeholderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = Theme.current.subTitleColor
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = Strings.TopicBodyPlaceholder
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
        font = UIFont.systemFont(ofSize: 14)
        
        backgroundColor = .clear
        textContainerInset = UIEdgeInsets(top: 14, left: 9, bottom: 14, right: 10)
        textColor = Theme.current.titleColor
        addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.width.equalToSuperview().offset(-24)
            make.top.equalToSuperview().offset(14)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextViewDidChanged(_:)), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    @objc private func handleTextViewDidChanged(_ notification: Notification) {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    func updatePlaceholder(_ text: String) {
        placeholderLabel.text = text
    }
}
