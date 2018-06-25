//
//  HomeMenuViewController.swift
//  V2EX
//
//  Created by xushuifeng on 2018/6/26.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit


class HomeMenuViewController: UIViewController {

    fileprivate var themeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupFooterView()
    }
    
    fileprivate func setupFooterView() {
        let footerView = UIView()
        view.addSubview(footerView)
        footerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(80)
            make.bottom.equalToSuperview().offset(-view.safeAreaInsets.bottom)
        }
        
        themeButton = UIButton(type: .custom)
        footerView.addSubview(themeButton)
        themeButton.setImage(UIImage(named: "icon_light"), for: .normal)
        themeButton.setImage(UIImage(named: "icon_dark"), for: .selected)
        themeButton.snp.makeConstraints { make in
            make.height.width.equalTo(32)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
