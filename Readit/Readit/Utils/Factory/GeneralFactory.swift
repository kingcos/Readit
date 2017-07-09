//
//  GeneralFactory.swift
//  Readit
//
//  Created by kingcos on 08/07/2017.
//  Copyright © 2017 kingcos. All rights reserved.
//

import UIKit

class GeneralFactory: NSObject {
    
    class func addTitle(_ title1: String = "关闭",
                        and title2: String = "确认",
                        in controller: UIViewController) {
        
        let button1 = UIButton(frame: CGRect(x: 10.0, y: 25.0, width: 40.0, height: 20.0))
        button1.setTitle(title1, for: .normal)
        button1.contentHorizontalAlignment = .left
        button1.setTitleColor(COLOR_MAIN_RED, for: .normal)
        button1.tag = 1000
        
        controller.view.addSubview(button1)
        
        let button2 = UIButton(frame: CGRect(x: SCREEN_WIDTH - 50.0, y: 25.0, width: 40.0, height: 20.0))
        button2.setTitle(title2, for: .normal)
        button2.contentHorizontalAlignment = .right
        button2.setTitleColor(COLOR_MAIN_RED, for: .normal)
        button2.tag = 1001
        
        controller.view.addSubview(button2)
        
        button1.addTarget(controller, action: #selector(UIViewController.close), for: .touchUpInside)
        button2.addTarget(controller, action: #selector(UIViewController.sure), for: .touchUpInside)
    }
    
}

