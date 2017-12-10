//
//  UserItemViewController.swift
//  QiitaKitForSample
//
//  Created by 須藤将史 on 2017/11/14.
//  Copyright © 2017年 須藤将史. All rights reserved.
//

import UIKit
import QiitaKit
import SafariServices

final class UserItemsViewController: UIViewController {

    private let tableView: UITableView
    
    private let refreshControl = UIRefreshControl()
    private var isFetching = false {
        didSet {
            DispatchQueue.main.async {
                self.navigationItem.prompt = "\(self.items.count) / \(self.totalCount)"
                self.tableView.reloadData()
            }
        }
    }
    private let user: User
    private var page: Int = 0
    private var totalCount: Int = 0
    private var items: [Item]
    private var cellHeightList: [IndexPath: CGFloat] = [:]

    init(user: User) {
        self.user = user
        self.items = []
        self.tableView = UITableView(frame: .zero, style: .plain)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - API
    
    private func fetch(isPaging: Bool, completion: @escaping () -> Void) {
        if isFetching { return }
        if totalCount > 0 && totalCount == items.count {
            completion()
            return
        }
        
        isFetching = true
        page = isPaging ? page + 1 : page
        let request = UserItemRequest(page: page, perPage: 20, userId: user.id)
        ApiSession.shared.send(request, completion: { [weak self] in
            switch $0 {
            case .success(let response):
                self?.totalCount = response.totalCount
                if let me = self, isPaging || me.items.count < response.values.count * me.page {
                    me.items.append(contentsOf: response.values)
                }
            case .failure(let error):
                print("QiitaKit:[Error] -> ", error)
            }
            self?.isFetching = false
            completion()
        })
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = user.id + "の投稿一覧"
        navigationItem.prompt = "\(items.count) / \(totalCount)"

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.registerCell(ItemCell.self)
        tableView.registerHeaderFooterView(LoadingFooterView.self)
        view.addSubview(tableView)
        tableView.setupConstraint(parentView: view)
        
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }

        fetch(isPaging: true, completion: {})
    }
    
    // MARK: - Transition
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.cellHeightList = [:]
    }
    
    // MARK: - UIRefreshControl
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        fetch(isPaging: false, completion: {
            DispatchQueue.main.async {
                sender.endRefreshing()
            }
        })
    }
}

extension UserItemsViewController: UITableViewDataSource {
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return !isFetching && items.isEmpty ? 1 : items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if items.isEmpty {
            return UITableView.notFoundTextCell(UserItemRequest.self)
        }
        
        let cell = tableView.dequeueReusableCell(ItemCell.self, for: indexPath)
        cell.tag = indexPath.row
        cell.configure(with: self.items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let height = self.cellHeightList[indexPath] else {
            return UITableViewAutomaticDimension
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if !self.cellHeightList.keys.contains(indexPath) {
            self.cellHeightList[indexPath] = cell.frame.height
        }
        
        if indexPath.row == items.count - 1 {
            fetch(isPaging: true, completion: {})
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if refreshControl.isRefreshing || !isFetching {
            return UIView()
        }
        
        let view = tableView.dequeueReusableHeaderFooterView(LoadingFooterView.self)
        view.isLoading = isFetching
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return isFetching ? LoadingFooterView.defaultHeight : .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return LoadingFooterView.defaultHeight
    }
}

extension UserItemsViewController: UITableViewDelegate {
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if items.isEmpty {
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        let next = SFSafariViewController(url: items[indexPath.row].url)
        present(next, animated: true, completion: nil)
    }
}
