//
//  CommentInputBar.swift
//  V2EX
//
//  Created by alexiscn on 2018/12/17.
//  Copyright © 2018 alexiscn. All rights reserved.
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
        view.backgroundColor = Theme.current.backgroundColor
        return view
    }()
    
    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.current.cellBackgroundColor
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
        button.tintColor = Theme.current.subTitleColor
        return button
    }()
    
    var loginRequiredButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle(Strings.LoginRequired, for: .normal)
        button.tintColor = Theme.current.subTitleColor
        button.contentHorizontalAlignment = .left
        button.backgroundColor = Theme.current.cellBackgroundColor
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
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
        addSubview(loginRequiredButton)
        contentView.addSubview(inputTextView)
        contentView.addSubview(addPhotoButton)
        
        configureConstraints()
        
        loginRequiredButton.isHidden = AppContext.current.isLogined
        
        inputTextView.delegate = self
        
        addPhotoButton.addTarget(self, action: #selector(handleAddPhotoButtonTapped(_:)), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextViewDidChanged(_:)), name: UITextView.textDidChangeNotification, object: inputTextView)
    }
    
    private func configureConstraints() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
        loginRequiredButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginRequiredButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            loginRequiredButton.topAnchor.constraint(equalTo: self.topAnchor),
            loginRequiredButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            loginRequiredButton.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        topLineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topLineView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            topLineView.topAnchor.constraint(equalTo: self.topAnchor),
            topLineView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            topLineView.heightAnchor.constraint(equalToConstant: LineHeight)
        ])
        
        inputTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inputTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            inputTextView.topAnchor.constraint(equalTo: contentView.topAnchor),
            inputTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            inputTextView.trailingAnchor.constraint(equalTo: addPhotoButton.leadingAnchor, constant: -15)
        ])
        
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addPhotoButton.widthAnchor.constraint(equalToConstant: 24),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 24),
            addPhotoButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            addPhotoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
        
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
        delegate?.inputBarDidPressedPhotoButton()
    }
    
    @objc private func handleTextViewDidChanged(_ notification: Notification) {
        inputTextView.placeholderLabel.isHidden = !inputTextView.text.isEmpty
        
        let shouldInvalidateIntrinsicContentSize = requiredInputTextViewHeight != inputTextView.bounds.height
        if shouldInvalidateIntrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }
    
    func appendMention(text: String) {
        inputTextView.text.append(text)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            delegate?.inputBar(self, didSendText: textView.text)
            return false
        }
        return true
    }
}
