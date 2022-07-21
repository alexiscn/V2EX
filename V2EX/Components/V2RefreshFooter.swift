//
//  V2RefreshFooter.swift
//  V2EX
//
//  Created by alexiscn on 2018/12/24.
//  Copyright © 2018 alexiscn. All rights reserved.
//

import UIKit
import MJRefresh

class V2RefreshFooter: MJRefreshAutoNormalFooter {
    
    override func prepare() {
        super.prepare()
        
        stateLabel?.isHidden = true
        stateLabel?.textColor = Theme.current.subTitleColor
        setTitle(Strings.NoMoreData, for: .noMoreData)
        isRefreshingTitleHidden = true
        triggerAutomaticallyRefreshPercent = 0.8
        loadingView?.style = Theme.current.activityIndicatorViewStyle
    }
}
