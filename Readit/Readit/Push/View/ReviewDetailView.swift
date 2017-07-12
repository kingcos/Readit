//
//  ReviewDetailView.swift
//  Readit
//
//  Created by kingcos on 11/07/2017.
//  Copyright © 2017 kingcos. All rights reserved.
//

import UIKit

class ReviewDetailView: UIView {
    
    var VIEW_WIDTH: CGFloat!
    var VIEW_HEIGHT: CGFloat!
    
    var bookNameLabel: UILabel?
    var bookEditorLabel: UILabel?
    var userNameLabel: UILabel?
    var dateLabel: UILabel?
    var moreLabel: UILabel?
    var coverImageView: UIImageView?
    var reviewScore: LDXScore?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        VIEW_WIDTH = frame.width
        VIEW_HEIGHT = frame.height
        
        bookNameLabel = UILabel(frame: CGRect(x: (VIEW_HEIGHT - 16.0) / 1.273 + 16.0,
                                              y: 8.0,
                                              width: VIEW_WIDTH - (VIEW_HEIGHT - 16.0) / 1.273 - 16.0,
                                              height: VIEW_HEIGHT / 4.0))
        bookEditorLabel = UILabel(frame: CGRect(x: (VIEW_HEIGHT - 16.0) / 1.273 + 16.0,
                                              y: 8.0 + VIEW_HEIGHT / 4.0,
                                              width: VIEW_WIDTH - (VIEW_HEIGHT - 16.0) / 1.273 - 16.0,
                                              height: VIEW_HEIGHT / 4.0))
        coverImageView = UIImageView(frame: CGRect(x: 8.0,
                                                   y: 8.0,
                                                   
                                                   width: (VIEW_HEIGHT - 16.0) / 1.273,
                                                   
                                                   height: VIEW_HEIGHT - 16.0))
        userNameLabel = UILabel(frame: CGRect(x: (VIEW_HEIGHT - 16.0) / 1.273 + 16.0,
                                              y: 24.0 + VIEW_HEIGHT / 4.0 + VIEW_HEIGHT / 6.0,
                                              width: VIEW_WIDTH - (VIEW_HEIGHT - 16.0) / 1.273 - 16.0,
                                              height: VIEW_HEIGHT / 6.0))
        userNameLabel?.textColor = UIColor(35.0, 87.0, 139.0)
        
        dateLabel = UILabel(frame: CGRect(x: (VIEW_HEIGHT - 16.0) / 1.273 + 16.0,
                                          y: 16.0 + VIEW_HEIGHT / 4.0 + VIEW_HEIGHT / 6.0 * 2.0,
                                          width: 120.0,
                                          height: VIEW_HEIGHT / 6.0))
        dateLabel?.textColor = .gray
        
        reviewScore = LDXScore(frame: CGRect(x: (VIEW_HEIGHT - 16.0) / 1.273 + 16.0 + 120.0,
                                             y: 16.0 + VIEW_HEIGHT / 4.0 + VIEW_HEIGHT / 6.0 * 2.0,
                                             width: 80.0,
                                             height: VIEW_HEIGHT / 6.0))
        reviewScore?.isSelect = false
        reviewScore?.normalImg = #imageLiteral(resourceName: "btn_star_evaluation_normal")
        reviewScore?.highlightImg = #imageLiteral(resourceName: "btn_star_evaluation_press")
        reviewScore?.max_star = 5
        reviewScore?.show_star = 5
        
        moreLabel = UILabel(frame: CGRect(x: (VIEW_HEIGHT - 16.0) / 1.273 + 16.0,
                                          y: 8.0 + VIEW_HEIGHT / 4.0 + VIEW_HEIGHT / 6.0 * 3.0,
                                          width: VIEW_WIDTH - (VIEW_HEIGHT - 16.0) / 1.273 - 16.0,
                                          height: VIEW_HEIGHT / 6.0))
        moreLabel?.textColor = .gray
        
        guard let bookNameLabel = bookNameLabel,
              let bookEditorLabel = bookEditorLabel,
              let coverImageView = coverImageView,
              let userNameLabel = userNameLabel,
              let dateLabel = dateLabel,
              let reviewScore = reviewScore,
              let moreLabel = moreLabel else { return }
        addSubview(bookNameLabel)
        addSubview(bookEditorLabel)
        addSubview(coverImageView)
        addSubview(userNameLabel)
        addSubview(dateLabel)
        addSubview(reviewScore)
        addSubview(moreLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(0.5)
        context?.setStrokeColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 1.0)
        context?.move(to: CGPoint(x: 8.0, y: VIEW_HEIGHT - 2.0))
        context?.addLine(to: CGPoint(x: VIEW_WIDTH - 8.0, y: VIEW_HEIGHT - 2.0))
        context?.strokePath()
    }
    
}
