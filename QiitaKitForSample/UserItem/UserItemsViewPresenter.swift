//
//  UserItemsViewPresenter.swift
//  QiitaKitForSample
//
//  Created by 須藤将史 on 2017/12/16.
//  Copyright © 2017年 須藤将史. All rights reserved.
//

import QiitaKit

protocol UserItemsPresenter {
    var numberOfUserItems: Int { get }
    var isFetching: Bool { get }
    init(view: UserItemsViewable, user: User, items: [Item])
    func add(item: Item)
    func remove(item: Item)
    func userItem(at index: Int) -> Item?
    func contains(item: Item) -> Bool
    func showItem(at index: Int)
    func fetch(isPaging: Bool, completion: @escaping () -> Void)
    func nextFetch(isPaging: Bool, index: Int)
}

final class UserItemsViewPresenter: UserItemsPresenter {
    
    private weak var view: UserItemsViewable?
    private let user: User
    private var page: Int = 0
    private var totalCount: Int = 0
    
    var isFetching = false {
        didSet {
            DispatchQueue.main.async {
                self.view?.reloadData(count: self.items.count, total: self.totalCount)
            }
        }
    }
    
    private var items: [Item] {
        didSet {
            DispatchQueue.main.async {
                self.view?.reloadData(count: self.items.count, total: self.totalCount)
            }
        }
    }
    
    var numberOfUserItems: Int {
       return !isFetching && items.isEmpty ? 1 : items.count
    }

    // MARK: - API
    
    func fetch(isPaging: Bool, completion: @escaping () -> Void) {
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
    
    // MARK: - initialize
    
    init(view: UserItemsViewable, user: User, items: [Item] = []) {
        self.view = view
        self.user = user
        self.items = items
    }

    // MARK: - subscript

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
    
    func userItem(at index: Int) -> Item? {
        return items.isEmpty ? nil : items[index]
    }
    
    func contains(item: Item) -> Bool {
        return items.index { $0.url == item.url } != nil
    }
    
    func showItem(at index: Int) {
        guard let item = userItem(at: index) else { return }
        view?.show(item: item)
    }
    
    func nextFetch(isPaging: Bool, index: Int) {
        if index == items.count - 1 {
            fetch(isPaging: isPaging, completion: {})
        }
    }
}
