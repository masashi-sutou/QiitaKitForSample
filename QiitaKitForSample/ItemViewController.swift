//
//  ItemViewController.swift
//  QiitaKitForSample
//
//  Created by 須藤将史 on 2017/12/13.
//  Copyright © 2017年 須藤将史. All rights reserved.
//

import UIKit
import QiitaKit
import SafariServices

final class ItemViewController: SFSafariViewController {

    private let item: Item
    private let favoriteModel: FavoriteModel = FavoriteModel.shared
    
    init(item: Item) {
        self.item = item
        super.init(url: item.url, entersReaderIfAvailable: false)
        hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let title = favoriteModel.items.contains(where: { $0.url == item.url }) ? "削除" : "追加"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: title,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(tappedFavoriteButton(_:)))
    }
    
    @objc private func tappedFavoriteButton(_ sender: UIBarButtonItem) {
        
        if favoriteModel.items.index(where: { $0.url == item.url }) == nil {
            favoriteModel.add(item: item)
            sender.title = "削除"
        } else {
            favoriteModel.remove(item: item)
            sender.title = "追加"
        }
    }
}
