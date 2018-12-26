//
//  MessageViewController.swift
//  Codes comes from: https://github.com/GitHawkApp/MessageViewController
//  V2EX
//
//  Created by xu.shuifeng on 2018/12/24.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

// handle keyboard
class MessageViewController: UIViewController {

    let inputBar = MessageInputBar()
    
    var scrollView: UIScrollView?
    var keyboardHeight: CGFloat = 0.0
    var keyboardState: KeyboardState = .resigned
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func layout() {
//        guard let scrollView = self.scrollView else { return }
//        
//        let bounds = view.bounds
//        
//        let inputBarHeight = inputBar.height + view.keyWindowSafeAreaInsets.bottom
    }
    
    func commonInit() {
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardDidHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: Notification) {
        
    }
    
    @objc func keyboardDidShow(notification: Notification) {
         keyboardState = .visible
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        let key = UIResponder.keyboardAnimationDurationUserInfoKey
        guard let animationDuration = notification.userInfo?[key] as? TimeInterval else { return }
        
        keyboardState = .hiding
        UIView.animate(withDuration: animationDuration) {
            self.layout()
        }
    }
    
    @objc func keyboardDidHide(notification: Notification) {
        keyboardState = .resigned
    }
    
}

enum KeyboardState {
    case visible
    case resigned
    case showing
    case hiding
}
