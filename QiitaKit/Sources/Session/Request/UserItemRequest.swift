//
//  UserItemRequest.swift
//  QiitaKit
//
//  Created by 須藤将史 on 2017/11/14.
//  Copyright © 2017年 須藤将史. All rights reserved.
//

import Foundation

public struct UserItemRequest: Requestable {

    public typealias ResponseType = Item
    
    public static let notFoundText: String = "投稿がありません"
    public let endpoint: URL
    public let path: String = "users/%@/items"
    public let method: HttpMethod = .get
    public let body: [String: Any] = [:]
    
    public init(page: Int, perPage: Int, userId: String) {
        let basePathURL: URL = UserItemRequest.baseURL.appendingPathComponent(String(format: path, userId))
        var components: URLComponents? = URLComponents(url: basePathURL, resolvingAgainstBaseURL: true)
        components?.queryItems = [URLQueryItem(name: "page", value: String(page)),
                                  URLQueryItem(name: "per_page", value: String(perPage))]
        self.endpoint = components?.url ?? basePathURL
    }
    
    // MARK: - ResponseType decode
    
    public static func decode(with data: Data, response: HTTPURLResponse?) throws -> Response<Item> {
        return try .init(unkeyedContainer: data, response: response)
    }
}
