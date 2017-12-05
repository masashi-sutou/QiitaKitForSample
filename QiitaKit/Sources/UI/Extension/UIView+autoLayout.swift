//
//  UIView+autoLayout.swift
//  QiitaKit
//
//  Created by 須藤将史 on 2017/11/24.
//  Copyright © 2017年 須藤将史. All rights reserved.
//

import UIKit

extension UIView {
    
    final public func setupConstraint(parentView: UIView) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 11.0, *) {
            topAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.leadingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.bottomAnchor).isActive = true
            trailingAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.trailingAnchor).isActive = true
        } else {
            topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
            trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
        }
    }
}
