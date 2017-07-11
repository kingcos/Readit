//
//  BookReview.swift
//  Readit
//
//  Created by kingcos on 10/07/2017.
//  Copyright © 2017 kingcos. All rights reserved.
//

import UIKit
import LeanCloud

class BookReview: NSObject {
    class func pushReviewBy(_ dict: [String: Any]) {
        guard let bookName = dict["bookName"] as? String,
              let bookEditor = dict["bookEditor"] as? String,
              let reviewTitle = dict["reviewTitle"] as? String,
              let reviewScore = dict["reviewScore"] as? String,
              let reviewCurrentType = dict["reviewCurrentType"] as? String,
              let reviewDetailType = dict["reviewDetailType"] as? String,
              let reviewContent = dict["reviewContent"] as? String,
              let image = dict["bookCover"] as? UIImage,
              let bookCover = UIImagePNGRepresentation(image) else { return }
        
        let object = LCObject(className: "BookReview")
        object.set("bookCover", value: bookCover)
        object.save { result in
            if result.isSuccess {
                object.set("bookName", value: bookName)
                object.set("bookEditor", value: bookEditor)
                object.set("reviewTitle", value: reviewTitle)
                object.set("reviewScore", value: reviewScore)
                object.set("reviewCurrentType", value: reviewCurrentType)
                object.set("reviewDetailType", value: reviewDetailType)
                object.set("reviewContent", value: reviewContent)
                
                object.set("user", value: LCUser.current)
                
                object.save { result in
                    if result.isSuccess {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addedReview"),
                                                        object: nil,
                                                        userInfo:  ["success": "true"])
                    } else {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addedReview"),
                                                        object: nil,
                                                        userInfo: ["success": "false"])
                    }
                }
            }
        }
    }
}
