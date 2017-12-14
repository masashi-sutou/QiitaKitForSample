//
//  UserViewController.swift
//  QiitaKitForSample
//
//  Created by 須藤将史 on 2017/11/07.
//  Copyright © 2017年 須藤将史. All rights reserved.
//

import UIKit
import QiitaKit

final class UsersViewController: UIViewController {
    
    var favoriteModel: FavoriteModel?
    
    @IBOutlet weak var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    private var isFetching = false {
        didSet {
            DispatchQueue.main.async {
                self.navigationItem.prompt = "\(self.users.count) / \(self.totalCount)"
                self.tableView.reloadData()
            }
        }
    }
    private var page: Int = 0
    private var totalCount: Int = 0
    private var userId: String = "masashi-sutou"
    private var users: [User] = []
    private var cellHeightList: [IndexPath: CGFloat] = [:]
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
    
    // MARK: - API
    
    private func fetch(isPaging: Bool, completion: @escaping () -> Void) {
        if isFetching { return }
        if totalCount > 0 && totalCount == users.count {
            completion()
            return
        }
        
        isFetching = true
        page = isPaging ? page + 1 : page
        let request = UserFolloweeRequest(page: page, perPage: 20, userId: userId)
        ApiSession.shared.send(request, completion: { [weak self] in
            switch $0 {
            case .success(let response):
                self?.totalCount = response.totalCount
                if let me = self, isPaging || me.users.count < response.values.count * me.page {
                    me.users.append(contentsOf: response.values)
                }
            case .failure(let error):
                print("QiitaKit:[Error] -> ", error)
            }
            self?.isFetching = false
            completion()
        })
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
        navigationItem.prompt = "\(users.count) / \(totalCount)"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Style", style: .done, target: self, action: #selector(tappedChangeCellStyle(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "UserID", style: .done, target: self, action: #selector(tappedChangeUserId(_:)))
        
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
        
        fetch(isPaging: true, completion: {})
    }
    
    // MARK: - Transition
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.cellHeightList = [:]
    }
    
    // MARK: - UIRefreshControl
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        fetch(isPaging: false, completion: {
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
            self.page = 0
            self.totalCount = 0
            self.users = []
            self.cellHeightList = [:]
            self.fetch(isPaging: true, completion: {})
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension UsersViewController: UITableViewDataSource {
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return !isFetching && users.isEmpty ? 1 : users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if users.isEmpty {
            return UITableView.notFoundTextCell(text: UserFolloweeRequest.notFoundText)
        }
        
        let cell = tableView.dequeueReusableCell(UserCell.self, for: indexPath)
        cell.tag = indexPath.row
        cell.configure(with: users[indexPath.row], cellStyles: cellStyles)
        return cell
    }
        
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let height = self.cellHeightList[indexPath] else {
            return UITableViewAutomaticDimension
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if !self.cellHeightList.keys.contains(indexPath) {
            self.cellHeightList[indexPath] = cell.frame.height
        }
        
        if indexPath.row == users.count - 1 {
            fetch(isPaging: true, completion: {})
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if refreshControl.isRefreshing || !isFetching {
            return UIView()
        }
        
        let view = tableView.dequeueReusableHeaderFooterView(LoadingFooterView.self)
        view.isLoading = isFetching
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return isFetching ? LoadingFooterView.defaultHeight : .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return LoadingFooterView.defaultHeight
    }
}

extension UsersViewController: UITableViewDelegate {
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if users.isEmpty {
            return
        }
        
        guard let favoriteModel = favoriteModel else { return }
        
        tableView.deselectRow(at: indexPath, animated: true)
        let next = UserItemsViewController(user: users[indexPath.row], favoriteModel: favoriteModel)
        navigationController?.pushViewController(next, animated: true)
    }
}

extension UsersViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        userId = text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
