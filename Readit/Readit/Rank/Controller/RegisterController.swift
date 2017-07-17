//
//  RegisterController.swift
//  Readit
//
//  Created by kingcos on 10/07/2017.
//  Copyright © 2017 kingcos. All rights reserved.
//

import UIKit
import AVOSCloud
import ProgressHUD

class RegisterController: UIViewController {

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    deinit {
        print("RegisterController", #function)
    }
}

extension RegisterController {
    func setupUI() {
        setupTextFields()
    }
    
    func setupTextFields() {
        XKeyBoard.registerHide(self)
        XKeyBoard.registerShow(self)
    }
}

extension RegisterController {
    func keyboardWillHideNotification(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.topConstraint.constant = 10.0
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillShowNotification(_ notification: Notification) {
        self.topConstraint.constant = -200.0
        self.view.layoutIfNeeded()
    }
}

extension RegisterController {
    @IBAction func registerButtonClick(_ sender: UIButton) {
        guard let userName = userNameTextField.text,
              let password = passwordTextField.text,
              let email = emailTextField.text else { return }
        
        let user = AVUser()
        
        user.username = userName
        user.password = password
        user.email = email
        
        user.signUpInBackground { result, error in
            if result {
                ProgressHUD.showSuccess("注册成功，请验证邮箱！")
                self.dismiss(animated: true)
            } else {
                var errorDesc = "注册失败，未知错误。"
                
                if let code = (error as NSError?)?.code {
                    switch code {
                    case 125:
                        errorDesc = "邮箱不合法！"
                    case 203:
                        errorDesc = "邮箱已注册！"
                    case 202:
                        errorDesc = "用户名已存在！"
                    default:
                        break
                    }
                }
                
                ProgressHUD.showError(errorDesc)
            }
        }
    }
    
    @IBAction func closeButtonClick(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
