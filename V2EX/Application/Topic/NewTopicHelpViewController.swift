//
//  NewTopicHelpViewController.swift
//  V2EX
//
//  Created by xu.shuifeng on 2019/1/3.
//  Copyright © 2019 shuifeng.me. All rights reserved.
//

import UIKit

class NewTopicHelpViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var topicTitleLabel: UILabel!
    
    @IBOutlet weak var topicTitleDescLabel: UILabel!
    
    @IBOutlet weak var topicContentLabel: UILabel!
    
    @IBOutlet weak var topicContentDescLabel: UILabel!
    
    @IBOutlet weak var nodeLabel: UILabel!
    
    @IBOutlet weak var nodeDescLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        if Theme.current == .dark {
            backgroundView.backgroundColor = UIColor(red: 43.0/255, green: 57.0/255, blue: 83.0/255, alpha: 0.9)
        } else {
            backgroundView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        }
        
        
        topicTitleLabel.textColor = Theme.current.titleColor
        topicTitleDescLabel.textColor = Theme.current.subTitleColor
        
        topicContentLabel.textColor = Theme.current.titleColor
        topicContentDescLabel.textColor = Theme.current.subTitleColor
        
        nodeLabel.textColor = Theme.current.titleColor
        nodeDescLabel.textColor = Theme.current.subTitleColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
