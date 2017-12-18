//
//  UserItemViewController.swift
//  QiitaKitForSample
//
//  Created by 須藤将史 on 2017/11/14.
//  Copyright © 2017年 須藤将史. All rights reserved.
//

import UIKit
import QiitaKit

protocol UserItemsViewable: class {
    func reloadData(count: Int, total: Int)
    func show(item: Item)
}

final class UserItemsViewController: UIViewController, UserItemsViewable {

    private let favoriteItemsPresenter: FavoriteItemsPresenter
    private let user: User
    private lazy var presenter: UserItemsViewPresenter = .init(view: self, user: user)
    
    private var cellHeightList: [IndexPath: CGFloat] = [:]
    private let tableView: UITableView
    private let refreshControl = UIRefreshControl()
    
    init(user: User, favoriteItemsPresenter: FavoriteItemsPresenter) {
        self.user = user
        self.favoriteItemsPresenter = favoriteItemsPresenter
        self.tableView = UITableView(frame: .zero, style: .plain)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = user.id + "の投稿一覧"
        navigationItem.prompt = "\(0) / \(0)"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        tableView.registerCell(ItemCell.self)
        tableView.registerHeaderFooterView(LoadingFooterView.self)
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        view.addSubview(tableView)
        tableView.setupConstraint(parentView: view)

        presenter.fetch(isPaging: true) {}
    }
    
    // MARK: - Transition
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        cellHeightList = [:]
    }
    
    // MARK: - UIRefreshControl
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        presenter.fetch(isPaging: false, completion: {
            DispatchQueue.main.async {
                sender.endRefreshing()
            }
        })
    }
    
    // MARK: - UserItemsViewable
    
    func reloadData(count: Int, total: Int) {
        navigationItem.prompt = "\(count) / \(total)"
        tableView.reloadData()
    }
    
    func show(item: Item) {
        let next = ItemViewController(item: item, favoriteItemsPresenter: favoriteItemsPresenter)
        navigationController?.pushViewController(next, animated: true)
    }
}

extension UserItemsViewController: UITableViewDataSource {
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfUserItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let item = presenter.userItem(at: indexPath.row) else {
            return UITableView.notFoundTextCell(text: UserItemRequest.notFoundText)
        }
        
        let cell = tableView.dequeueReusableCell(ItemCell.self, for: indexPath)
        cell.tag = indexPath.row
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let height = cellHeightList[indexPath] else {
            return UITableViewAutomaticDimension
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if !cellHeightList.keys.contains(indexPath) {
            cellHeightList[indexPath] = cell.frame.height
        }
        
        presenter.nextFetch(isPaging: true, index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if refreshControl.isRefreshing || !presenter.isFetching {
            return UIView()
        }
        
        let view = tableView.dequeueReusableHeaderFooterView(LoadingFooterView.self)
        view.isLoading = presenter.isFetching
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return presenter.isFetching ? LoadingFooterView.defaultHeight : .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return LoadingFooterView.defaultHeight
    }
}

extension UserItemsViewController: UITableViewDelegate {
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.showItem(at: indexPath.row)
    }
}
