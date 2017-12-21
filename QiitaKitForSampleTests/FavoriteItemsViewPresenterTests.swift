//
//  FavoriteItemsViewPresenterTests.swift
//  QiitaKitForSampleTests
//
//  Created by 須藤将史 on 2017/12/19.
//  Copyright © 2017年 須藤将史. All rights reserved.
//

import XCTest
@testable import QiitaKitForSample
@testable import QiitaKit

class FavoriteItemsViewPresenterTests: XCTestCase {
    
    private class ViewMock: FavoriteItemsViewable {
        func reloadData() {
            print("呼ばれた！！！！！！")
        }
    }
    
    private let viewMock: FavoriteItemsViewable = ViewMock()
    private let items = [Item(id: "1", title: "記事タイトル", likesCount: 1, commentsCount: 1, tags: [], url: URL(string: "https://qiita.com")!, createdAt: Date()), Item(id: "2", title: "記事タイトル", likesCount: 1, commentsCount: 1, tags: [], url: URL(string: "https://qiita.com/trend")!, createdAt: Date())]
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testNumberOfFavoriteItems() {
        let empty = FavoriteItemsViewPresenter(view: viewMock, items: [])
        XCTAssertEqual(empty.numberOfFavoriteItems, 1)
        
        let one = FavoriteItemsViewPresenter(view: viewMock, items: [items[0]])
        XCTAssertEqual(one.numberOfFavoriteItems, 1)
        
        let two = FavoriteItemsViewPresenter(view: viewMock, items: items)
        XCTAssertEqual(two.numberOfFavoriteItems, items.count)
    }
    
    func testAdd() {
        let p = FavoriteItemsViewPresenter(view: viewMock, items: [])
        p.add(item: items[0])
        XCTAssertEqual(p.favoriteItem(at: 0)?.url, items[0].url)

        p.add(item: items[0])
        XCTAssertEqual(p.numberOfFavoriteItems, 1)
    }
    
    func testRemove() {
        let itemA = items[0]
        let same = FavoriteItemsViewPresenter(view: viewMock, items: [itemA])
        XCTAssertTrue(same.contains(item: itemA))
        same.remove(item: itemA)
        XCTAssertFalse(same.contains(item: itemA))

        let itemB = items[1]
        let diff = FavoriteItemsViewPresenter(view: viewMock, items: [itemA])
        XCTAssertFalse(diff.contains(item: itemB))
        diff.remove(item: itemB)
        XCTAssertFalse(diff.contains(item: itemB))
    }
    
    func testFavoriteItem() {
        let itemA = items[0]
        let one = FavoriteItemsViewPresenter(view: viewMock, items: [itemA])
        XCTAssertEqual(one.favoriteItem(at: 0)?.url, itemA.url)

        let empty = FavoriteItemsViewPresenter(view: viewMock, items: [])
        XCTAssertEqual(empty.favoriteItem(at: 0)?.url, nil)
    }
}
