//
//  CommentInputBar.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/12/17.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

protocol CommentInputBarDelegate: class {
    func inputBar(_ inputBar: CommentInputBar, didSendText text: String)
    func inputBarDidPressedPhotoButton()
}

class CommentInputBar: UIView, UITextFieldDelegate {
    weak var delegate: CommentInputBarDelegate?
    
    var requiredInputTextViewHeight: CGFloat {
        let maxTextViewSize = CGSize(width: inputTextView.bounds.width, height: .greatestFiniteMagnitude)
        return inputTextView.sizeThatFits(maxTextViewSize).height.rounded(.down)
    }
    
    var inputTextView: CommentInputTextView = {
        let textView = CommentInputTextView()
        return textView
    }()
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        autoresizingMask = [.flexibleHeight]
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextViewDidChanged(_:)), name: UITextView.textDidChangeNotification, object: inputTextView)
    }
    
    @objc private func handleTextViewDidChanged(_ notification: Notification) {
        inputTextView.placeholderLabel.isHidden = !inputTextView.text.isEmpty
        
        let shouldInvalidateIntrinsicContentSize = requiredInputTextViewHeight != inputTextView.bounds.height
        if shouldInvalidateIntrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            delegate?.inputBar(self, didSendText: textView.text)
            return false
        }
        return true
    }
}
