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

class ReviewDetailController: UIViewController {
    
    var review: AVObject?
    var reviewDetailView: ReviewDetailView?

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
    
}

