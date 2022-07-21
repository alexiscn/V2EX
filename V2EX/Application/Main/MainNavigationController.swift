//
//  MainNavigationController.swift
//  V2EX
//
//  Created by alexiscn on 2018/12/9.
//  Copyright © 2018 alexiscn. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.current.statusBarStyle
    }
}
