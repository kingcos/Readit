//
//  CommentAreaController.swift
//  Readit
//
//  Created by kingcos on 13/07/2017.
//  Copyright © 2017 kingcos. All rights reserved.
//

import UIKit
import AVOSCloud
import MJRefresh

class CommentAreaController: UIViewController {

    var tableView: UITableView?
    var comments = [AVObject]()
    var review: AVObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let button = view.viewWithTag(1000)
        button?.removeFromSuperview()
    }
}

extension CommentAreaController {
    func setupUI() {
        view.backgroundColor = .white
        
        let titleLabel = UILabel(frame: CGRect(x: 0.0,
                                               y: 20.0,
                                               width: SCREEN_WIDTH,
                                               height: 44.0))
        titleLabel.text = "讨论区"
        titleLabel.textAlignment = .center
        titleLabel.textColor = COLOR_MAIN_RED
        view.addSubview(titleLabel)
        
        tableView = UITableView(frame: CGRect(x: 0.0,
                                              y: 64.0,
                                              width: SCREEN_WIDTH,
                                              height: SCREEN_HEIGHT - 64.0 - 44.0))
        tableView?.register(CommentCell.classForCoder(), forCellReuseIdentifier: "Cell")
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.tableFooterView = UIView()
        
        guard let tableView = tableView else { return }
        view.addSubview(tableView)
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
        tableView.mj_footer = MJRefreshBackFooter(refreshingTarget: self, refreshingAction: #selector(footerRefresh))
    }
}

extension CommentAreaController {
    func headerRefresh() {
        guard let user = AVUser.current(),
        let review = review else { return }
        
        let query = AVQuery(className: "Comment")
        
        query.order(byDescending: "createdAt")
        query.limit = 20
        query.whereKey("user", equalTo: user)
        query.whereKey("review", equalTo: review)
        query.includeKey("user")
        query.includeKey("review")
        
        query.findObjectsInBackground { results, error in
            self.tableView?.mj_header.endRefreshing()
            
            guard let results = results as? [AVObject] else { return }
            
            self.comments.removeAll()
            self.comments.append(contentsOf: results)
            self.tableView?.reloadData()
        }
    }
    
    func footerRefresh() {
        guard let user = AVUser.current(),
            let review = review else { return }
        
        let query = AVQuery(className: "Comment")
        
        query.order(byDescending: "createdAt")
        query.limit = 20
        query.skip = comments.count
        query.whereKey("user", equalTo: user)
        query.whereKey("review", equalTo: review)
        query.includeKey("user")
        query.includeKey("review")
        
        query.findObjectsInBackground { results, error in
            self.tableView?.mj_footer.endRefreshing()
            
            guard let results = results as? [AVObject] else { return }
            
            self.comments.append(contentsOf: results)
            self.tableView?.reloadData()
        }
    }
}

extension CommentAreaController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CommentCell
        cell.setup()
        
        let comment = comments[indexPath.row]
        let user = comment["user"] as? AVUser
        
        cell.userNameLabel?.text = user?.username
        cell.avatarImageView?.image = #imageLiteral(resourceName: "Avatar.png")
        
        let date = comment["createdAt"] as? Date ?? Date()
        let format = DateFormatter()
        
        format.dateFormat = "yyyy-MM-dd hh:mm"
        
        cell.dateLabel?.text = format.string(from: date)
        cell.detailLabel?.text = comment["text"] as? String ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let comment = comments[indexPath.row]
        let text = comment["text"] as? String
        let textSize = text?.boundingRect(with: CGSize(width: SCREEN_WIDTH - 56.0 - 8.0, height: 0.0),
                                          options: .usesLineFragmentOrigin,
                                          attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17.0)],
                                          context: nil).size
        return textSize!.height + 30 + 25
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CommentAreaController {
    override func sure() {
        dismiss(animated: true)
    }
}
