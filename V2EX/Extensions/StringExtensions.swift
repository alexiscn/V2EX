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
    
    func size(withAttributes attributes: [NSAttributedString.Key: Any]) -> CGSize {
        let str = self as NSString
        return str.size(withAttributes: attributes)
    }
    
    func size(withFont font: UIFont) -> CGSize {
        let attributes: [NSAttributedString.Key: Any] = [.font: font as Any]
        return size(withAttributes: attributes)
    }
    
    func boundingRectWithSize(_ size: CGSize, attributes: [NSAttributedString.Key: Any]) -> CGRect {
        let str = self as NSString
        return str.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
    }
    
    var isLetter: Bool {
        return range(of: "[^a-zA-Z]", options: String.CompareOptions.regularExpression) == nil
    }
    
    func subString(start: Int, length: Int) -> String {
        let begin = self.index(startIndex, offsetBy: start)
        let end = self.index(begin, offsetBy: length)
        return String(self[begin..<end])
    }
}
