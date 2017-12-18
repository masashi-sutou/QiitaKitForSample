//
//  FavoriteItemsViewController.swift
//  QiitaKitForSample
//
//  Created by 須藤将史 on 2017/12/13.
//  Copyright © 2017年 須藤将史. All rights reserved.
//

import UIKit
import QiitaKit

protocol FavoriteItemsViewable: class {
    func reloadData()
}

final class FavoriteItemsViewController: UITableViewController, FavoriteItemsViewable {

    lazy var presenter: FavoriteItemsViewPresenter = FavoriteItemsViewPresenter(view: self)
        
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "お気に入りの投稿"
        tableView.tableFooterView = UIView()
        tableView.registerCell(ItemCell.self)
    }

    // MARK: - FavoriteItemsView
    
    func reloadData() {
        tableView?.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfFavoriteItems
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let item: Item = presenter.favoriteItem(at: indexPath.row) else {
            return UITableView.notFoundTextCell(text: "お気に入りがありません")
        }
        
        let cell = tableView.dequeueReusableCell(ItemCell.self, for: indexPath)
        cell.tag = indexPath.row
        cell.configure(with: item)
        return cell
    }
    
    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let item: Item = presenter.favoriteItem(at: indexPath.row) else {
            return
        }
        
        let next = ItemViewController(item: item, favoriteItemsPresenter: presenter)
        navigationController?.pushViewController(next, animated: true)
    }
}
