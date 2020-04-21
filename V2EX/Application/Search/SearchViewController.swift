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
    private var headerView: SearchResultHeaderView?
    private var currentSort: SearchOptions.Sort = .sumup {
        didSet {
            if oldValue != currentSort {
                doSearch()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.current.backgroundColor
        configureNavigationBar()
        setupTableView()
        setupSearchTextField()
        setupCancelButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if dataSource.count == 0 {
            searchInputView.becomeFirstResponder()
        }
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupSearchTextField() {
        searchInputView = SearchInputTextView()
        searchInputView.layer.cornerRadius = 20.0
        searchInputView.delegate = self
        view.addSubview(searchInputView)
        
        searchInputView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
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
        tableView.keyboardDismissMode = .onDrag
        tableView.register(SearchViewCell.self, forCellReuseIdentifier: NSStringFromClass(SearchViewCell.self))
        view.addSubview(tableView)
        let resultHeader = SearchResultHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 30))
        tableView.tableHeaderView = resultHeader
        self.headerView = resultHeader
        self.headerView?.optionChangedHandler = { [weak self] sort in
            self?.currentSort = sort
        }
        tableView.mj_header = V2RefreshHeader { [weak self] in
            self?.doSearch()
        }
        tableView.mj_footer = V2RefreshFooter { [weak self] in
            self?.doSearch(isLoadMore: true)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(view.keyWindowSafeAreaInsets.top + 64)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc private func handleCancelButtonTapped(_ sender: Any) {
        searchInputView.resignFirstResponder()
        dismissHandler?()
    }
    
    private func doSearch(isLoadMore: Bool = false) {
        let keyword = searchInputView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        guard keyword.count > 0 else {
            tableView.mj_header?.endRefreshing()
            tableView.mj_footer?.endRefreshing()
            return
        }
        searchInputView.resignFirstResponder()
        let from = isLoadMore ? dataSource.count: 0
        var options = SearchOptions.default
        options.sort = currentSort
        V2SDK.search(key: keyword, from: from, options: options) { [weak self] response in
            if isLoadMore {
                self?.tableView.mj_footer?.endRefreshing()
            } else {
                self?.tableView.mj_header?.endRefreshing()
            }
            switch response {
            case .success(let searchRes):
                let text = String(format: Strings.SearchResultTips, searchRes.total, searchRes.took)
                self?.headerView?.updateText(text)
                if isLoadMore {
                    self?.dataSource.append(contentsOf: searchRes.hits)
                } else {
                    self?.dataSource = searchRes.hits
                }
                self?.tableView.reloadData()
            case .failure(let error):
                HUD.show(message: error.localizedDescription)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.current.statusBarStyle
    }

}

extension SearchViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            doSearch()
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
        cell.backgroundColor = .clear
        cell.update(result)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let result = dataSource[indexPath.row].source
        let url = URL(string: V2SDK.baseURLString.appending("/t/\(result.topicID)"))
        let detailVC = TopicDetailViewController(url: url, title: result.title)
        navigationController?.pushViewController(detailVC, animated:true)
    }
}
