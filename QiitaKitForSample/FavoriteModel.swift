//
//  FavoriteModel.swift
//  QiitaKitForSample
//
//  Created by 須藤将史 on 2017/12/13.
//  Copyright © 2017年 須藤将史. All rights reserved.
//

import QiitaKit

protocol FavoriteModelDelegate: class {
    func favoriteDidChange()
}

final class FavoriteModel {
    
    private(set) var items: [Item] = [] {
        didSet {
            delegate?.favoriteDidChange()
        }
    }
    
    weak var delegate: FavoriteModelDelegate?
    
    func add(item: Item) {
        guard items.index(where: { $0.url == item.url }) == nil else {
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
}
