//
//  ActionSheet.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/11/16.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

typealias ActionSheetHandler = (_ action: Action?) -> Void

enum ActionStyle {
    case `default`, cancel, destructive
}

class Action {
    let handler: ActionSheetHandler?
    let title: String
    let style: ActionStyle
    init(title: String, style: ActionStyle = .default, handler: ActionSheetHandler? = nil) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}

class ActionSheet: UIView {
    
    private var actions: [Action] = []
    private let backgroundView: UIView
    private let containerView: UIView
    
    public func addAction(_ action: Action) {
        actions.append(action)
    }
    
    public init(title: String? = nil) {
        backgroundView = UIView()
        containerView = UIView()
        super.init(frame: CGRect.zero)
        
        addSubview(backgroundView)
        addSubview(containerView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: backgroundView)
        if !containerView.frame.contains(point) {
            hide()
        }
    }
    
    public func showInView(_ view: UIView) {
        
        frame = view.bounds
        
        buildUI(parentView: view)
        
        view.addSubview(self)
        
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 1.0
            let y = view.frame.height - self.containerView.frame.height
            self.containerView.frame.origin = CGPoint(x: 0.0, y: y)
        }
    }
    
    private func buildUI(parentView: UIView) {
        
        isUserInteractionEnabled = true
        backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        backgroundView.frame = parentView.bounds
        backgroundView.alpha = 0
        containerView.backgroundColor = UIColor(white: 1, alpha: 0.8)
        
        var y: CGFloat = 0.0
        for (index, action) in actions.enumerated() {
            let actionButton = UIButton(type: .system)
            actionButton.tag = index
            actionButton.addTarget(self, action: #selector(handleActionButtonTapped(_:)), for: .touchUpInside)
            actionButton.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            actionButton.setTitle(action.title, for: .normal)
            actionButton.setTitleColor(UIColor.white, for: .normal)
            if action.style == .cancel {
                actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            } else {
                actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            }
            containerView.addSubview(actionButton)
            
            if action.style == .cancel {
                y += 10.0
            }
            actionButton.frame = CGRect(x: 0, y: y, width: parentView.frame.width, height: 50)
            
            y += actionButton.frame.height
        }
//        if UserInterfaceConstants.isXScreenLayout {
//            let holderView = UIView(frame: CGRect(x: 0, y: y, width: parentView.frame.width, height: keyWindowSafeAreaInsets.bottom))
//            holderView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
//            containerView.addSubview(holderView)
//
//            y += keyWindowSafeAreaInsets.bottom
//        }
        
        containerView.frame = CGRect(x: 0.0, y: parentView.frame.height, width: parentView.frame.width, height: y)
        
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        effectView.frame = containerView.bounds
        containerView.addSubview(effectView)
        containerView.sendSubviewToBack(effectView)
    }
    
    @objc private func handleActionButtonTapped(_ sender: UIButton) {
        let action = actions[sender.tag]
        action.handler?(action)
        hide()
    }
    
    public func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.alpha = 0
            let y = self.superview?.frame.height ?? UIScreen.main.bounds.height
            self.containerView.frame.origin = CGPoint(x: 0.0, y: y)
        }) { _ in
            self.removeFromSuperview()
        }
    }
}
