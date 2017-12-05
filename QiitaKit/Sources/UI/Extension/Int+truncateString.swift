//
//  Int+truncateString.swift
//  QiitaKit
//
//  Created by 須藤将史 on 2017/11/09.
//  Copyright © 2017年 須藤将史. All rights reserved.
//

import Foundation

extension Int {
    var truncateString: String {
        switch self {
        case 0...999:
            return "\(self)"
        case 1000...999999:
            return "\(String(format: "%.1f", Double(self) / 1000))K"
        default:
            return "\(String(format: "%.1f", Double(self) / 1000000))K"
        }
    }
}
