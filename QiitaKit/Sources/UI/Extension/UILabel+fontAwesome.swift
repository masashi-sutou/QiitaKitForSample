//
//  UILabel+fontAwesome.swift
//  QiitaKit
//
//  Created by 須藤将史 on 2017/11/09.
//  Copyright © 2017年 須藤将史. All rights reserved.
//

import UIKit
import SwiftIconFont

extension UILabel {
    enum FontAwesomeIcon: String {
        case item = "pencil"
        case location = "mapmarker"
        case followee = "eye"
        case follower = "users"
        case like = "thumbsup"
        case comment = "comments"
    }
    
    func setText(as icon: FontAwesomeIcon, ofSize size: CGFloat = 16.0) {
        font = .icon(from: .fontAwesome, ofSize: size)
        text = .fontAwesomeIcon(icon.rawValue)
    }
}
