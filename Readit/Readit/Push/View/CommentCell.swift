//
//  CommentCell.swift
//  Readit
//
//  Created by kingcos on 13/07/2017.
//  Copyright © 2017 kingcos. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    var avatarImageView: UIImageView?
    var userNameLabel: UILabel?
    var detailLabel: UILabel?
    var dateLabel: UILabel?

}

extension CommentCell {
    func setup() {
        for subview in contentView.subviews {
            subview.removeFromSuperview()
        }
        
        avatarImageView = UIImageView(frame: CGRect(x: 8.0, y: 8.0, width: 40.0, height: 40.0))
        avatarImageView?.layer.cornerRadius = 20.0
        avatarImageView?.layer.masksToBounds = true
        
        userNameLabel = UILabel(frame: CGRect(x: 56.0,
                                              y: 8.0,
                                              width: SCREEN_WIDTH - 56.0 - 8.0,
                                              height: 20.0))
        
        dateLabel = UILabel(frame: CGRect(x: 56.0,
                                          y: height - 8.0 - 10.0,
                                          width: SCREEN_WIDTH - 56.0 - 8.0,
                                          height: 15.0))
        
        detailLabel = UILabel(frame: CGRect(x: 56.0,
                                            y: 30.0,
                                            width: SCREEN_WIDTH - 56.0 - 8.0,
                                            height: height - 20.0 - 35.0))
        detailLabel?.numberOfLines = 0
        
        guard let avatarImageView = avatarImageView,
            let userNameLabel = userNameLabel,
            let dateLabel = dateLabel,
            let detailLabel = detailLabel else { return }
        contentView.addSubview(avatarImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(detailLabel)
    }
}
