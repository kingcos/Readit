//
//  ReviewTabBarView.swift
//  Readit
//
//  Created by kingcos on 12/07/2017.
//  Copyright © 2017 kingcos. All rights reserved.
//

import UIKit


protocol ReviewTabBarViewDelegate: class {
    func writeCommentButtonClick()
    
    func commentAreaButtonClick()
    
    func likeButtonClick(_ sender: UIButton)
    
    func shareButtonClick()
}

class ReviewTabBarView: UIView {
    
    weak var delegate: ReviewTabBarViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        let images = [#imageLiteral(resourceName: "Pen 4"), #imageLiteral(resourceName: "chat 3"), #imageLiteral(resourceName: "heart"), #imageLiteral(resourceName: "box outgoing")]
        
        for i in 0 ..< 4 {
            let frame = CGRect(x: CGFloat(i) * frame.width / 4.0,
                               y: 0.0,
                               width: frame.width / 4.0,
                               height: frame.height)
            let button = UIButton(frame: frame)
            button.setImage(images[i], for: .normal)
            button.tag = 2000 + i
            button.addTarget(self, action: #selector(reviweTabBarButtonClick(_:)), for: .touchUpInside)
            
            addSubview(button)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(0.5)
        context?.setStrokeColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 1.0)
        
        for i in 0 ..< 3 {
            context?.move(to: CGPoint(x: CGFloat(i) * rect.width / 4.0,
                                      y: rect.height * 0.1))
            context?.addLine(to: CGPoint(x: CGFloat(i) * rect.width / 4.0,
                                         y: rect.height * 0.9))
        }
        
        context?.move(to: CGPoint(x: 8.0, y: 0.0))
        context?.addLine(to: CGPoint(x: rect.width - 8.0, y: 0.0))
        
        context?.strokePath()
    }
 

}

extension ReviewTabBarView {
    func reviweTabBarButtonClick(_ sender: UIButton) {
        switch sender.tag {
        case 2000:
            delegate?.writeCommentButtonClick()
        case 2001:
            delegate?.commentAreaButtonClick()
        case 2002:
            delegate?.likeButtonClick(sender)
        case 2003:
            delegate?.shareButtonClick()
        default:
            break
        }
    }
}
