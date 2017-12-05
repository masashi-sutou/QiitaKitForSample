//
//  DateFormatter+extension.swift
//  QiitaKit
//
//  Created by 須藤将史 on 2017/11/06.
//  Copyright © 2017年 須藤将史. All rights reserved.
//

import Foundation

extension DateFormatter {
    public static let `default`: DateFormatter = {
        let f: DateFormatter = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.calendar = Calendar(identifier: .gregorian)
        f.timeZone = TimeZone(secondsFromGMT: 0)
        f.dateFormat = "dd MMMM yyyy"
        return f
    }()
    
    public static let ISO8601: DateFormatter = {
        let f: DateFormatter = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.calendar = Calendar(identifier: .gregorian)
        f.timeZone = TimeZone(secondsFromGMT: 0)
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        return f
    }()
}
