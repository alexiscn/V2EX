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

class CommentInputBar: UIView, UITextViewDelegate {
    
    weak var delegate: CommentInputBarDelegate?
    
    fileprivate lazy var cachedIntrinsicContentSize: CGSize = calculateIntrinsicContentSize()
    
    private var isOverMaxTextViewHeight = false
    
    override var intrinsicContentSize: CGSize {
        return cachedIntrinsicContentSize
    }
    
    var requiredInputTextViewHeight: CGFloat {
        let maxTextViewSize = CGSize(width: inputTextView.bounds.width, height: .greatestFiniteMagnitude)
        return inputTextView.sizeThatFits(maxTextViewSize).height.rounded(.down)
    }
    
    private var topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 238.0/255, green: 238.0/255, blue: 238.0/255, alpha: 1.0)
        return view
    }()
    
    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 251.0/255, green: 251.0/255, blue: 251.0/255, alpha: 1.0)
        return view
    }()
    
    var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    var inputTextView: CommentInputTextView = {
        let textView = CommentInputTextView()
        return textView
    }()
    
    var addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame.size = CGSize(width: 24, height: 24)
        button.setImage(UIImage(named: "add_photo"), for: .normal)
        button.tintColor = UIColor(red: 153.0/255, green: 153.0/255, blue: 153.0/255, alpha: 1.0)
        return button
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
        
        addSubview(backgroundView)
        addSubview(topLineView)
        addSubview(contentView)
        contentView.addSubview(inputTextView)
        contentView.addSubview(addPhotoButton)
        
        backgroundView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.trailing.equalToSuperview()
        }
        
        topLineView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        inputTextView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalTo(addPhotoButton.snp.leading).offset(-15.0)
        }
        
        addPhotoButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-15)
        }
        
        inputTextView.delegate = self
        
        addPhotoButton.addTarget(self, action: #selector(handleAddPhotoButtonTapped(_:)), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextViewDidChanged(_:)), name: UITextView.textDidChangeNotification, object: inputTextView)
    }
    
    override func invalidateIntrinsicContentSize() {
        super.invalidateIntrinsicContentSize()
        
        cachedIntrinsicContentSize = calculateIntrinsicContentSize()
    }
    
    func calculateIntrinsicContentSize() -> CGSize {
        var inputTextViewHeight = requiredInputTextViewHeight
        if inputTextViewHeight >= 180.0 {
            if !isOverMaxTextViewHeight {
                inputTextView.isScrollEnabled = true
                isOverMaxTextViewHeight = true
                inputTextView.layoutIfNeeded()
            }
            inputTextViewHeight = 180.0
        } else {
            if isOverMaxTextViewHeight {
                inputTextView.isScrollEnabled = false
                isOverMaxTextViewHeight = false
                inputTextView.invalidateIntrinsicContentSize()
            }
        }
        return CGSize(width: bounds.width, height: inputTextViewHeight)
    }
    
    @objc private func handleAddPhotoButtonTapped(_ sender: Any) {
        
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
