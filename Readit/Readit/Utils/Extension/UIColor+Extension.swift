//
//  UIColor+Extension.swift
//  Readit
//
//  Created by kingcos on 09/07/2017.
//  Copyright © 2017 kingcos. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ alpha: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
}
