//
//  StringExtensions.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/6/25.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func size(withAttributes attributes: [NSAttributedStringKey: Any]) -> CGSize {
        let str = self as NSString
        return str.size(withAttributes: attributes)
    }
    
    func size(withFont font: UIFont) -> CGSize {
        let attributes: [NSAttributedStringKey: Any] = [.font: font as Any]
        return size(withAttributes: attributes)
    }
    
}
