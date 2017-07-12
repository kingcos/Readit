//
//  ReviewDetailController.swift
//  Readit
//
//  Created by kingcos on 11/07/2017.
//  Copyright © 2017 kingcos. All rights reserved.
//

import UIKit
import AVOSCloud
import Kingfisher
import ProgressHUD

class ReviewDetailController: UIViewController {
    
    var review: AVObject?
    var reviewDetailView: ReviewDetailView?
    var reviewTabBarView: ReviewTabBarView?
    var reviewTextView: UITextView?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

}

extension ReviewDetailController {
    func setupUI() {
        view.backgroundColor = .white
        
        navigationController?.navigationBar.tintColor = .gray
        
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -80.0), for: .default)
        
        setupReviewDetailView()
        setupTabBarView()
        setupTextView()
        
        isLikedOrNot()
    }
    
    func setupReviewDetailView() {
        reviewDetailView = ReviewDetailView(frame: CGRect(x: 0.0,
                                                          y: 64.0,
                                                          width: SCREEN_WIDTH,
                                                          height: SCREEN_HEIGHT / 4.0))
        guard let reviewDetailView = reviewDetailView else { return }
        view.addSubview(reviewDetailView)
        
        guard let bookCoverURL = (review?["bookCover"] as? AVFile)?.url,
        let bookName = review?["bookName"] as? String,
        let bookEditor = review?["bookEditor"] as? String,
        let user = review?["user"] as? AVUser,
        let date = review?["createdAt"] as? Date,
        let reviewScore = review?["reviewScore"] as? Int else { return }
        
        reviewDetailView.coverImageView?.kf.setImage(with: URL(string: bookCoverURL))
        reviewDetailView.bookNameLabel?.text = "《\(bookName)》"
        reviewDetailView.bookEditorLabel?.text = "作者：\(bookEditor)"
        
        user.fetchInBackground { result, error in
            guard let username = (result as? AVUser)?.username else { return }
            self.reviewDetailView?.userNameLabel?.text = "编者：\(username)"
        }
        
        let format = DateFormatter()
        format.dateFormat = "yy-MM-dd hh:mm"
        reviewDetailView.dateLabel?.text = format.string(from: date)
        
        reviewDetailView.reviewScore?.show_star = reviewScore
        reviewDetailView.moreLabel?.text = "喜欢:100 评论:199 浏览:19999"
    }
    
    func setupTabBarView() {
        let frame = CGRect(x: 0.0,
                           y: SCREEN_HEIGHT - 40.0,
                           width: SCREEN_WIDTH,
                           height: 40.0)
        reviewTabBarView = ReviewTabBarView(frame: frame)
        reviewTabBarView?.delegate = self
        guard let reviewTabBarView = reviewTabBarView else { return }
        view.addSubview(reviewTabBarView)
    }
    
    func setupTextView() {
        let frame = CGRect(x: 0.0,
                           y: 64.0 + SCREEN_HEIGHT / 4.0,
                           width: SCREEN_WIDTH,
                           height: SCREEN_HEIGHT - 64.0 - SCREEN_HEIGHT / 4.0 - 40.0)
        reviewTextView = UITextView(frame: frame)
        reviewTextView?.isEditable = false
        
        guard let content = review?["reviewContent"] as? String,
              let reviewTextView = reviewTextView else { return }
        
        reviewTextView.text = content
        view.addSubview(reviewTextView)
    }
}

extension ReviewDetailController: ReviewTabBarViewDelegate {
    func writeCommentButtonClick() {
        print(#function)
    }
    
    func commentAreaButtonClick() {
        print(#function)
    }
    
    func likeButtonClick(_ sender: UIButton) {
        sender.isEnabled = false
        sender.setImage(#imageLiteral(resourceName: "redheart"), for: .normal)
        
        guard let user = AVUser.current(),
              let review = review else { return }
        
        let query = AVQuery(className: "Like")
        
        query.whereKey("user", equalTo: user)
        query.whereKey("review", equalTo: review)
        
        query.findObjectsInBackground { results, error in
            guard error == nil else {
                ProgressHUD.showError("操作失败")
                return
            }
            guard let results = results as? [AVObject] else { return }
            
            if results.count != 0 {
                for result in results {
                    result.deleteEventually()
                }
                sender.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
            } else {
                let object = AVObject(className: "Like")
                object.setObject(AVUser.current(), forKey: "user")
                object.setObject(review, forKey: "review")
                
                object.saveInBackground({ result, error in
                    if result {
                        sender.setImage(#imageLiteral(resourceName: "solidheart"), for: .normal)
                    } else {
                        ProgressHUD.showError("操作失败")
                    }
                })
            }
        
            sender.isEnabled = true
        }
    }
    
    func shareButtonClick() {
        print(#function)
    }
}

extension ReviewDetailController {
    func isLikedOrNot() {
        guard let user = AVUser.current(),
              let review = review else { return }
        
        let query = AVQuery(className: "Like")
        
        query.whereKey("user", equalTo: user)
        query.whereKey("review", equalTo: review)
        
        query.findObjectsInBackground { results, error in
            if error == nil {
                if results != nil && results?.count != 0 {
                    let button = self.reviewTabBarView?.viewWithTag(2002) as? UIButton
                    button?.setImage(#imageLiteral(resourceName: "solidheart"), for: .normal)
                }
            } else {
                ProgressHUD.showError("操作失败")
            }
        }
    }
}
