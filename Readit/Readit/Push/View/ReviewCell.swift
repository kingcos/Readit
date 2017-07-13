//
//  ReviewCell.swift
//  Readit
//
//  Created by kingcos on 10/07/2017.
//  Copyright © 2017 kingcos. All rights reserved.
//

import UIKit

class ReviewCell: SWTableViewCell {
    
    var bookNameLabel: UILabel?
    var bookEditorLabel: UILabel?
    var moreLabel: UILabel?
    var coverImageView: UIImageView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        
        bookNameLabel = UILabel(frame: CGRect(x: 78.0, y: 8.0,
                                              width: 242.0, height: 25.0))
        bookEditorLabel = UILabel(frame: CGRect(x: 78.0, y: 33.0,
                                                width: 242.0, height: 25.0))
        moreLabel = UILabel(frame: CGRect(x: 78.0, y: 66.0,
                                          width: 242.0, height: 25.0))
        
        moreLabel?.textColor = .gray
        
        coverImageView = UIImageView(frame: CGRect(x: 8.0, y: 9.0,
                                                   width: 56.0, height: 78.0))
        
        guard let bookNameLabel = bookNameLabel,
            let bookEditorLabel = bookEditorLabel,
            let moreLabel = moreLabel,
            let coverImageView = coverImageView else { return }
        
        contentView.addSubview(bookNameLabel)
        contentView.addSubview(bookEditorLabel)
        contentView.addSubview(moreLabel)
        contentView.addSubview(coverImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
