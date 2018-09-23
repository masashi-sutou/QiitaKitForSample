//
//  ItemCell.swift
//  QiitaKit
//
//  Created by 須藤将史 on 2017/11/14.
//  Copyright © 2017年 須藤将史. All rights reserved.
//

import UIKit

public final class ItemCell: UITableViewCell, Nibable {

    private static let shared: ItemCell = ItemCell.makeFromNib()
    private static let minimumHeight: CGFloat = 88
    
    @IBOutlet weak var rowLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel! {
        didSet {
            likesLabel.setText(as: .like, ofSize: 16)
        }
    }
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel! {
        didSet {
            commentsLabel.setText(as: .comment, ofSize: 16)
        }
    }
    @IBOutlet weak var commentsCountLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    // MARK: - 高さ計算
    
    public static func calculateHeight(with item: Item, and tableView: UITableView) -> CGFloat {
        shared.frame.size.width = tableView.bounds.width
        shared.titleLabel.preferredMaxLayoutWidth = shared.titleLabel.bounds.width
        shared.configure(with: item)
        shared.layoutIfNeeded()
        let height: CGFloat = shared.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return max(minimumHeight, height) + 1.0 // 1.0 = separatorHeight
    }
    
    // MARK: - セットアップ
    
    public func configure(with item: Item) {
        rowLabel.text = String(tag)
        titleLabel.text = item.title
        likesCountLabel.text = item.likesCount.truncateString
        commentsCountLabel.text = item.commentsCount.truncateString
        createdAtLabel.text = DateFormatter.default.string(from: item.createdAt)
    }
}
