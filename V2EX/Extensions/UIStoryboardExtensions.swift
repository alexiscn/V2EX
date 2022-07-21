//
//  UIStoryboardExtensions.swift
//  V2EX
//
//  Created by alexiscn on 2018/6/26.
//  Copyright © 2018 alexiscn. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    func instantiateViewController<T>(ofType type: T.Type) -> T {
        return instantiateViewController(withIdentifier: String(describing: type)) as! T
    }
}
