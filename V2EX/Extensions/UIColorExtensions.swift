//
//  UIColorExtensions.swift
//  V2EX
//
//  Created by alexiscn on 2018/8/13.
//  Copyright © 2018 alexiscn. All rights reserved.
//

import UIKit

extension UIColor {
    
    func toImage()-> UIImage? {
        let size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        self.setFill()
        UIRectFill(CGRect(origin: CGPoint.zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}
