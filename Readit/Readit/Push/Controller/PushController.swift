//
//  PushController.swift
//  Readit
//
//  Created by kingcos on 08/07/2017.
//  Copyright © 2017 kingcos. All rights reserved.
//

import UIKit
import MJRefresh
import AVOSCloud
import Kingfisher
import ProgressHUD

class PushController: UIViewController {
    
    let cellIdentifier = "PushCell"
    
    var reviews = [AVObject]()
    var navigationView: UIView?
    var tableView: UITableView?

    override func viewDidAppear(_ animated: Bool) {
        navigationView?.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationView?.isHidden = true
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
        navigationView = UIView(frame: CGRect(x: 0.0, y: -20.0, width: SCREEN_WIDTH, height: 65))
        navigationView?.backgroundColor = .white
        
        guard let navigationView = navigationView else { return }
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
        tableView?.register(ReviewCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
        
        guard let tableView = tableView else { return }
        view.addSubview(tableView)
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self,
                                                    refreshingAction: #selector(tableViewHeadeRefresh))
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self,
                                                        refreshingAction: #selector(tableViewFooterRefresh))
        tableView.mj_header.beginRefreshing()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let controller = ReviewDetailController()
        controller.review = reviews[indexPath.row]
        controller.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension PushController {
    func tableViewHeadeRefresh() {
        let query = AVQuery(className: "BookReview")
        
        query.limit = 20
        query.order(byDescending: "createdAt")

        guard let user = AVUser.current() else { return }
        query.whereKey("user", equalTo: user)
        
        query.findObjectsInBackground { results, error in
            self.tableView?.mj_header.endRefreshing()
            
            if error == nil {
                self.reviews.removeAll()
                
                guard let objects = results as? [AVObject] else { return }
                self.reviews.append(contentsOf: objects)
                self.tableView?.reloadData()
            } else {
                ProgressHUD.showError("获取书评列表错误，请重试！")
            }
        }
    }
    
    func tableViewFooterRefresh() {
        let query = AVQuery(className: "BookReview")
        
        query.limit = 20
        query.skip = reviews.count
        query.order(byDescending: "createdAt")
        
        guard let user = AVUser.current() else { return }
        query.whereKey("user", equalTo: user)
        
        query.findObjectsInBackground { results, error in
            self.tableView?.mj_footer.endRefreshing()
            
            if error == nil {
                guard let objects = results as? [AVObject] else { return }
                self.reviews.append(contentsOf: objects)
                
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ReviewCell
        let object = reviews[indexPath.row]
        
        if let bookName = object["bookName"] as? String,
           let bookEditor = object["bookEditor"] as? String,
           let date = object["createdAt"] as? Date,
           let bookCoverURL = (object["bookCover"] as? AVFile)?.url {
            
            cell?.bookNameLabel?.text = "《\(bookName)》"
            cell?.bookEditorLabel?.text = "作者：\(bookEditor)"
            
            let format = DateFormatter()
            
            format.dateFormat = "yyyy-MM-dd hh:mm"
            cell?.moreLabel?.text = format.string(from: date)
            
            cell?.coverImageView?.kf.setImage(with: URL(string: bookCoverURL), placeholder: #imageLiteral(resourceName: "Cover.png"))
        }
        
        return cell!
    }
}

extension PushController {
    func pushReviewAdditionController() {
        let controller = ReviewAdditionController()
        
        GeneralFactory.addTitle("关闭", and: "发布", in: controller)
        
        present(controller, animated: true)
    }
}
