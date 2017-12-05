//
//  User.swift
//  QiitaKit
//
//  Created by 須藤将史 on 2017/11/07.
//  Copyright © 2017年 須藤将史. All rights reserved.
//

import Foundation

public struct User: Codable {
    public let id: String
    public let name: String?
    public let profileImageUrl: URL
    public let followeesCount: Int
    public let followersCount: Int
    public let itemsCount: Int
    public let websiteUrl: String?
    public let location: String?
    public let organization: String?
    public let description: String?

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case profileImageUrl = "profile_image_url"
        case followeesCount = "followees_count"
        case followersCount = "followers_count"
        case itemsCount = "items_count"
        case websiteUrl = "website_url"
        case location
        case organization
        case description
    }
}
