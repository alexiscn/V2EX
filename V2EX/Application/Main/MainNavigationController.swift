//
//  MainNavigationController.swift
//  V2EX
//
//  Created by xushuifeng on 2018/12/9.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.current.statusBarStyle
    }
}
