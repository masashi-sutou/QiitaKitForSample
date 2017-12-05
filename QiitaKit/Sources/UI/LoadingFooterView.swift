//
//  LoadingFooterView.swift
//  QiitaKit
//
//  Created by 須藤将史 on 2017/11/23.
//  Copyright © 2017年 須藤将史. All rights reserved.
//

import UIKit

final public class LoadingFooterView: UITableViewHeaderFooterView, Nibable {

    public static let defaultHeight: CGFloat = 44
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    public var isLoading: Bool = false {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let me = self else { return }
                me.activityIndicator?.isHidden = !me.isLoading
                if me.isLoading {
                    me.activityIndicator?.startAnimating()
                } else {
                    me.activityIndicator?.stopAnimating()
                }
            }
        }
    }
}
