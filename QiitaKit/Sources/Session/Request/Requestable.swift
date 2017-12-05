//
//  Requestable.swift
//  QiitaKit
//
//  Created by 須藤将史 on 2017/11/07.
//  Copyright © 2017年 須藤将史. All rights reserved.
//

import Foundation

public enum HttpMethod: String {
    case get = "GET"
}

final class RequestConfig {
    static let shared = RequestConfig()
    var token: String?
}

public protocol Requestable {
    associatedtype ResponseType: Codable

    static var baseURL: URL { get }
    static var nodeKeys: [String] { get }
    static var notFoundText: String { get }
    
    var allHTTPHeaderFields: [String: String]? { get }
    var endpoint: URL { get }
    var path: String { get }
    var method: HttpMethod { get }
    var body: [String: Any] { get }
    
    static func decode(with data: Data, response: HTTPURLResponse?) throws -> Response<ResponseType>
}

extension Requestable {
    public static var baseURL: URL {
        return URL(string: "https://qiita.com/api/v2/")!
    }
    
    public static var notFoundText: String {
        return "データがありません"
    }
    
    public var allHTTPHeaderFields: [String: String]? {
        guard let token = RequestConfig.shared.token else { return nil }
        return ["Authorization": "Bearer \(token)"]
    }
}
