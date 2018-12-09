//
//  AboutViewController.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/12/7.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("关于", comment: "")
        
        view.backgroundColor = Theme.current.backgroundColor
        textView.textColor = Theme.current.titleColor
        
    }
}
