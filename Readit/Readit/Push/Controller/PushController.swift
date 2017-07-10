//
//  PushController.swift
//  Readit
//
//  Created by kingcos on 08/07/2017.
//  Copyright © 2017 kingcos. All rights reserved.
//

import UIKit
import MJRefresh
import LeanCloud
import ProgressHUD

class PushController: UIViewController {
    
    let cellIdentifier = "PushCell"
    
    var reviews = [Any]()
    var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    deinit {
        print("PushController", #function)
    }

}

extension PushController {
    func setupUI() {
        view.backgroundColor = UIColor.white
        
        setupNavigationBar()
        setupTableView()
    }
    
    func setupNavigationBar() {
        let navigationView = UIView(frame: CGRect(x: 0.0, y: -20.0, width: SCREEN_WIDTH, height: 65))
        navigationView.backgroundColor = .white
        
        navigationController?.navigationBar.addSubview(navigationView)
        
        let addBookButton = UIButton(frame: CGRect(x: 20.0, y: 20.0, width: SCREEN_WIDTH, height: 45.0))
        addBookButton.setImage(#imageLiteral(resourceName: "plus circle"), for: .normal)
        addBookButton.setTitleColor(.black, for: .normal)
        addBookButton.setTitle(" 新建书评", for: .normal)
        addBookButton.contentHorizontalAlignment = .left
        addBookButton.addTarget(self, action: #selector(PushController.pushReviewAdditionController),
                                for: .touchUpInside)
        
        navigationView.addSubview(addBookButton)
    }
    
    func setupTableView() {
        tableView = UITableView(frame: view.frame)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.tableFooterView = UIView()
        tableView?.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
        
        guard let tableView = tableView else { return }
        view.addSubview(tableView)
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self,
                                                    refreshingAction: #selector(tableViewHeadeRefresh))
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self,
                                                        refreshingAction: #selector(tableViewFooterRefresh))
        tableView.mj_header.beginRefreshing()
    }
}

extension PushController {
    func tableViewHeadeRefresh() {
        let query = LCQuery(className: "BookReview")
        
        query.limit = 20
        query.skip = reviews.count
        query.whereKey("createdAt", .descending)
        
        guard let user = LCUser.current else { return }
        query.whereKey("user", .equalTo(user))
        
        query.find { result in
            if result.isSuccess {
                self.tableView?.mj_header.endRefreshing()
                self.reviews.removeAll()
                
                guard let objects = result.objects else { return }
                self.reviews.append(objects)
                
                self.tableView?.reloadData()
            } else {
                ProgressHUD.showError("获取书评列表错误，请重试！")
            }
        }
    }
    
    func tableViewFooterRefresh() {
        let query = LCQuery(className: "BookReview")
        
        query.limit = 20
        query.skip = reviews.count
        query.whereKey("createdAt", .descending)
        
        guard let user = LCUser.current else { return }
        query.whereKey("user", .equalTo(user))
        
        query.find { result in
            if result.isSuccess {
                self.tableView?.mj_footer.endRefreshing()
                
                guard let objects = result.objects else { return }
                self.reviews.append(objects)
                
                self.tableView?.reloadData()
            } else {
                ProgressHUD.showError("获取书评列表错误，请重试！")
            }
        }
    }
}

extension PushController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        
        
        return cell
    }
}

extension PushController {
    func pushReviewAdditionController() {
        let controller = ReviewAdditionController()
        
        GeneralFactory.addTitle("关闭", and: "发布", in: controller)
        
        present(controller, animated: true)
    }
}
