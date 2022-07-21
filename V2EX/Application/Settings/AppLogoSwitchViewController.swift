//
//  AppLogoSwitchViewController.swift
//  V2EX
//
//  Created by alexiscn on 2018/12/29.
//  Copyright © 2018 alexiscn. All rights reserved.
//

import UIKit

fileprivate struct AppLogo {
    let icon: String
    let key: String?
    
    static func logos() -> [AppLogo] {
        var list: [AppLogo] = []
        list.append(AppLogo(icon: "Logo_Default", key: nil))
        list.append(AppLogo(icon: "Logo_White", key: "AppLogo_White"))
        list.append(AppLogo(icon: "Logo_Fast", key: "AppLogo_Fast"))
        list.append(AppLogo(icon: "Logo_Hacker", key: "AppLogo_Hacker"))
        list.append(AppLogo(icon: "Logo_HackGreen", key: "AppLogo_HackGreen"))
        return list
    }
}

class AppLogoSwitchViewController: UIViewController {

    private var collectionView: UICollectionView!
    
    private let dataSource: [AppLogo] = AppLogo.logos()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = Strings.SettingsAppLogo
        view.backgroundColor = Theme.current.backgroundColor
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let itemWidth = CGFloat(floorf(Float(view.bounds.width/4.0)))
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AppLogoViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(AppLogoViewCell.self))
        view.addSubview(collectionView)
    }
}

extension AppLogoSwitchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(AppLogoViewCell.self), for: indexPath) as! AppLogoViewCell
        let name = dataSource[indexPath.row].icon
        cell.imageView.image = UIImage(named: name)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        
        if UIApplication.shared.supportsAlternateIcons {
            let logo = dataSource[indexPath.row]
            UIApplication.shared.setAlternateIconName(logo.key, completionHandler: nil)
        }
    }
}

class AppLogoViewCell: UICollectionViewCell {
    
    let imageView: UIImageView
    
    override init(frame: CGRect) {
        
        imageView = UIImageView()
        
        super.init(frame: frame)
        
        self.clipsToBounds = true
        contentView.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
