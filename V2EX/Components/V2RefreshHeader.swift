//
//  V2RefreshHeader.swift
//  V2EX
//
//  Created by alexiscn on 2018/12/24.
//  Copyright © 2018 alexiscn. All rights reserved.
//

import UIKit
import MJRefresh

class V2RefreshHeader: MJRefreshNormalHeader {
    
    override func prepare() {
        super.prepare()
        loadingView?.style = Theme.current.activityIndicatorViewStyle
        stateLabel?.isHidden = true
        stateLabel?.textColor = Theme.current.subTitleColor
        lastUpdatedTimeLabel?.isHidden = true
    }
}
