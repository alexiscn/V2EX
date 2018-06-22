//
//  V2SDK.swift
//  Pods
//
//  Created by xu.shuifeng on 2018/6/22.
//

import Foundation
import GenericNetworking

public class V2SDK {
    
    public class func setup() {
        GenericNetworking.baseURLString = "https://www.v2ex.com/"
    }
    
}
