//
//  Item.swift
//  QiitaKit
//
//  Created by 須藤将史 on 2017/11/14.
//  Copyright © 2017年 須藤将史. All rights reserved.
//

import Foundation

public struct Item: Codable {
    public let id: String
    public let title: String
    public let likesCount: Int
    public let commentsCount: Int
    public let tags: [ItemTag]
    public let url: URL
    public let createdAt: Date
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case likesCount = "likes_count"
        case commentsCount = "comments_count"
        case tags
        case url
        case createdAt = "created_at"
    }
}
