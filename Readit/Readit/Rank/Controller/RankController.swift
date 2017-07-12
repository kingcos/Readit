//
//  RankController.swift
//  Readit
//
//  Created by kingcos on 08/07/2017.
//  Copyright © 2017 kingcos. All rights reserved.
//

import UIKit
import AVOSCloud

class RankController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        checkUserLogin()
    }

}

extension RankController {
    func checkUserLogin() {
        if AVUser.current() == nil {
            let storyBoard = UIStoryboard(name: "Login", bundle: nil)
            let loginController = storyBoard.instantiateViewController(withIdentifier: ID_SB_LOGIN)
            
            present(loginController, animated: true)
        }
    }
}

extension RankController {
    func setupUI() {
        view.backgroundColor = .white
        
        
    }
}
