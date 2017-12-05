//
//  ApiSession.swift
//  QiitaKit
//
//  Created by 須藤将史 on 2017/11/07.
//  Copyright © 2017年 須藤将史. All rights reserved.
//

import Foundation

public final class ApiSession {
    public enum Result<T> {
        case success(T)
        case failure(Swift.Error)
    }
    
    public enum Error: Swift.Error {
        case emptyData
    }
    
    public static let shared = ApiSession()
    
    private let session: URLSession
    private let configuration: URLSessionConfiguration
    
    public var token: String? {
        set { RequestConfig.shared.token = newValue }
        get { return RequestConfig.shared.token }
    }
    
    public init(configuration: URLSessionConfiguration = .default) {
        configuration.timeoutIntervalForRequest = 30
        self.configuration = configuration
        self.session = URLSession(configuration: configuration)
    }
    
    public func send<T: Requestable>(_ request: T, completion: @escaping (Result<Response<T.ResponseType>>) -> Void) {
        var urlRequest = URLRequest(url: request.endpoint)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.allHTTPHeaderFields
        
        if !request.body.isEmpty {
            do {
                let data = try JSONSerialization.data(withJSONObject: request.body, options: .prettyPrinted)
                urlRequest.httpBody = data
            } catch let e {
                completion(.failure(e))
                return
            }
        }
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
                        
            guard let data = data else {
                completion(.failure(Error.emptyData))
                return
            }
            
            do {
                try completion(.success(T.decode(with: data, response: response as? HTTPURLResponse)))
            } catch let e {
                completion(.failure(e))
            }
        }
        task.resume()
    }
}
