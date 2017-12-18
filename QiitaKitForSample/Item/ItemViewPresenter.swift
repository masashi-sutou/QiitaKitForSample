//
//  ItemViewPresenter.swift
//  QiitaKitForSample
//
//  Created by 須藤将史 on 2017/12/15.
//  Copyright © 2017年 須藤将史. All rights reserved.
//

import QiitaKit

protocol ItemPresenter: class {
    var favoriteButtonTitle: String { get }
    init(view: ItemViewable, item: Item, favoriteItemsViewPresenter: FavoriteItemsPresenter)
    func favoriteButtonTap()
}

final class ItemViewPresenter: ItemPresenter {
    
    weak var view: ItemViewable?
    private let favoriteItemsPresenter: FavoriteItemsPresenter
    private let item: Item
    
    var favoriteButtonTitle: String {
        return favoriteItemsPresenter.contains(item: item) ? "削除" : "追加"
    }
    
    init(view: ItemViewable, item: Item, favoriteItemsViewPresenter: FavoriteItemsPresenter) {
        self.item = item
        self.favoriteItemsPresenter = favoriteItemsViewPresenter
        self.view = view
    }
    
    func favoriteButtonTap() {
        if favoriteItemsPresenter.contains(item: item) {
            favoriteItemsPresenter.remove(item: item)
            view?.updateFavoriteButtonTitle("追加")
        } else {
            favoriteItemsPresenter.add(item: item)
            view?.updateFavoriteButtonTitle("削除")
        }
    }
}

