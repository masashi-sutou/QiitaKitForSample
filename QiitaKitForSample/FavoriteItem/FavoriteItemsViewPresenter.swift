//
//  FavoriteItemsViewPresenter.swift
//  QiitaKitForSample
//
//  Created by 須藤将史 on 2017/12/15.
//  Copyright © 2017年 須藤将史. All rights reserved.
//

import QiitaKit

protocol FavoriteItemsPresenter: class {
    var numberOfFavoriteItems: Int { get }
    init(view: FavoriteItemsViewable, items: [Item])
    func add(item: Item)
    func remove(item: Item)
    func favoriteItem(at index: Int) -> Item?
    func contains(item: Item) -> Bool
}

final class FavoriteItemsViewPresenter: FavoriteItemsPresenter {
    
    private weak var view: FavoriteItemsViewable?
    
    private var items: [Item] {
        didSet {
            view?.reloadData()
        }
    }
    
    var numberOfFavoriteItems: Int {
        return items.isEmpty ? 1 : items.count
    }
    
    init(view: FavoriteItemsViewable, items: [Item] = []) {
        self.view = view
        self.items = items
    }

    func add(item: Item) {
        if items.index(where: { $0.url == item.url }) != nil {
            return
        }
        items.append(item)
    }
    
    func remove(item: Item) {
        guard let index = items.index(where: { $0.url == item.url }) else {
            return
        }
        items.remove(at: index)
    }
    
    func favoriteItem(at index: Int) -> Item? {
        return items.isEmpty ? nil : items[index]
    }
    
    func contains(item: Item) -> Bool {
        return items.index { $0.url == item.url } != nil
    }
}
