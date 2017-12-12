//
//  UITableView+preparation.swift
//  QiitaKit
//
//  Created by 須藤将史 on 2017/11/07.
//  Copyright © 2017年 須藤将史. All rights reserved.
//

import UIKit

extension UITableView {
    public func registerDefaultCell() {
        register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.className)
    }
    
    public func registerCell<T: Nibable>(_ cell: T.Type) {
        register(T.nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    public func registerHeaderFooterView<T: Nibable>(_ view: T.Type) {
        register(T.nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
    
    public func dequeueReusableDefaultCell(for indexPath: IndexPath) -> UITableViewCell {
        return dequeueReusableCell(withIdentifier: UITableViewCell.className, for: indexPath)
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T where T: Nibable {
        return dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    public func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_ type: T.Type) -> T where T: Nibable {
        return dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as! T
    }
        
    public static func notFoundTextCell(text: String) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "notFoundTextCell")
        cell.selectionStyle = .none
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .darkGray
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "\n" + text
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        return cell
    }
}
