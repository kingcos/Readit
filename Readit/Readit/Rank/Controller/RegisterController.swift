//
//  RegisterController.swift
//  Readit
//
//  Created by kingcos on 10/07/2017.
//  Copyright © 2017 kingcos. All rights reserved.
//

import UIKit
import LeanCloud

class RegisterController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension RegisterController {
    @IBAction func registerButtonClick(_ sender: UIButton) {
        let user = LCUser()
        
        guard let userName = userNameTextField.text,
              let password = passwordTextField.text,
              let email = emailTextField.text else { return }
        
        user.username = LCString(userName)
        user.password = LCString(password)
        user.email = LCString(email)
        
        user.signUp { result in
            if result.isSuccess {
                
            } else {
                
            }
        }
    }
    
    @IBAction func closeButtonClick(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
