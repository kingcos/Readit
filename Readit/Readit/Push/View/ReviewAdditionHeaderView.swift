//
//  ReviewAdditionHeaderView.swift
//  Readit
//
//  Created by kingcos on 08/07/2017.
//  Copyright © 2017 kingcos. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

protocol ReviewAdditionHeaderViewDelegate: class {
    func selectCover()
}

extension ReviewAdditionHeaderViewDelegate {
    func selectCover() {
        fatalError("selectCover has not been implemented")
    }
}

class ReviewAdditionHeaderView: UIView {

    var bookCover: UIButton?
    var bookName: JVFloatLabeledTextField?
    var bookEditor: JVFloatLabeledTextField?
    
    weak var delegate: ReviewAdditionHeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ReviewAdditionHeaderView {
    func initUI() {
        bookCover = UIButton(frame: CGRect(x: 10.0, y: 0.0, width: 110.0, height: 141.0))
        bookCover?.setImage(#imageLiteral(resourceName: "Cover.png"), for: .normal)
        bookCover?.addTarget(self, action: #selector(selectCover), for: .touchUpInside)
        
        bookName = JVFloatLabeledTextField(frame: CGRect(x: 128.0,
                                                         y: 8.0 + 40.0,
                                                         width: SCREEN_WIDTH - 128.0 - 15.0,
                                                         height: 30.0))
        bookName?.placeholder = "书名"
        
        bookEditor = JVFloatLabeledTextField(frame: CGRect(x: 128.0,
                                                           y: 8.0 + 40.0 + 70.0,
                                                           width: SCREEN_WIDTH - 128.0 - 15.0,
                                                           height: 30.0))
        bookEditor?.placeholder = "作者"
        
        guard let bookCover = bookCover else { return }
        guard let bookName = bookName else { return }
        guard let bookEditor = bookEditor else { return }
        
        addSubview(bookCover)
        addSubview(bookName)
        addSubview(bookEditor)
    }
}

extension ReviewAdditionHeaderView {
    func selectCover() {
        delegate?.selectCover()
    }
}
