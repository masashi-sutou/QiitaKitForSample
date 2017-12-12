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

    private var favoriteItems: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "お気に入りの投稿"
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteItems.isEmpty ? 1 : favoriteItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if favoriteItems.isEmpty {
            return UITableView.notFoundTextCell(text: "お気に入りがありません")
        }
        
        let cell = tableView.dequeueReusableCell(ItemCell.self, for: indexPath)
        cell.selectionStyle = .none
        cell.tag = indexPath.row
        cell.configure(with: favoriteItems[indexPath.row])
        return cell
    }
}
