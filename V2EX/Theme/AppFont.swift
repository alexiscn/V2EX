//
//  AppFont.swift
//  V2EX
//
//  Created by alexiscn on 2018/11/29.
//  Copyright © 2018 alexiscn. All rights reserved.
//

import UIKit

protocol AppFont {
    
    var titleFont: UIFont { get }
    
    var subTitleFont: UIFont { get }
}

class NormalFonts: AppFont {
    
    var titleFont: UIFont = UIFont.systemFont(ofSize: 15.0)
    
    var subTitleFont: UIFont = UIFont.systemFont(ofSize: 12.0)
    
    
}
