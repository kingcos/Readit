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
    var commentInputView: InputView?
    var maskView: UIView?
    var keyboardHeight: CGFloat = 0.0
    
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
        
        review?.incrementKey("scanNumber")
        review?.saveInBackground()
        
        guard let bookCoverURL = (review?["bookCover"] as? AVFile)?.url,
        let bookName = review?["bookName"] as? String,
        let bookEditor = review?["bookEditor"] as? String,
        let user = review?["user"] as? AVUser,
        let date = review?["createdAt"] as? Date,
        let reviewScore = review?["reviewScore"] as? Int,
        let scanNumber = review?["scanNumber"] as? NSNumber,
        let likeNumber = review?["likeNumber"] as? NSNumber,
        let commentNumber = review?["commentNumber"] as? NSNumber else { return }
        
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
        reviewDetailView.moreLabel?.text = "喜欢:\(likeNumber.intValue) 评论:\(commentNumber.intValue) 浏览:\(scanNumber.intValue)"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectPhotoBrowser))
        reviewDetailView.coverImageView?.addGestureRecognizer(tap)
        reviewDetailView.coverImageView?.isUserInteractionEnabled = true
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
        if commentInputView == nil {
            commentInputView = Bundle.main.loadNibNamed("InputView", owner: self, options: nil)?.last as? InputView
            commentInputView?.frame = CGRect(x: 0.0,
                                             y: SCREEN_WIDTH - 44.0,
                                             width: SCREEN_WIDTH,
                                             height: 44.0)
            commentInputView?.delegate = self
            
            guard let commentInputView = commentInputView else { return }
            view.addSubview(commentInputView)
        }
        
        if maskView == nil {
            maskView = UIView(frame: view.frame)
            maskView?.backgroundColor = .gray
            maskView?.alpha = 0
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(maskViewTapped))
            maskView?.addGestureRecognizer(tap)
        }
        
        guard let maskView = maskView,
              let commentInputView = commentInputView else { return }
        view.insertSubview(maskView, belowSubview: commentInputView)
        maskView.isHidden = false
        commentInputView.inputTextView.becomeFirstResponder()
    }
    
    func commentAreaButtonClick() {
        let controller = CommentAreaController()
        GeneralFactory.addTitle("", and: "关闭", in: controller)
        
        controller.review = review
        controller.tableView?.mj_header.beginRefreshing()
        
        present(controller, animated: true)
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
                review.incrementKey("likeNumber", byAmount: NSNumber(value: -1))
                review.saveInBackground()
            } else {
                let object = AVObject(className: "Like")
                object.setObject(AVUser.current(), forKey: "user")
                object.setObject(review, forKey: "review")
                
                object.saveInBackground({ result, error in
                    if result {
                        sender.setImage(#imageLiteral(resourceName: "solidheart"), for: .normal)
                        
                        review.incrementKey("likeNumber")
                        review.saveInBackground()
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
    
    func maskViewTapped() {
        commentInputView?.inputTextView.resignFirstResponder()
    }
    
    func selectPhotoBrowser() {
        let photoBrowser = HZPhotoBrowser()
        photoBrowser.imageCount = 1
        photoBrowser.currentImageIndex = 0
        photoBrowser.delegate = self
        photoBrowser.show()
    }
}

extension ReviewDetailController: HZPhotoBrowserDelegate {
    func photoBrowser(_ browser: HZPhotoBrowser!, placeholderImageFor index: Int) -> UIImage! {
        return reviewDetailView?.coverImageView?.image
    }
    
    func photoBrowser(_ browser: HZPhotoBrowser!, highQualityImageURLFor index: Int) -> URL! {
        let coverFile = review?["bookCover"] as? AVFile
        return URL(string: (coverFile?.url)!)
    }
}

extension ReviewDetailController: InputViewDelegate {
    func keyboardWillHide(_ inputView: InputView!, keyboardHeight: CGFloat, animationDuration duration: TimeInterval, animationCurve: UIViewAnimationCurve) {
        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       options: .beginFromCurrentState,
                       animations: {
                       guard let height = self.commentInputView?.height else { return }
                       self.commentInputView?.bottom = SCREEN_HEIGHT + height
                       self.maskView?.alpha = 0
        }, completion: { finish in
            self.maskView?.isHidden = true
        })
    }
    
    func keyboardWillShow(_ inputView: InputView!, keyboardHeight: CGFloat, animationDuration duration: TimeInterval, animationCurve: UIViewAnimationCurve) {
        self.keyboardHeight = keyboardHeight
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: .beginFromCurrentState,
                       animations: {
                        self.commentInputView?.bottom = SCREEN_HEIGHT - keyboardHeight
                        self.maskView?.alpha = 0.2
        }, completion: nil)
    }
    
    func textViewHeightDidChange(_ height: CGFloat) {
        commentInputView?.height = height + 10.0
        commentInputView?.bottom = SCREEN_HEIGHT - keyboardHeight
    }
    
    func publishButtonDidClick(_ button: UIButton!) {
        ProgressHUD.show("")
        
        let comment = AVObject(className: "Comment")
        comment.setObject(commentInputView?.inputTextView.text, forKey: "text")
        comment.setObject(AVUser.current(), forKey: "user")
        comment.setObject(review, forKey: "review")
        comment.saveInBackground { result, error in
            if result {
                self.commentInputView?.inputTextView.text.removeAll()
                self.commentInputView?.inputTextView.resignFirstResponder()
                ProgressHUD.showSuccess("评论成功")
                
                self.review?.incrementKey("commentNumber")
                self.review?.saveInBackground()
            } else {
                ProgressHUD.showError("操作失败")
            }
        }
    }
}
