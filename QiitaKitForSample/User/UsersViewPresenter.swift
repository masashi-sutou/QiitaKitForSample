//
//  UsersViewPresenter.swift
//  QiitaKitForSample
//
//  Created by 須藤将史 on 2017/12/18.
//  Copyright © 2017年 須藤将史. All rights reserved.
//

import QiitaKit

protocol UsersPresenter {
    var numberOfUsers: Int { get }
    var isFetching: Bool { get }
    var userId: String { get set }
    init(view: UsersViewable, userId: String, users: [User])
    func add(user: User)
    func remove(user: User)
    func user(at index: Int) -> User?
    func contains(user: User) -> Bool
    func fetch(isPaging: Bool, completion: @escaping () -> Void)
    func nextFetch(isPaging: Bool, index: Int)
    func clearPaging()
}

final class UsersViewPresenter: UsersPresenter {
    
    private weak var view: UsersViewable?
    private var page: Int = 0
    private var totalCount: Int = 0
    private var users: [User] {
        didSet {
            DispatchQueue.main.async {
                self.view?.reloadData(count: self.users.count, total: self.totalCount)
            }
        }
    }

    var userId: String
    var isFetching = false {
        didSet {
            DispatchQueue.main.async {
                self.view?.reloadData(count: self.users.count, total: self.totalCount)
            }
        }
    }
    
    var numberOfUsers: Int {
        return !isFetching && users.isEmpty ? 1 : users.count
    }
    
    // MARK: - API
    
    func fetch(isPaging: Bool, completion: @escaping () -> Void) {
        if isFetching { return }
        if totalCount > 0 && totalCount == users.count {
            completion()
            return
        }
        
        isFetching = true
        page = isPaging ? page + 1 : page
        let request = UserFolloweeRequest(page: page, perPage: 20, userId: userId)
        ApiSession.shared.send(request, completion: { [weak self] in
            switch $0 {
            case .success(let response):
                self?.totalCount = response.totalCount
                if let me = self, isPaging || me.users.count < response.values.count * me.page {
                    me.users.append(contentsOf: response.values)
                }
            case .failure(let error):
                print("QiitaKit:[Error] -> ", error)
            }
            self?.isFetching = false
            completion()
        })
    }
    
    // MARK: - initialize
    
    init(view: UsersViewable, userId: String, users: [User] = []) {
        self.view = view
        self.userId = userId
        self.users = users
    }
    
    // MARK: - subscript
    
    func add(user: User) {
        if users.index(where: { $0.id == user.id }) != nil {
            return
        }
        users.append(user)
    }
    
    func remove(user: User) {
        guard let index = users.index(where: { $0.id == user.id }) else {
            return
        }
        users.remove(at: index)
    }
    
    func user(at index: Int) -> User? {
        return users.isEmpty ? nil : users[index]
    }
    
    func contains(user: User) -> Bool {
        return users.index { $0.id == user.id } != nil
    }
    
    func nextFetch(isPaging: Bool, index: Int) {
        if index == users.count - 1 {
            fetch(isPaging: isPaging, completion: {})
        }
    }
    
    func clearPaging() {
        page = 0
        totalCount = 0
        users = []
    }
}
