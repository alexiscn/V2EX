//
//  Utility.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/11/19.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import SafariServices

func presentSafariViewController(url: URL) {
    let controller = SFSafariViewController(url: url)
    controller.modalPresentationCapturesStatusBarAppearance = true
    controller.modalPresentationStyle = .overCurrentContext
    UIApplication.shared.keyWindow?.rootViewController?.present(controller, animated: true, completion: nil)
}
