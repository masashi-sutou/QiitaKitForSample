//
//  Response.swift
//  QiitaKit
//
//  Created by 須藤将史 on 2017/11/07.
//  Copyright © 2017年 須藤将史. All rights reserved.
//

import Foundation

public struct Response<T: Codable> {
    public let totalCount: Int
    public let nodes: [T]

    init(single data: Data, response: HTTPURLResponse?) throws {
        let strTotalCount: String = response?.allHeaderFields["Total-Count"] as? String ?? ""
        self.totalCount = Int(strTotalCount) ?? 0
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.ISO8601)
        self.nodes = [try decoder.decode(T.self, from: data)]
    }
    
    init(unkeyedContainer data: Data, response: HTTPURLResponse?) throws {
        let strTotalCount: String = response?.allHeaderFields["Total-Count"] as? String ?? ""
        self.totalCount = Int(strTotalCount) ?? 0
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.ISO8601)
        self.nodes = try decoder.decode([T].self, from: data)
    }    
}
