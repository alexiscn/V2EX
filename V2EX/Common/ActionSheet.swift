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

class ActionSheet: UIView, UIGestureRecognizerDelegate {
    
    public var durationOfDismiss: TimeInterval = 0.3
    
    private var actions: [Action] = []
    lazy var backgroundView: UIView = {
        let bg = UIView()
        return bg
    }()
    private var containerView: UIView = {
        let container = UIView()
        return container
    }()
    
    
    public func addAction(_ action: Action) {
        actions.append(action)
    }
    
    public init(title: String?, message: String?) {
        
        let frame = UIScreen.main.bounds
        
        super.init(frame: frame)

        addSubview(backgroundView)
        addSubview(containerView)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        tapGesture.delegate = self
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
    
    public func show() {
        buildUI()
        UIView.animate(withDuration: 0.1, animations: {
            UIApplication.shared.keyWindow?.addSubview(self)
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.backgroundView.alpha = 1.0
                let y = self.frame.height - self.containerView.frame.height
                self.containerView.frame.origin = CGPoint(x: 0.0, y: y)
            }
        }
    }
    
    private func buildUI() {
        
        backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        backgroundView.frame = bounds
        backgroundView.alpha = 0
        containerView.backgroundColor = Theme.current.backgroundColor
        
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
                y += 8.0
            } else {
                y += 0.5
            }
            
            var height: CGFloat = 50.0
            if index == actions.count - 1 {
                height = 50.0 + keyWindowSafeAreaInsets.bottom
                actionButton.titleEdgeInsets = UIEdgeInsets(top: -keyWindowSafeAreaInsets.bottom/2.0, left: 0, bottom: 0, right: 0)
            }
            
            actionButton.frame = CGRect(x: 0, y: y, width: frame.width, height: height)
            
            y += actionButton.frame.height
        }
        
        containerView.frame = CGRect(x: 0.0, y: frame.height, width: frame.width, height: y)
        
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
        UIView.animate(withDuration: durationOfDismiss, animations: {
            self.backgroundView.alpha = 0
            let y = UIScreen.main.bounds.height
            self.containerView.frame.origin = CGPoint(x: 0.0, y: y)
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view == self.containerView {
            return false
        }
        return true
    }

    var isPhoneX: Bool {
        if UIDevice.current.userInterfaceIdiom != .phone {
            return false
        }
        if let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom, bottom > 0 {
            return true
        }
        return false
    }
}
