//
//  SearchViewController.swift
//  V2EX
//
//  Created by xushuifeng on 2018/8/13.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import MJRefresh

class SearchViewController: UIViewController {

    var dismissHandler: RelayCommand?
    
    private var searchInputView: SearchInputTextView!
    private var cancelButton: UIButton!
    private var tableView: UITableView!
    private var dataSource: [SearchHit] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.current.backgroundColor
        setupSearchTextField()
        setupCancelButton()
        setupTableView()
        
        search()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchInputView.becomeFirstResponder()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupSearchTextField() {
        searchInputView = SearchInputTextView()
        searchInputView.delegate = self
        view.addSubview(searchInputView)
        
        searchInputView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(view.keyWindowSafeAreaInsets.top + 12)
            make.height.equalTo(40)
            make.trailing.equalToSuperview().offset(-70)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextViewDidChanged(_:)), name: UITextView.textDidChangeNotification, object: searchInputView)
    }
    
    @objc private func handleTextViewDidChanged(_ notification: Notification) {
        searchInputView.placeholderLabel.isHidden = !searchInputView.text.isEmpty
    }
    
    private func setupCancelButton() {
        cancelButton = UIButton(type: .system)
        cancelButton.setTitle(Strings.Cancel, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        cancelButton.setTitleColor(Theme.current.titleColor, for: .normal)
        
        view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchInputView)
            make.trailing.equalToSuperview()
            make.width.equalTo(70)
        }
        cancelButton.addTarget(self, action: #selector(handleCancelButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.register(SearchViewCell.self, forCellReuseIdentifier: NSStringFromClass(SearchViewCell.self))
        view.addSubview(tableView)
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            
        })
        header?.activityIndicatorViewStyle = Theme.current.activityIndicatorViewStyle
        header?.stateLabel.isHidden = true
        header?.stateLabel.textColor = Theme.current.subTitleColor
        header?.lastUpdatedTimeLabel.isHidden = true
        tableView.mj_header = header
        
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            
        })
        footer?.activityIndicatorViewStyle = Theme.current.activityIndicatorViewStyle
        footer?.isRefreshingTitleHidden = true
        footer?.triggerAutomaticallyRefreshPercent = 0.8
        footer?.stateLabel.textColor = Theme.current.subTitleColor
        footer?.stateLabel.isHidden = true
        tableView.mj_footer = footer
    }
    
    @objc private func handleCancelButtonTapped(_ sender: Any) {
        searchInputView.resignFirstResponder()
        dismissHandler?()
    }
    
    private func search() {
        V2SDK.search(key: "swift") { [weak self] response in
            switch response {
            case .success(let searchRes):
                self?.dataSource = searchRes.hits
                self?.tableView.reloadData()
                print("123")
            case .error(let error):
                HUD.show(message: error.localizedDescription)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension SearchViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            // do search staffs
            return false
        }
        return true
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(SearchViewCell.self), for: indexPath) as! SearchViewCell
        cell.update(result)
        return cell
    }
}
