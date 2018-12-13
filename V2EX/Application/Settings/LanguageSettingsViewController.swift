//
//  LanguageSettingsViewController.swift
//  V2EX
//
//  Created by xushuifeng on 2018/12/12.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class LanguageSettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var tableView: UITableView!
    
    private var dataSource: [Language] = []
    
    private var currentLang: Language = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = Theme.current.backgroundColor
        title = Strings.SettingsLanguage
        setupNavigationBar()
        setupTableView()
        currentLang = LanguageManager.shared.currentLanguage
        dataSource = LanguageManager.shared.supporttedLanguages()
    }
    
    private func setupNavigationBar() {
        configureNavigationBar()
        
//        let leftItem = UIBarButtonItem(title: Strings.Cancel, style: .plain, target: self, action: #selector(leftNavigationButtonTapped(_:)))
        let rightItem = UIBarButtonItem(title: Strings.Done, style: .done, target: self, action: #selector(rightNavigationButtonTapped(_:)))
        
//        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc private func leftNavigationButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func rightNavigationButtonTapped(_ sender: Any) {
        LanguageManager.shared.currentLanguage = currentLang
        // 稍微有些山寨的做法，由于：SideMenu Warning: menuLeftNavigationController cannot be modified while it's presented
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dismiss(animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let controller = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                appDelegate.window?.rootViewController = controller
            }
        }
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.separatorColor = Theme.current.backgroundColor
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = Theme.current.titleColor
        let lang = dataSource[indexPath.row]
        cell.textLabel?.text = lang.title
        cell.accessoryType = lang == currentLang ? .checkmark: .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        currentLang = dataSource[indexPath.row]
        tableView.reloadData()
    }
}
