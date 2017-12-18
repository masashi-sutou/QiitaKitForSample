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

protocol ItemViewable: class {
    func updateFavoriteButtonTitle(_ title: String)
}

final class ItemViewController: SFSafariViewController, ItemViewable {

    private var presenter: ItemViewPresenter?
    private lazy var favoriteButton: UIBarButtonItem = {
        return UIBarButtonItem(title: self.presenter?.favoriteButtonTitle,
                               style: .plain,
                               target: self,
                               action: #selector(tappedFavoriteButton(_:)))
    }()
    
    init(item: Item, favoriteItemsPresenter: FavoriteItemsPresenter) {
        super.init(url: item.url, entersReaderIfAvailable: false)
        self.presenter = ItemViewPresenter(view: self, item: item, favoriteItemsViewPresenter: favoriteItemsPresenter)
        hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = favoriteButton
    }
    
    @objc private func tappedFavoriteButton(_ sender: UIBarButtonItem) {
        presenter?.favoriteButtonTap()
    }
    
    // MARK: - ItemView
    
    func updateFavoriteButtonTitle(_ title: String) {
        favoriteButton.title = title
    }
}
