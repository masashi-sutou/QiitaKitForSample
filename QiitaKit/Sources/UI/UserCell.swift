//
//  UserCell.swift
//  QiitaKit
//
//  Created by 須藤将史 on 2017/11/07.
//  Copyright © 2017年 須藤将史. All rights reserved.
//

import UIKit
import Nuke

public final class UserCell: UITableViewCell, Nibable {

    public enum Style: String {
        case `default` = "デフォルト"
        case location = "住所"
        case description = "自己紹介"
        case rowNumber = "行番号"

        public static func title() -> String {
            return "UserCell Style"
        }
        
        public static func message() -> String {
            return "Custom UITableViewCell Animation Style"
        }
    }
    
    private static let shared: UserCell = UserCell.makeFromNib()
    private static let minimumHeight: CGFloat = 88

    @IBOutlet weak var rowLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView! {
        didSet {
            thumbnailImageView.layer.cornerRadius = 4
            thumbnailImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var userNameLabel: UILabel!

    @IBOutlet weak var itemLabel: UILabel! {
        didSet {
            itemLabel.setText(as: .item, ofSize: 16)
        }
    }
    @IBOutlet weak var itemCountLabel: UILabel!
    
    @IBOutlet weak var followingLabel: UILabel! {
        didSet {
            followingLabel.setText(as: .followee, ofSize: 16)
        }
    }
    @IBOutlet weak var followingCountLabel: UILabel!
    
    @IBOutlet weak var followerLabel: UILabel! {
        didSet {
            followerLabel.setText(as: .follower, ofSize: 16)
        }
    }
    @IBOutlet weak var followerCountLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationIconLabel: UILabel! {
        didSet {
            locationIconLabel.setText(as: .location, ofSize: 14)
        }
    }
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationContentView: UIView!
    
    // MARK: - 再利用
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        Manager.shared.cancelRequest(for: thumbnailImageView)
        thumbnailImageView.image = nil
    }

    // MARK: - 高さ計算
    
    public static func calculateHeight(with user: User, cellStyles: Set<UserCell.Style>, and tableView: UITableView) -> CGFloat {
        shared.frame.size.width = tableView.bounds.width
        shared.descriptionLabel.preferredMaxLayoutWidth = shared.descriptionLabel.bounds.width
        shared.configure(with: user, cellStyles: cellStyles)
        shared.layoutIfNeeded()
        let height: CGFloat = shared.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        return max(minimumHeight, height) + 1.0 // 1.0 = separatorHeight
    }
    
    // MARK: - セットアップ
    
    public func configure(with user: User, cellStyles: Set<UserCell.Style>) {
        
        Manager.shared.loadImage(with: user.profileImageUrl, into: thumbnailImageView)
        
        rowLabel.text = String(tag)
        
        // プロフィール画像と名前のラベルを上辺で揃えるため
        userNameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        if let name: String = user.name, !name.isEmpty {
            userNameLabel.text = user.id + " (" + name + ")"
        } else {
            userNameLabel.text = user.id
        }
        itemCountLabel.text = user.itemsCount.truncateString
        followingCountLabel.text = user.followeesCount.truncateString
        followerCountLabel.text = user.followersCount.truncateString
        
        locationContentView.isHidden = user.location?.isEmpty ?? true
        locationLabel.text = user.location

        descriptionLabel.isHidden = user.description?.isEmpty ?? true
        descriptionLabel.text = user.description
        
        setupCellStyle(cellStyles, isAnimate: false)
    }
    
    public func setupCellStyle(_ cellStyles: Set<UserCell.Style>, isAnimate: Bool) {
        
        thumbnailImageLeft.constant = 0
        thumbnailImageWidth.constant = 64
        thumbnailImageHeight.constant = 64
        rowLabel.isHidden = true
        descriptionLabel.isHidden = true
        locationContentView.isHidden = true
        
        if cellStyles.contains(.rowNumber) {
            thumbnailImageLeft.constant = 20
            thumbnailImageWidth.constant = 54
            thumbnailImageHeight.constant = 54
            rowLabel.isHidden = false
        }

        if cellStyles.contains(.description) {
            descriptionLabel.isHidden = descriptionLabel.text?.isEmpty ?? true
        }

        if cellStyles.contains(.location) {
            locationContentView.isHidden = locationLabel.text?.isEmpty ?? true
        }
        
        if isAnimate {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.contentView.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @IBOutlet weak var thumbnailImageLeft: NSLayoutConstraint!
    @IBOutlet weak var thumbnailImageHeight: NSLayoutConstraint!
    @IBOutlet weak var thumbnailImageWidth: NSLayoutConstraint!
}
