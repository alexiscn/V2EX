//
//  MessageInputBar.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/12/24.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class MessageInputBar: UIView {
    
    let textView = MessageTextView()
    
    let topBorderLayer = CALayer()
    
    var maxNumberOfLines: Int = 4
    
    var height: CGFloat {
        return 0.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textView)
        
        textView.contentInset = .zero
        textView.textContainerInset = .zero
        textView.backgroundColor = .clear
        
        textView.textContainer.exclusionPaths = []
        textView.textContainer.maximumNumberOfLines = 0
        textView.textContainer.lineFragmentPadding = 0
        textView.layoutManager.allowsNonContiguousLayout = false
        textView.layoutManager.hyphenationFactor = 0
        textView.layoutManager.showsInvisibleCharacters = false
        textView.layoutManager.showsControlCharacters = false
        textView.layoutManager.usesFontLeading = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        topBorderLayer.frame = CGRect(x: bounds.minX, y: bounds.minY, width: bounds.width, height: 1/UIScreen.main.scale)
    }
    
}
