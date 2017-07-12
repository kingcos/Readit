//
//  BookReview.swift
//  Readit
//
//  Created by kingcos on 10/07/2017.
//  Copyright © 2017 kingcos. All rights reserved.
//

import UIKit
import AVOSCloud

class BookReview: NSObject {
    class func pushReviewBy(_ dict: [String: Any]) {
        guard let bookName = dict["bookName"] as? String,
              let bookEditor = dict["bookEditor"] as? String,
              let reviewTitle = dict["reviewTitle"] as? String,
              let reviewScore = dict["reviewScore"] as? Int,
              let reviewCurrentType = dict["reviewCurrentType"] as? String,
              let reviewDetailType = dict["reviewDetailType"] as? String,
              let reviewContent = dict["reviewContent"] as? String,
              let image = dict["bookCover"] as? UIImage,
              let bookCover = UIImagePNGRepresentation(image) else { return }
        
        let object = AVObject(className: "BookReview")
        
        object.setObject(bookName, forKey: "bookName")
        object.setObject(bookEditor, forKey: "bookEditor")
        object.setObject(reviewTitle, forKey: "reviewTitle")
        object.setObject(reviewScore, forKey: "reviewScore")
        object.setObject(reviewCurrentType, forKey: "reviewCurrentType")
        object.setObject(reviewDetailType, forKey: "reviewDetailType")
        object.setObject(reviewContent, forKey: "reviewContent")
        object.setObject(AVUser.current(), forKey: "user")

        let coverFile = AVFile(data: bookCover)
        coverFile.saveInBackground { success, error in
            if success {
                object.setObject(coverFile, forKey: "bookCover")
                object.saveEventually { success, error in
                    if success {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addedReview"),
                                                                                  object: nil,
                                                                                  userInfo:  ["success": "true"])
                    } else {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addedReview"),
                                                        object: nil,
                                                        userInfo: ["success": "false"])
                    }
                }
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addedReview"),
                                                object: nil,
                                                userInfo: ["success": "false"])
            }
        }
    }
}
