//
//  UIColor+hex.swift
//  QiitaKit
//
//  Created by 須藤将史 on 2017/11/07.
//  Copyright © 2017年 須藤将史. All rights reserved.
//

import UIKit

extension UIColor {
    
    public static var defaultTint: UIColor {
        return UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
    }
    
    public static var defaultTintHighlighted: UIColor {
        return UIColor(red: 0.6, green: 192/255, blue: 1, alpha: 1)
    }
    
    public static var placeholderBackgroundGray: UIColor {
        return UIColor.hex(hexStr: "F4F4F4", alpha: 1.0)
    }
    
    public static var unable: UIColor {
        return UIColor(red: 200/255, green: 200/255, blue: 204/255, alpha: 1)
    }
    
    public static func hex(hexStr: String, alpha: CGFloat) -> UIColor {
        
        let hexStr = hexStr.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hexStr)
        var color: UInt32 = 0
        
        if scanner.scanHexInt32(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red: r, green: g, blue: b, alpha: alpha)
        } else {
            print("不正な値")
            return .white
        }
    }
}

