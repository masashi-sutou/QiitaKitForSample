//
//  FavoriteItemsViewController.swift
//  QiitaKitForSample
//
//  Created by 須藤将史 on 2017/12/13.
//  Copyright © 2017年 須藤将史. All rights reserved.
//

import UIKit
import QiitaKit

final class FavoriteItemsViewController: UITableViewController {

    let favoriteModel = FavoriteModel()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoriteModel.delegate = self
        navigationItem.title = "お気に入りの投稿"
        tableView.tableFooterView = UIView()
        tableView.registerCell(ItemCell.self)
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteModel.items.isEmpty ? 1 : favoriteModel.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if favoriteModel.items.isEmpty {
            return UITableView.notFoundTextCell(text: "お気に入りがありません")
        }
        
        let cell = tableView.dequeueReusableCell(ItemCell.self, for: indexPath)
        cell.tag = indexPath.row
        cell.configure(with: favoriteModel.items[indexPath.row])
        return cell
    }
    
    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let next = ItemViewController(item: favoriteModel.items[indexPath.row], favoriteModel: favoriteModel)
        navigationController?.pushViewController(next, animated: true)
    }
}

extension FavoriteItemsViewController: FavoriteModelDelegate {
    func favoriteDidChange() {
        tableView.reloadData()
    }
}
