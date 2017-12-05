//
//  NSObjectProtocol+className.swift
//  QiitaKit
//
//  Created by 須藤将史 on 2017/11/06.
//  Copyright © 2017年 須藤将史. All rights reserved.
//

import Foundation

extension NSObjectProtocol {
    public static var className: String {
        return String(describing: Self.self)
    }
}
