//
//  UserViewController.swift
//  QiitaKitForSample
//
//  Created by 須藤将史 on 2017/11/07.
//  Copyright © 2017年 須藤将史. All rights reserved.
//

import UIKit
import QiitaKit

protocol UsersViewable: class {
    func reloadData(count: Int, total: Int)
}

final class UsersViewController: UIViewController, UsersViewable {
    
    var favoriteItemsPresenter: FavoriteItemsPresenter?
    private var cellStyles: Set<UserCell.Style> = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.visibleCells
                    .flatMap { $0 as? UserCell }
                    .forEach {
                        self.tableView.beginUpdates()
                        $0.setupCellStyle(self.cellStyles, isAnimate: true)
                        self.tableView.endUpdates()
                }
            }
        }
    }
    private var cellHeightList: [IndexPath: CGFloat] = [:]

    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    private lazy var styleButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "Style",
                               style: .done,
                               target: self,
                               action: #selector(tappedChangeCellStyle(_:)))
    }()
    private lazy var userIdButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "UserID",
                               style: .done,
                               target: self,
                               action: #selector(tappedChangeUserId(_:)))
    }()
    
    private lazy var presenter: UsersViewPresenter = UsersViewPresenter(view: self, userId: "masashi-sutou")
    
    // MARK: - UsersViewable
    
    func reloadData(count: Int, total: Int) {
        navigationItem.prompt = "\(count) / \(total)"
        tableView.reloadData()
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let token = ApiSession.shared.token ?? ""
        guard !token.isEmpty, token != "Your Qiita Personal Access Token" else {
            let alert = UIAlertController(title: "Access Token Error", message: "\"Qiita Personal Access Token\" is Required.\n Please set it to ApiSession.shared.token in AppDelegate.", preferredStyle: .alert)
            present(alert, animated: false, completion: nil)
            return
        }
        
        navigationItem.title = "ユーザーの一覧"
        navigationItem.prompt = "\(0) / \(0)"
        navigationItem.leftBarButtonItem = styleButton
        navigationItem.rightBarButtonItem = userIdButton
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        tableView.registerCell(UserCell.self)
        tableView.registerHeaderFooterView(LoadingFooterView.self)
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
            tableView.refreshControl = refreshControl
        } else if #available(iOS 10.0, *) {
            automaticallyAdjustsScrollViewInsets = false
            tableView.refreshControl = refreshControl
        } else {
            automaticallyAdjustsScrollViewInsets = false
            tableView.addSubview(refreshControl)
        }
        
        presenter.fetch(isPaging: true) {}
    }
    
    // MARK: - Transition
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        cellHeightList = [:]
    }
    
    // MARK: - UIRefreshControl
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        presenter.fetch(isPaging: false, completion: {
            DispatchQueue.main.async {
                sender.endRefreshing()
            }
        })
    }
    
    // MARK: - BarButtonItem
    
    @objc private func tappedChangeCellStyle(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: UserCell.Style.title(), message: UserCell.Style.message(), preferredStyle: .actionSheet)
        alert.popoverPresentationController?.barButtonItem = sender
        alert.addAction(UIAlertAction(title: UserCell.Style.default.rawValue, style: .cancel, handler: { _ in
            self.cellHeightList = [:]
            self.cellStyles = []
        }))
        alert.addAction(UIAlertAction(title: UserCell.Style.location.rawValue, style: .default, handler: { _ in
            self.cellHeightList = [:]
            self.cellStyles.insert(.location)
        }))
        alert.addAction(UIAlertAction(title: UserCell.Style.description.rawValue, style: .default, handler: { _ in
            self.cellHeightList = [:]
            self.cellStyles.insert(.description)
        }))
        alert.addAction(UIAlertAction(title: UserCell.Style.rowNumber.rawValue, style: .default, handler: { _ in
            self.cellHeightList = [:]
            self.cellStyles.insert(.rowNumber)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func tappedChangeUserId(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "QiitaのユーザーIDを入力", message: "\n例: masashi-sutou", preferredStyle: .alert)
        alert.popoverPresentationController?.barButtonItem = sender
        alert.addTextField { (textField) in
            textField.placeholder = "QiitaのユーザーIDを入力してください"
            textField.delegate = self
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.presenter.clearPaging()
            self.cellHeightList = [:]
            self.presenter.fetch(isPaging: true, completion: {})
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension UsersViewController: UITableViewDataSource {
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfUsers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let user = presenter.user(at: indexPath.row) else {
            return UITableView.notFoundTextCell(text: UserItemRequest.notFoundText)
        }
        
        let cell = tableView.dequeueReusableCell(UserCell.self, for: indexPath)
        cell.tag = indexPath.row
        cell.configure(with: user, cellStyles: cellStyles)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let height = cellHeightList[indexPath] else {
            return UITableViewAutomaticDimension
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if !cellHeightList.keys.contains(indexPath) {
            cellHeightList[indexPath] = cell.frame.height
        }
        
        presenter.nextFetch(isPaging: true, index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if refreshControl.isRefreshing || !presenter.isFetching {
            return UIView()
        }
        
        let view = tableView.dequeueReusableHeaderFooterView(LoadingFooterView.self)
        view.isLoading = presenter.isFetching
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return presenter.isFetching ? LoadingFooterView.defaultHeight : .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return LoadingFooterView.defaultHeight
    }
}

extension UsersViewController: UITableViewDelegate {
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let user = presenter.user(at: indexPath.row), let favoriteItemsPresenter = favoriteItemsPresenter else { return }
        let next = UserItemsViewController(user: user, favoriteItemsPresenter: favoriteItemsPresenter)
        navigationController?.pushViewController(next, animated: true)
    }
}

extension UsersViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        presenter.userId = text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
